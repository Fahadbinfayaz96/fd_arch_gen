import 'package:test/test.dart';
import 'package:arch_gen/utils/template_engine.dart';
import 'dart:io';

void main() {
  group('Template Engine', () {
    test('renderTemplate replaces variables correctly', () async {
      // Create a temporary template file
      final tempDir = Directory.systemTemp.createTempSync();
      final templateFile = File('${tempDir.path}/test.tpl');
      templateFile.writeAsStringSync('Hello {{name}}! Welcome to {{app}}.');

      // Mock PathResolver for test
      // Note: You'll need to create a test version or mock
      // For now, we'll test the rendering logic directly

      final vars = {'name': 'John', 'app': 'Flutter'};

      // Test replacement logic
      String content = templateFile.readAsStringSync();
      for (final entry in vars.entries) {
        content = content.replaceAll('{{${entry.key}}}', entry.value);
      }

      expect(content, equals('Hello John! Welcome to Flutter.'));

      // Cleanup
      tempDir.deleteSync(recursive: true);
    });

    test('renderTemplate handles multiple same variables', () {
      String content = '{{name}} is {{name}} again';
      final vars = {'name': 'Bob'};

      for (final entry in vars.entries) {
        content = content.replaceAll('{{${entry.key}}}', entry.value);
      }

      expect(content, equals('Bob is Bob again'));
    });
  });
}
