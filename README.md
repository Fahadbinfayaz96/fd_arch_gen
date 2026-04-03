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

```bash
dart pub global activate fd_arch_gen
⚡ Quick Start
Create a feature with BLoC
fd_arch_gen feature todo --bloc
Create a feature with Riverpod
fd_arch_gen feature user_profile --riverpod
With Equatable (BLoC only)
fd_arch_gen feature products --bloc --equatable
📁 Generated Structure
lib/features/todo/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories_impl/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── screens/
    └── bloc/ (or providers/)
⚙️ Configuration

Create arch_gen.yaml in your project root:

state_management: bloc
use_equatable: true
🧠 Commands
Command	Description
fd_arch_gen feature <name>	Generate a feature
--bloc	Use BLoC
--riverpod	Use Riverpod
--equatable	Add Equatable
📌 What gets generated?
Core utilities (failures, API client)
Dependency Injection (GetIt)
Feature layers with correct imports
DI registration
Required dependencies in pubspec.yaml
💡 Example
fd_arch_gen feature blog --riverpod

Output:

📦 Core generated
📦 DI container created
📦 Generated Riverpod files
🔗 DI registered for Blog
✅ Feature 'blog' generated using riverpod
🔗 Links
📦 Pub.dev
💻 GitHub Repository
🐛 Report Issues
📄 License

MIT License © Fahad Bin Fayaz
:::

```
