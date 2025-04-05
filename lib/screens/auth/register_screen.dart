import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  final bool isManager;
  const RegisterScreen({super.key, this.isManager = false});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _inviteCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final inviteCode = _inviteCodeController.text.trim();

    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final uid = credential.user!.uid;

      if (widget.isManager) {
        // Tworzenie konta managera
        await FirebaseFirestore.instance.collection('managers').doc(uid).set({
          'email': email,
          'role': 'manager',
          'inviteCode': inviteCode,
          'stickerPrice': 20.0,
          'promotionActive': false,
          'discountPercent': 0,
        });
      } else {
        // Szukamy managera po kodzie zaproszenia
        final query =
            await FirebaseFirestore.instance
                .collection('managers')
                .where('inviteCode', isEqualTo: inviteCode)
                .limit(1)
                .get();

        if (query.docs.isEmpty) {
          throw Exception('Nieprawidłowy kod zaproszenia');
        }

        final managerId = query.docs.first.id;

        // Tworzenie konta użytkownika
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'email': email,
          'role': 'user',
          'managerId': managerId,
          'balance': 0.0,
          'stickers': 0,
        });
      }

      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Błąd: ${e.toString()}')));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isManager ? 'Rejestracja managera' : 'Rejestracja użytkownika',
        ),
      ),
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
              TextFormField(
                controller: _inviteCodeController,
                decoration: InputDecoration(
                  labelText:
                      widget.isManager
                          ? 'Ustaw kod zaproszenia'
                          : 'Kod zaproszenia od managera',
                ),
                validator:
                    (value) =>
                        value != null && value.isNotEmpty
                            ? null
                            : 'Wprowadź kod zaproszenia',
              ),
              const SizedBox(height: 24),
              _loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                    onPressed: _register,
                    child: const Text('Zarejestruj się'),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
