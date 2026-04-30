/// A Clean Architecture code generator for Flutter.
///
/// This package provides CLI tools to generate features following Clean Architecture
/// with support for BLoC and Riverpod state management.
///
/// ## Usage
///
/// ```bash
/// fd_arch_gen feature todo --bloc
///
library;

import 'package:args/args.dart';
import 'package:fd_arch_gen/commands/feature.dart';

void main(List<String> arguments) {
  try {
    if (arguments.isEmpty) {
      print("Usage: arch_gen <command>");
      print("\nAvailable commands:");
      print("  feature <name>    Generate a new feature");
      print("Options for feature command:");
      print("  --bloc            Use BLoC for state management");
      print("  --riverpod        Use Riverpod for state management");
      print("  --getx            Use GetX for state management");
      print(
          "  --cubit           Use Cubit for state management (simplified BLoC)");
      return;
    }

    final command = arguments[0];

    switch (command) {
      case 'feature':
        if (arguments.length < 2) {
          print("❌ Error: Provide feature name");
          print("Usage: arch_gen feature <feature_name>");
          return;
        }

        final featureName = arguments[1];

        if (featureName.isEmpty ||
            !RegExp(r'^[a-z][a-z0-9_]*$').hasMatch(featureName)) {
          print("❌ Error: Invalid feature name '$featureName'");
          print("   Feature name must:");
          print("   - Start with a lowercase letter");
          print(
            "   - Contain only lowercase letters, numbers, and underscores",
          );
          print("   - Example: 'user_profile' or 'todo_list'");
          return;
        }

        final parser = ArgParser()
          ..addFlag(
            'bloc',
            negatable: false,
            help: 'Use BLoC for state management',
          )
          ..addFlag(
            'riverpod',
            negatable: false,
            help: 'Use Riverpod for state management',
          )
          ..addFlag(
            'getx',
            negatable: false,
            help: 'Use GetX for state management',
          )
          ..addFlag(
            'cubit',
            negatable: false,
            help: 'Use Cubit for state management',
          );

        final results = parser.parse(arguments.skip(2));

        int flagCount = 0;
        if (results['bloc'] == true) flagCount++;
        if (results['riverpod'] == true) flagCount++;
        if (results['getx'] == true) flagCount++;
        if (results['cubit'] == true) flagCount++;

        if (flagCount > 1) {
          print("❌ Error: Cannot use multiple state management flags");
          print("   Choose one: --bloc, --riverpod, --getx, or --cubit");
          return;
        }

        featureCommand(featureName, results);
        break;

      default:
        print("❌ Unknown command: $command");
        print("Available commands: feature");
    }
  } catch (e) {
    print("❌ Unexpected error: $e");
    print("Please report this issue at: [your GitHub issues URL]");
  }
}
