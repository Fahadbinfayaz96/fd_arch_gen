import 'dart:io';
import 'package:path/path.dart' as path;

class PathResolver {
  static String getTemplatePath(String relativePath) {
    final scriptDir = File(Platform.script.toFilePath()).parent;

    final possiblePaths = [
      path.join(Directory.current.path, 'lib', 'templates', relativePath),

      path.join(scriptDir.path, 'lib', 'templates', relativePath),

      path.join(scriptDir.parent.parent.path, 'lib', 'templates', relativePath),
    ];

    for (final templatePath in possiblePaths) {
      final file = File(templatePath);
      if (file.existsSync()) {
        return templatePath;
      }
    }

    throw Exception('Template not found: $relativePath');
  }
}
