# fd_arch_gen

A Clean Architecture code generator for Flutter that creates complete features with **BLoC**, **Cubit**, **Riverpod**, or **GetX** state management.

[![Pub Version](https://img.shields.io/pub/v/fd_arch_gen)](https://pub.dev/packages/fd_arch_gen)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Dart SDK](https://img.shields.io/badge/Dart-3.0+-blue.svg)](https://dart.dev)

---

## 🚀 Features

- 🎯 Generate complete Clean Architecture features with **one command**
- 🎨 Supports **4 state management solutions**:
  - **BLoC** - Full pattern with events
  - **Cubit** - Simplified BLoC without events
  - **Riverpod** - Modern provider-based
  - **GetX** - All-in-one solution
- 📁 Creates all layers: Data, Domain, Presentation
- 🔌 Automatic dependency injection (GetIt)
- 📦 Core files generation (error handling, API client, usecases)
- 💾 JSON serialization templates (fromJson/toJson)
- ⚙️ Configurable via `arch_gen.yaml` (set defaults like state management)
- ✅ **Equatable is included automatically** (no flags required)

---

## 📦 Installation

```bash
dart pub global activate fd_arch_gen
```

---

## ⚡ Quick Start

```bash
# Generate a feature with BLoC
fd_arch_gen feature auth --bloc

# Generate a feature with Cubit
fd_arch_gen feature products --cubit

# Generate a feature with Riverpod
fd_arch_gen feature todos --riverpod

# Generate a feature with GetX
fd_arch_gen feature profile --getx
```

---

## 💡 Example

```bash
fd_arch_gen feature blog --riverpod
```

**Output:**

```
📦 Core generated at: lib/core
📦 DI container created at: lib/core/di/injection_container.dart
📦 Generated Riverpod files
🔗 DI registered for Blog (riverpod)
✅ Feature 'blog' generated using riverpod

🙏 If this tool helped you, please consider:
⭐ Giving feedback: https://github.com/Fahadbinfayaz96/fd_arch_gen/issues
📦 Leaving a like on pub.dev
```

---

## 📁 Generated Structure

```
lib/features/todo/
├── data/
│   ├── datasources/
│   │   └── todo_remote_datasource.dart
│   ├── models/
│   │   └── todo_model.dart
│   └── repositories_impl/
│       └── todo_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── todo_entity.dart
│   ├── repositories/
│   │   └── todo_repository.dart
│   └── usecases/
│       └── todo_usecase.dart
└── presentation/
    ├── screens/
    │   └── todo_screen.dart
    └── state_management/
        ├── todo_bloc.dart       # BLoC only
        ├── todo_event.dart      # BLoC only
        ├── todo_state.dart      # BLoC / Cubit
        ├── todo_cubit.dart      # Cubit only
        ├── todo_provider.dart   # Riverpod only
        └── todo_controller.dart # GetX only
```

---

## ⚙️ Configuration

Create `arch_gen.yaml` in your project root to set a default state management solution. If this file is absent, **BLoC** is used by default.

```yaml
# arch_gen.yaml
# Options: bloc | cubit | riverpod | getx
state_management: bloc
```

---

## 🧠 Commands

| Command                                 | Description                       |
| --------------------------------------- | --------------------------------- |
| `fd_arch_gen feature <name> --bloc`     | Generate a feature using BLoC     |
| `fd_arch_gen feature <name> --cubit`    | Generate a feature using Cubit    |
| `fd_arch_gen feature <name> --riverpod` | Generate a feature using Riverpod |
| `fd_arch_gen feature <name> --getx`     | Generate a feature using GetX     |

---

## 📌 What gets generated automatically?

### ✅ Core Files

- `lib/core/error/failure.dart` — Error handling
- `lib/core/error/exceptions.dart` — Exceptions
- `lib/core/network/api_client.dart` — HTTP client
- `lib/core/usecase/usecase.dart` — Base usecase

### ✅ Dependency Injection

- `lib/core/di/injection_container.dart` — GetIt setup
- Automatic feature registration in DI

### ✅ Feature Layers

- **Data Layer**: Models, DataSources, Repository Implementations
- **Domain Layer**: Entities, Repositories, Usecases
- **Presentation Layer**: Screens + State Management (BLoC/Cubit/Riverpod/GetX)

### ✅ Utilities

- JSON serialization (fromJson/toJson)
- Equatable for value equality
- Proper imports and part files

### ✅ Dependencies

Automatically adds required packages to `pubspec.yaml`:

| Package            | Used For               |
| ------------------ | ---------------------- |
| `flutter_bloc`     | BLoC / Cubit           |
| `equatable`        | Value equality         |
| `flutter_riverpod` | Riverpod               |
| `get`              | GetX                   |
| `dartz`            | Functional programming |
| `get_it`           | Dependency injection   |
| `http`             | API calls              |

---

## 🎯 Why Use fd_arch_gen?

| Task          | Manual     | fd_arch_gen |
| ------------- | ---------- | ----------- |
| Setup feature | 15–20 mins | 5 seconds   |
| Boilerplate   | ❌ Heavy   | ✅ Zero     |
| DI setup      | ❌ Manual  | ✅ Auto     |
| Consistency   | ❌ Varies  | ✅ Standard |

---

## 📋 Requirements

- Flutter SDK: `>= 3.0.0`
- Dart SDK: `>= 3.0.0`

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

Distributed under the MIT License. See [LICENSE](LICENSE) for more information.

---

## 👨‍💻 Author

**Fahad Bin Fayaz**

- GitHub: [@Fahadbinfayaz96](https://github.com/Fahadbinfayaz96)
- Pub.dev: [fd_arch_gen](https://pub.dev/packages/fd_arch_gen)

---

## ⭐ Show Your Support

If this package helped you, please consider:

- ⭐ Starring the [GitHub repo](https://github.com/Fahadbinfayaz96/fd_arch_gen)
- 📦 Liking on [pub.dev](https://pub.dev/packages/fd_arch_gen)
- 🐛 [Reporting issues](https://github.com/Fahadbinfayaz96/fd_arch_gen/issues)
- 💡 Suggesting features
