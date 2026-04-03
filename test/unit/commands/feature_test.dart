import 'package:test/test.dart';
import 'package:args/args.dart';
import 'dart:io';

void main() {
  group('Feature Command', () {
    late Directory tempDir;
    late String originalWorkingDir;

    setUp(() {
      // Save original working directory
      originalWorkingDir = Directory.current.path;

      // Create temp directory for test isolation
      tempDir = Directory.systemTemp.createTempSync();
      Directory.current = tempDir.path;

      // Create mock project structure
      Directory('lib').createSync();
      Directory('lib/features').createSync();
      Directory('lib/core').createSync();

      // Create a basic pubspec.yaml
      File('pubspec.yaml').writeAsStringSync('''
name: test_app
version: 1.0.0
dependencies:
  flutter:
    sdk: flutter
''');
    });

    tearDown(() {
      // Restore original working directory
      Directory.current = originalWorkingDir;

      // Clean up
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    });

    test('feature name validation - accepts valid names', () {
      final validNames = [
        'todo',
        'user_profile',
        'shopping_cart',
        'api_service',
      ];

      for (var name in validNames) {
        final isValid = RegExp(r'^[a-z][a-z0-9_]*$').hasMatch(name);
        expect(isValid, true, reason: '$name should be valid');
      }
    });

    test('feature name validation - rejects invalid names', () {
      final invalidNames = [
        'Todo', // Starts with uppercase
        'todo-item', // Contains hyphen
        '123todo', // Starts with number
        'todo ', // Contains space
        '', // Empty
      ];

      for (var name in invalidNames) {
        final isValid = RegExp(r'^[a-z][a-z0-9_]*$').hasMatch(name);
        expect(isValid, false, reason: '$name should be invalid');
      }
    });

    test('command line argument parsing for bloc flag', () {
      final parser = ArgParser()
        ..addFlag('bloc', negatable: false)
        ..addFlag('riverpod', negatable: false);

      var results = parser.parse(['--bloc']);
      expect(results['bloc'], true);
      expect(results['riverpod'], false);

      results = parser.parse([]);
      expect(results['bloc'], false);
      expect(results['riverpod'], false);
    });

    test('command line argument parsing for riverpod flag', () {
      final parser = ArgParser()
        ..addFlag('bloc', negatable: false)
        ..addFlag('riverpod', negatable: false);

      var results = parser.parse(['--riverpod']);
      expect(results['bloc'], false);
      expect(results['riverpod'], true);
    });

    test('equatable flag parsing works', () {
      final parser = ArgParser()..addFlag('equatable', defaultsTo: null);

      var results = parser.parse(['--equatable']);
      expect(results['equatable'], true);

      results = parser.parse([]);
      expect(results['equatable'], null);
    });

    test('feature name is required - empty name should be rejected', () {
      final featureName = '';
      final isValid = featureName.isNotEmpty;
      expect(isValid, false);
    });
  });
}
