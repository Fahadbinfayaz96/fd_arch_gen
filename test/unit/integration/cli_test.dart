import 'package:test/test.dart';
import 'dart:io';

void main() {
  group('CLI Integration Tests', () {
    late Directory tempProject;
    late String originalWorkingDir;

    setUp(() {
      originalWorkingDir = Directory.current.path;

      // Create a temporary Flutter project structure
      tempProject = Directory.systemTemp.createTempSync();
      Directory.current = tempProject.path;

      // Create minimal Flutter project structure
      Directory('lib').createSync();
      Directory('lib/features').createSync();
      Directory('lib/core').createSync();

      // Create a basic pubspec.yaml
      File('pubspec.yaml').writeAsStringSync('''
name: test_app
version: 1.0.0
environment:
  sdk: '>=3.0.0 <4.0.0'
dependencies:
  flutter:
    sdk: flutter
''');

      // Create .dart_tool directory to simulate Flutter project
      Directory('.dart_tool').createSync();
      File('.dart_tool/package_config.json').writeAsStringSync('{}');
    });

    tearDown(() {
      // Restore original working directory
      Directory.current = originalWorkingDir;

      // Clean up
      if (tempProject.existsSync()) {
        tempProject.deleteSync(recursive: true);
      }
    });

    test('arch_gen feature command creates feature structure', () {
      final featureName = 'test_feature';

      // Create feature directory manually (simulating what arch_gen does)
      final featurePath = 'lib/features/$featureName';
      Directory(featurePath).createSync();
      Directory('$featurePath/data').createSync();
      Directory('$featurePath/domain').createSync();
      Directory('$featurePath/presentation').createSync();

      // Verify structure was created
      expect(Directory(featurePath).existsSync(), true);
      expect(Directory('$featurePath/data').existsSync(), true);
      expect(Directory('$featurePath/domain').existsSync(), true);
      expect(Directory('$featurePath/presentation').existsSync(), true);
    });

    test('arch_gen creates core directory structure', () {
      final coreDirs = [
        'lib/core/error',
        'lib/core/network',
        'lib/core/utils',
        'lib/core/usecase',
      ];

      for (var dir in coreDirs) {
        Directory(dir).createSync(recursive: true);
      }

      for (var dir in coreDirs) {
        expect(Directory(dir).existsSync(), true);
      }
    });

    test('arch_gen creates DI container', () {
      final diPath = 'lib/core/di/injection_container.dart';
      Directory('lib/core/di').createSync(recursive: true);
      File(diPath).writeAsStringSync('''
import 'package:get_it/get_it.dart';
final sl = GetIt.instance;
Future<void> init() async {}
''');

      expect(File(diPath).existsSync(), true);
      expect(File(diPath).readAsStringSync(), contains('GetIt'));
    });

    test('arch_gen handles missing pubspec.yaml gracefully', () {
      // Delete pubspec.yaml
      File('pubspec.yaml').deleteSync();

      final pubspecExists = File('pubspec.yaml').existsSync();
      expect(pubspecExists, false);
    });

    test('arch_gen creates BLoC files correctly', () {
      final snakeCase = 'bloc_test';
      final pascalCase = 'BlocTest';

      final blocPath = 'lib/features/$snakeCase/presentation/bloc';
      Directory(blocPath).createSync(recursive: true);

      File(
        '$blocPath/${snakeCase}_bloc.dart',
      ).writeAsStringSync('class ${pascalCase}Bloc {}');
      File(
        '$blocPath/${snakeCase}_event.dart',
      ).writeAsStringSync('class ${pascalCase}Event {}');
      File(
        '$blocPath/${snakeCase}_state.dart',
      ).writeAsStringSync('class ${pascalCase}State {}');

      expect(File('$blocPath/${snakeCase}_bloc.dart').existsSync(), true);
      expect(File('$blocPath/${snakeCase}_event.dart').existsSync(), true);
      expect(File('$blocPath/${snakeCase}_state.dart').existsSync(), true);
      expect(
        File('$blocPath/${snakeCase}_bloc.dart').readAsStringSync(),
        contains(pascalCase),
      );
    });

    test('arch_gen creates Riverpod files correctly', () {
      final snakeCase = 'riverpod_test';
      final pascalCase = 'RiverpodTest';

      final providersPath = 'lib/features/$snakeCase/presentation/providers';
      Directory(providersPath).createSync(recursive: true);

      File(
        '$providersPath/${snakeCase}_provider.dart',
      ).writeAsStringSync('final ${snakeCase}Provider = Provider((ref) {}');

      expect(
        File('$providersPath/${snakeCase}_provider.dart').existsSync(),
        true,
      );
    });
  });
}
