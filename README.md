# 📅 CLDR — Calendar

A compact, elegant calendar app built with Flutter and Material 3. Features dynamic wallpaper-based theming, event management, and public holiday integration.

---

## ✨ Features

| Feature             | Description                                                  |
| ------------------- | ------------------------------------------------------------ |
| 🎨 Dynamic Color    | Adapts to your wallpaper (Material You) with light/dark mode |
| 📆 Inline Calendar  | Compact month grid with swipe navigation                     |
| 📝 Event Management | Add, view, and swipe-to-delete events                        |
| 🎉 Public Holidays  | Import holidays from 20+ countries via Nager.Date API        |
| 💾 Offline Storage  | Events persisted locally with Hive                           |
| 🧪 Tested           | BLoC unit tests with full coverage of state transitions      |

---

## 📸 Screenshots

<!-- Add screenshots here -->
<!-- ![Light Mode](screenshots/light.png) -->
<!-- ![Dark Mode](screenshots/dark.png) -->

---

## 🏗️ Architecture

Clean Architecture with BLoC pattern:

```
lib/
├── core/
│   ├── constants/      # App strings
│   ├── error/          # Failures, exceptions
│   ├── network/        # Dio API client
│   ├── theme/          # Material 3 dynamic theming
│   └── usecases/       # UseCase base class
├── features/
│   └── calendar/
│       ├── data/
│       │   ├── datasources/   # Remote (API) + Local (Hive)
│       │   ├── models/        # EventModel, HolidayModel
│       │   └── repositories/  # Repository implementation
│       ├── domain/
│       │   ├── entities/      # Event, Holiday
│       │   ├── repositories/  # Abstract repository
│       │   └── usecases/      # GetHolidays, AddEvent, etc.
│       └── presentation/
│           ├── bloc/          # CalendarBloc
│           ├── pages/         # CalendarPage
│           └── widgets/       # DayCell, EventList, sheets
└── injection_container.dart   # get_it DI setup
```

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK `>=3.12.0`
- Dart `>=3.12.0`

### Run locally

```bash
git clone https://github.com/Najeer-k11/cldr.git
cd cldr
flutter pub get
flutter run
```

### Run tests

```bash
flutter test
```

---

## 📦 Download

Grab the latest APK from the [Releases](../../releases/latest) page.

---

## 🔧 Tech Stack

| Layer                | Technology                          |
| -------------------- | ----------------------------------- |
| UI Framework         | Flutter 3 + Material 3              |
| State Management     | flutter_bloc                        |
| Dependency Injection | get_it                              |
| Networking           | Dio                                 |
| Local Storage        | Hive                                |
| Dynamic Theming      | dynamic_color                       |
| Holiday API          | [Nager.Date](https://date.nager.at) |

---

## 🏷️ Creating a Release

Push a version tag to trigger the CI build and auto-publish an APK:

```bash
git tag v1.0.0
git push origin v1.0.0
```

The GitHub Actions workflow will:

1. Run tests
2. Build a release APK
3. Create a GitHub Release with the APK attached

---

## 📄 License

This project is licensed under the MIT License.
