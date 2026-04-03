Here's your README.md (copy this):
markdown

# fd_arch_gen

A Clean Architecture code generator for Flutter that creates complete features with BLoC or Riverpod state management.

[![Pub Version](https://img.shields.io/pub/v/fd_arch_gen)](https://pub.dev/packages/fd_arch_gen)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Features

- 🚀 Generate complete Clean Architecture features with one command
- 🎨 Supports both **BLoC** and **Riverpod** state management
- 📁 Creates all layers: Data, Domain, Presentation
- 🔌 Automatic dependency injection registration
- 📦 Core files generation (error handling, API client, usecases)
- ⚙️ Configurable via `arch_gen.yaml`

## Installation

````bash
dart pub global activate fd_arch_gen
Quick Start
1. Create a new feature with BLoC
bash
fd_arch_gen feature todo --bloc
2. Create a feature with Riverpod
bash
fd_arch_gen feature user_profile --riverpod
3. With Equatable (for BLoC)
bash
fd_arch_gen feature products --bloc --equatable
Generated Structure
text
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
    └── bloc/ (or providers/ for Riverpod)
        ├── todo_bloc.dart
        ├── todo_event.dart
        └── todo_state.dart
Configuration
Create arch_gen.yaml in your project root:

yaml
# Default configuration
state_management: bloc  # bloc or riverpod
use_equatable: true     # only for BLoC
Commands
Command	Description
fd_arch_gen feature <name>	Generate a new feature
--bloc	Use BLoC (default)
--riverpod	Use Riverpod
--equatable	Add Equatable support
Requirements
Flutter SDK

Dart SDK >= 3.0.0

What gets generated automatically?
✅ Core files (failures, exceptions, API client)

✅ Dependency injection container with GetIt

✅ All feature layers with proper imports

✅ DI registration for the feature

✅ Required dependencies added to pubspec.yaml

Example
bash
# Generate a blog feature with Riverpod
fd_arch_gen feature blog --riverpod

# Output:
# 📦 Core generated
# 📦 DI container created
# 📦 Generated Riverpod files
# 🔗 DI registered for Blog
# ✅ Feature 'blog' generated using riverpod
License
MIT License - see LICENSE file for details

Author
Fahad Bin Fayaz

Repository
GitHub - Fahadbinfayaz96/fd_arch_gen

Issues
Report bugs or suggest features on GitHub Issues

text

## Now add this README to your repo:

```bash
# Update README on GitHub
git add README.md
git commit -m "docs: add README for fd_arch_gen"
git push origin main

## Share your package!
- **Pub.dev:** https://pub.dev/packages/fd_arch_gen
- **GitHub:** https://github.com/Fahadbinfayaz96/fd_arch_gen

````
