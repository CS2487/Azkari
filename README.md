# Azkari – Daily Azkar Flutter App

[![Flutter](https://img.shields.io/badge/Flutter-3.16.8-blue?logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.2.5-blue?logo=dart&logoColor=white)](https://dart.dev/)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)

**Azkari** is a Flutter application that provides **daily morning and evening Azkar** reminders, with customizable notification times, vibration settings, and multilingual support (Arabic & English).  

---

## 📸 Screenshots

| (1) Morning Azkar | (2) Evening Azkar | (3) Settings | (4) Example Notification |
|------------------|-----------------|--------------|--------------------------|
| ![Morning](https://github.com/CS2487/Azkari/blob/main/assets/ScreenShoot/Screenshot%20(1).jpg?raw=true) | ![Evening](https://github.com/CS2487/Azkari/blob/main/assets/ScreenShoot/Screenshot%20(2).jpg?raw=true) | ![Settings](https://github.com/CS2487/Azkari/blob/main/assets/ScreenShoot/Screenshot%20(3).jpg?raw=true) | ![Notification](https://github.com/CS2487/Azkari/blob/main/assets/ScreenShoot/Screenshot%20(4).jpg?raw=true) |

> Add your own screenshots in the `ScreenShoot/` folder.


## 📦 Project Maintenance Guide

Follow these steps to ensure your Flutter project is clean, organized, and error-free before publishing or delivery.

### 1️⃣ Clean the Project
```bash
flutter clean

🚀 Features
☀️ Morning Azkar with authentic sources
🌙 Evening Azkar with references
⏰ Customizable Notification Times (Set your preferred reminder schedule)
🔊 Vibration Toggle (Enable/disable haptic feedback)
🌍 Multilingual UI (Arabic & English — auto or manual switch)
📱 Responsive Design (Works flawlessly on Android & iOS)
🧘 Minimalist & Calm UI for spiritual focus
📦 Project Maintenance Guide
Keep your codebase clean, professional, and production-ready with this maintenance checklist.

1️⃣ Clean Build Artifacts
flutter clean2️⃣ Fetch Dependencies
flutter pub get


///This is Important dart fix --apply And  dart format .
///#!/bin/bash
# اسم السكربت: precommit.sh
Copy into terminal and ./precommit.sh
echo "🔹 Formatting Dart code..."
dart format .

echo "🔹 Applying fixes..."
dart fix --apply

echo "🔹 Adding changes to Git..."
git add .

echo "✅ All done! You can now commit safely."


///flutter build apk --release
///flutter build apk --release --split-per-abi
//flutter build apk --release --split-per-abi
///flutter clean
flutter pub get
flutter build appbundle --release
# أو
flutter build apk --release --split-per-abi
flutter build appbundle --release --split-debug-info=debug_info --obfuscate
=======

>>>>>>> 78a072d795e6b2c9307ab91479ce8645dd9ba59b


