import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../user/user_home_screen.dart';
import '../manager/manager_home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user!.uid;

      // Sprawdzenie roli: user czy manager
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final managerDoc =
          await FirebaseFirestore.instance
              .collection('managers')
              .doc(uid)
              .get();

      if (userDoc.exists) {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            // MaterialPageRoute(builder: (_) => const UserHomeScreen()),
            MaterialPageRoute(
              builder:
                  (_) => Scaffold(
                    body: Center(child: Text('Użytkownik zalogowany')),
                  ),
            ),
          );
        }
      } else if (managerDoc.exists) {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            // MaterialPageRoute(builder: (_) => const ManagerHomeScreen()),
            MaterialPageRoute(
              builder:
                  (_) =>
                      Scaffold(body: Center(child: Text('Manager zalogowany'))),
            ),
          );
        }
      } else {
        throw Exception('Brak roli przypisanej do konta.');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Błąd logowania: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  void _navigateToRegister(bool isManager) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => RegisterScreen(isManager: isManager)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Logowanie')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator:
                    (value) =>
                        value != null && value.contains('@')
                            ? null
                            : 'Niepoprawny email',
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Hasło'),
                obscureText: true,
                validator:
                    (value) =>
                        value != null && value.length >= 6
                            ? null
                            : 'Minimum 6 znaków',
              ),
              const SizedBox(height: 24),
              _loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                    onPressed: _login,
                    child: const Text('Zaloguj się'),
                  ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => _navigateToRegister(false),
                child: const Text(
                  'Nie masz konta? Zarejestruj się jako użytkownik',
                ),
              ),
              TextButton(
                onPressed: () => _navigateToRegister(true),
                child: const Text('Zarejestruj się jako manager'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
