# Women's Safety Application

A Flutter app that helps women stay safe while travelling. It sends SOS alerts with your live location to trusted contacts, calls emergency services in one tap and links a woman with a guardian who can follow and chat.

## Features

- **SEND ALERT**: texts your current location to your trusted contacts in the background (`background_sms`, `geolocator`)
- **Trusted contacts**: pick from the phone's contacts and keep them in a local SQLite database
- **Emergency dial**: police, ambulance, fire brigade and government helplines
- **Live safe**: one tap opens nearby police stations, hospitals, pharmacies and bus stations in Maps
- **Guardian mode**: guardians register and link to up to five women, and the two sides chat in real time
- Safety tips carousel and motivational quotes
- Place reviews, so users can rate how safe a location feels
- Profile with a photo (Firebase Storage)

## Tech stack

- **Flutter** (Dart)
- **Firebase** Authentication, Cloud Firestore (users and chat) and Storage
- `sqflite` (contacts), `shared_preferences`
- `background_sms`, `flutter_phone_direct_caller`, `geolocator`, `geocoding`, `contacts_service`, `url_launcher`, `webview_flutter`

## Project structure

```
lib/
  woman/          woman registration, home and bottom tabs (contacts, chat, reviews, profile)
  guardian/       guardian registration and home
  chat_module/    real-time chat
  widgets/        emergency cards, live-safe cards, safe-home, carousel
  db/             SQLite and shared preferences
  model/ utils/ components/
```

## Getting started

1. Add your Firebase config files and enable Email/Password auth, Firestore and Storage.
2. Run on a **real Android device**: SMS, calls and contacts don't work in the emulator.
   ```bash
   flutter pub get
   flutter run
   ```
3. Grant the SMS, phone, contacts and location permissions when asked.
