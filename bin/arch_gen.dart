import 'package:args/args.dart';
import 'package:arch_gen/commands/feature.dart';

void main(List<String> arguments) {
  try {
    if (arguments.isEmpty) {
      print("Usage: arch_gen <command>");
      print("\nAvailable commands:");
      print("  feature <name>    Generate a new feature");
      print("\nOptions for feature command:");
      print("  --bloc            Use BLoC for state management");
      print("  --riverpod        Use Riverpod for state management");
      print("  --equatable       Use Equatable package");
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

        // Validate feature name
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
            'equatable',
            defaultsTo: null,
            help: 'Use Equatable package',
          );

        final results = parser.parse(arguments.skip(2));

        // Prevent using both bloc and riverpod
        if (results['bloc'] == true && results['riverpod'] == true) {
          print("❌ Error: Cannot use both --bloc and --riverpod");
          print("   Choose one state management solution");
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
    // In development, you might want to see the stack trace:
    // print(e.stackTrace);
  }
}
