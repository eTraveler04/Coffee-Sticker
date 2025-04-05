✅ Plan budowy aplikacji z kodem zaproszenia
🧱 ETAP 1: Infrastruktura Firebase
 Firebase skonfigurowane dla iOS

 firebase_options.dart wygenerowany

 Ustawienie reguł dostępu Firestore (z uwzględnieniem ról)

👥 ETAP 2: Model danych
🔹 Kolekcja managers (1 dokument na managera)
json
Kopiuj
Edytuj
{
  "email": "admin@x.com",
  "role": "manager",
  "inviteCode": "ABCD1234",
  "stickerPrice": 20.0,
  "promotionActive": true,
  "discountPercent": 10
}
🔹 Kolekcja users (1 dokument na użytkownika)
json
Kopiuj
Edytuj
{
  "email": "user@x.com",
  "role": "user",
  "managerId": "uid_mgr_123",
  "balance": 0.0,
  "stickers": 0
}
🔐 ETAP 3: Autoryzacja
 Logowanie i rejestracja (email + hasło)

 Rozpoznawanie roli użytkownika (role: user / manager)

 Rejestracja użytkownika z kodem zaproszenia:

użytkownik wpisuje kod,

aplikacja wyszukuje managera,

przypisuje managerId

📲 ETAP 4: Funkcje użytkownika
 Formularz: "Dodaj wpłatę"

Kwota

Zdjęcie paragonu (image_picker)

Status = "pending"

 Historia wpłat

 Zakup naklejek:

Odczyt stickerPrice od managera

Przeliczenie naklejek

Aktualizacja balance i stickers

🛠️ ETAP 5: Funkcje managera
 Panel zatwierdzania wpłat

Lista wpłat status == "pending" od użytkowników przypisanych do managera

Akceptuj / Odrzuć

 Formularz: "Ustaw cenę naklejki i promocję"

Zapis do dokumentu managers/{uid}

 Generowanie / edycja kodu zaproszenia

🧾 ETAP 6: Dodatkowe rzeczy
 Reguły Firestore (wymagane role)

 UI: karta z naklejkami (siatka 10/10)

 Wysyłanie gotowej karty do managera

 Responsywność, walidacja, UX