import 'dart:io';
import 'package:path/path.dart' as path;
import 'path_resolver.dart';

String renderTemplate(String templatePath, Map<String, String> vars) {
  final fullPath = PathResolver.getTemplatePath(templatePath);
  final file = File(fullPath);

  if (!file.existsSync()) {
    throw Exception('Template not found: $templatePath');
  }

  String content = file.readAsStringSync();

  for (final entry in vars.entries) {
    final key = entry.key;
    final value = _escapeForReplacement(entry.value);
    final pattern = RegExp(r'\{\{\s*' + RegExp.escape(key) + r'\s*\}\}');
    content = content.replaceAllMapped(pattern, (match) => value);
  }

  final unreplaced = RegExp(r'\{\{.*?\}\}').allMatches(content);
  if (unreplaced.isNotEmpty) {
    final missingVars = unreplaced.map((m) => m.group(0)).toList();
    print('⚠️ Warning: Unreplaced template variables: $missingVars');
  }

  return content;
}

String _escapeForReplacement(String value) {
  return value.replaceAll(r'\', r'\\').replaceAll(r'$', r'\$');
}

String renderTemplateAdvanced(String templatePath, Map<String, dynamic> vars) {
  String content = renderTemplate(
    templatePath,
    vars.map((k, v) => MapEntry(k, v.toString())),
  );

  final ifPattern = RegExp(
    r'\{%\s*if\s+(\w+)\s*%\}(.*?)\{%\s*endif\s*%\}',
    multiLine: true,
  );
  content = content.replaceAllMapped(ifPattern, (match) {
    final conditionVar = match.group(1)!;
    final block = match.group(2)!;
    return vars[conditionVar] == true ? block : '';
  });

  final forPattern = RegExp(
    r'\{%\s*for\s+(\w+)\s+in\s+(\w+)\s*%\}(.*?)\{%\s*endfor\s*%\}',
    multiLine: true,
  );
  content = content.replaceAllMapped(forPattern, (match) {
    final itemVar = match.group(1)!;
    final collectionVar = match.group(2)!;
    final block = match.group(3)!;

    final collection = vars[collectionVar];
    if (collection is! List) return '';

    return collection
        .map((item) {
          final localVars = {...vars, itemVar: item};
          String result = block;
          for (final entry in localVars.entries) {
            result = result.replaceAll(
              '{{${entry.key}}}',
              entry.value.toString(),
            );
          }
          return result;
        })
        .join('');
  });

  return content;
}
