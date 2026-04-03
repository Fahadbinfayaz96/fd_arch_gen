import 'dart:io';
import 'package:path/path.dart' as path;

import '../utils/files_utils.dart' show safeWrite;

String getProjectLibPath() {
  final projectRoot = Directory.current.path;
  return path.join(projectRoot, 'lib');
}

void generateDI() {
  final libPath = getProjectLibPath();
  final diPath = path.join(libPath, 'core', 'di', 'injection_container.dart');

  final file = File(diPath);

  if (!file.existsSync()) {
    safeWrite(diPath, '''  
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features will be registered below 👇
}
''');

    print("📦 DI container created at: $diPath");
  }
}

void registerFeatureDI(String feature, String snake) {
  final libPath = getProjectLibPath();
  final diPath = path.join(libPath, 'core', 'di', 'injection_container.dart');
  final file = File(diPath);

  if (!file.existsSync()) return;

  String content = file.readAsStringSync();

  final imports =
      '''
import '../../features/$snake/data/datasources/${snake}_remote_datasource.dart';
import '../../features/$snake/data/repositories_impl/${snake}_repository_impl.dart';
import '../../features/$snake/domain/repositories/${snake}_repository.dart';
import '../../features/$snake/domain/usecases/${snake}_usecase.dart';
''';

  if (!content.contains('features/$snake')) {
    final lines = content.split('\n');
    int lastImportIndex = -1;

    for (int i = 0; i < lines.length; i++) {
      if (lines[i].startsWith('import ') || lines[i].startsWith("import ")) {
        lastImportIndex = i;
      }
    }

    if (lastImportIndex != -1) {
      lines.insert(lastImportIndex + 1, imports);
      content = lines.join('\n');
    }
  }

  final registration =
      '''

  // $feature
  sl.registerLazySingleton<${feature}RemoteDataSource>(
    () => ${feature}RemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<${feature}Repository>(
    () => ${feature}RepositoryImpl(sl()),
  );

  sl.registerLazySingleton(
    () => ${feature}UseCase(sl()),
  );
''';

  if (content.contains('${feature}Repository')) {
    print("⚠️ DI already registered for $feature");
    return;
  }

  final marker = 'Future<void> init() async {';

  if (content.contains(marker)) {
    final updated = content.replaceFirst(marker, '$marker$registration');
    safeWrite(diPath, updated);
    print("🔗 DI registered for $feature");
  }
}
