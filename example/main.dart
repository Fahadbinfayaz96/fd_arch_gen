/// Example usage of fd_arch_gen - Clean Architecture code generator for Flutter.
///
/// fd_arch_gen helps you generate complete Clean Architecture features
/// with support for multiple state management solutions.
///
/// ## Installation
///
/// ```bash
/// dart pub global activate fd_arch_gen
/// ```
///
/// ## Usage Examples
///
/// ### Generate a feature with BLoC (Full)
/// ```bash
/// fd_arch_gen feature auth --bloc
/// ```
///
/// ### Generate a feature with Cubit (Simplified BLoC)
/// ```bash
/// fd_arch_gen feature products --cubit
/// ```
///
/// ### Generate a feature with Riverpod
/// ```bash
/// fd_arch_gen feature todos --riverpod
/// ```
///
/// ### Generate a feature with GetX
/// ```bash
/// fd_arch_gen feature profile --getx
/// ```
///
/// ## Generated Structure
///
/// ```
/// lib/features/feature_name/
/// ├── data/
/// │   ├── datasources/
/// │   ├── models/
/// │   └── repositories_impl/
/// ├── domain/
/// │   ├── entities/
/// │   ├── repositories/
/// │   └── usecases/
/// └── presentation/
///     ├── screens/
///     └── (bloc/cubit/providers/getx)
/// ```
///
/// ## Configuration
///
/// Create `arch_gen.yaml` in your project root:
/// ```yaml
/// state_management: bloc  # bloc, cubit, riverpod, or getx
/// ```
///
/// ## Features
///
/// - ✅ Clean Architecture structure
/// - ✅ Multiple state management options
/// - ✅ Automatic dependency injection (GetIt)
/// - ✅ JSON serialization (fromJson/toJson)
/// - ✅ Core files generation
/// - ✅ Equatable included by default
library;

void main() {
  print('''
╔══════════════════════════════════════════════════════════════╗
║                    🚀 fd_arch_gen v1.0.0                    ║
║          Clean Architecture Code Generator for Flutter       ║
╚══════════════════════════════════════════════════════════════╝

📦 Installation:
   dart pub global activate fd_arch_gen

✨ Generate a feature:

   # BLoC (Full pattern with events)
   fd_arch_gen feature auth --bloc

   # Cubit (Simplified BLoC without events)
   fd_arch_gen feature products --cubit

   # Riverpod (Provider-based)
   fd_arch_gen feature todos --riverpod

   # GetX (All-in-one solution)
   fd_arch_gen feature profile --getx

📁 Generated Structure:
   lib/features/feature_name/
   ├── data/           (models, datasources, repositories)
   ├── domain/         (entities, repositories, usecases)
   └── presentation/   (screens, bloc/cubit/providers/getx)

⚙️  Configuration (arch_gen.yaml):
   state_management: bloc  # bloc, cubit, riverpod, or getx

🔧 What's included:
   ✅ Clean Architecture layers
   ✅ Dependency injection (GetIt)
   ✅ JSON serialization (fromJson/toJson)
   ✅ Equatable (for value equality)
   ✅ Core utilities (failures, API client)

💡 Pro Tips:
   • Use --cubit for simpler state management
   • Use --bloc when you need fine-grained event control
   • Equatable is automatically included for BLoC and Cubit
   • Generated code follows Flutter best practices


🙏 Support the project:
   ⭐ Star on GitHub
   📦 Like on pub.dev
   🐛 Report issues

Happy coding! 🎉
''');
}
