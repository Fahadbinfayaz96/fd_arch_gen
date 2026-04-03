import 'package:fd_arch_gen/generators/feature_generator.dart';
import 'package:fd_arch_gen/internals/config.dart';
import 'package:test/test.dart';
import 'dart:io';

void main() {
  group('Feature Generator', () {
    late Directory tempProject;
    late String originalWorkingDir;

    setUp(() {
      originalWorkingDir = Directory.current.path;

      tempProject = Directory.systemTemp.createTempSync();

      Directory.current = tempProject.path;

      Directory('lib').createSync();
      Directory('lib/features').createSync();

      File('pubspec.yaml').writeAsStringSync('''
name: test_app
version: 1.0.0
environment:
  sdk: '>=3.0.0 <4.0.0'
dependencies:
  flutter:
    sdk: flutter
''');

      Directory('.dart_tool').createSync();
    });

    tearDown(() {
      Directory.current = originalWorkingDir;

      if (tempProject.existsSync()) {
        tempProject.deleteSync(recursive: true);
      }
    });

    test('generateFeature creates all required directories', () {
      final config = ArchGenConfig(stateManagement: 'bloc', useEquatable: true);

      generateFeature('test_feature', config);

      expect(Directory('lib/features/test_feature').existsSync(), true);
      expect(Directory('lib/features/test_feature/data').existsSync(), true);
      expect(Directory('lib/features/test_feature/domain').existsSync(), true);
      expect(
        Directory('lib/features/test_feature/presentation').existsSync(),
        true,
      );
    });

    test('generateFeature creates BLoC files when configured', () {
      final config = ArchGenConfig(stateManagement: 'bloc', useEquatable: true);

      generateFeature('bloc_feature', config);

      expect(
        File(
          'lib/features/bloc_feature/presentation/bloc/bloc_feature_bloc.dart',
        ).existsSync(),
        true,
      );
      expect(
        File(
          'lib/features/bloc_feature/presentation/bloc/bloc_feature_event.dart',
        ).existsSync(),
        true,
      );
      expect(
        File(
          'lib/features/bloc_feature/presentation/bloc/bloc_feature_state.dart',
        ).existsSync(),
        true,
      );
    });

    test('generateFeature creates Riverpod files when configured', () {
      final config = ArchGenConfig(
        stateManagement: 'riverpod',
        useEquatable: false,
      );

      generateFeature('riverpod_feature', config);

      expect(
        File(
          'lib/features/riverpod_feature/presentation/providers/riverpod_feature_provider.dart',
        ).existsSync(),
        true,
      );
    });
  });
}
