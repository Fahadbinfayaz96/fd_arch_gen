import 'dart:io';
import 'package:path/path.dart' as path;

class PathResolver {
  static String getTemplatePath(String relativePath) {
    final script = Platform.script.toFilePath();

    String? packageRoot;
    final scriptDir = File(script).parent;

    final searchPaths = [
      scriptDir.path,
      Directory.current.path,
    ];

    for (var startPath in searchPaths) {
      var dir = Directory(startPath);

      for (int i = 0; i < 10; i++) {
        final templatesDir = path.join(dir.path, 'lib', 'templates');
        if (Directory(templatesDir).existsSync()) {
          packageRoot = dir.path;
          break;
        }
        if (dir.path == dir.parent.path) break;
        dir = dir.parent;
      }
      if (packageRoot != null) break;
    }

    if (packageRoot == null) {
      throw Exception('Could not find fd_arch_gen package root');
    }

    final templatePath =
        path.join(packageRoot, 'lib', 'templates', relativePath);

    if (!File(templatePath).existsSync()) {
      throw Exception('Template not found: $relativePath');
    }

    return templatePath;
  }
}
