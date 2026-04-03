import 'dart:io';
import 'package:args/args.dart';
import 'package:fd_arch_gen/generators/core_generator.dart';
import '../internals/config.dart';
import '../utils/files_utils.dart';
import '../utils/naming.dart';
import '../utils/path_resolver.dart';
import '../utils/pubspec_updater.dart';
import '../utils/template_engine.dart';
import 'di_generator.dart';

void generateFeature(String name, ArchGenConfig config) {
  if (config.stateManagement == 'bloc') {
    final deps = ['flutter_bloc'];
    if (config.useEquatable) {
      deps.add('equatable');
    }
    ensureDependencies(deps);
  } else if (config.stateManagement == 'riverpod') {
    ensureDependencies(['flutter_riverpod']);
  }

  ensureDependencies(['dartz', 'get_it', 'http', 'hive', 'hive_flutter']);

  generateCore();
  generateDI();

  final feature = toPascalCase(name);
  final snake = name.toLowerCase();

  final base = 'lib/features/$snake';

  final dirs = [
    '$base/data/models',
    '$base/data/datasources',
    '$base/data/repositories_impl',
    '$base/domain/entities',
    '$base/domain/repositories',
    '$base/domain/usecases',
    '$base/presentation/screens',
    '$base/presentation/widgets',
  ];

  if (config.stateManagement == 'bloc') {
    dirs.add('$base/presentation/bloc');
  } else if (config.stateManagement == 'riverpod') {
    dirs.add('$base/presentation/providers');
  }
  for (var dir in dirs) {
    Directory(dir).createSync(recursive: true);
  }

  if (config.stateManagement == 'bloc') {
    _generateBloc(base, feature, snake, config);
    print("📦 Generated BLoC files");
  } else if (config.stateManagement == 'riverpod') {
    _generateRiverpod(base, feature, snake, config);
    print("📦 Generated Riverpod files");
  }

  _generateScreen(base, feature, snake, config);
  _generateEntity(base, feature, snake);
  _generateModel(base, feature, snake);
  _generateRepository(base, feature, snake);
  _generateDatasource(base, feature, snake);
  _generateRepositoryImpl(base, feature, snake);
  _generateUsecase(base, feature, snake);

  registerFeatureDI(feature, snake);

  print("✅ Feature '$name' generated using ${config.stateManagement}");
}

ArchGenConfig mergeFlags(ArchGenConfig config, ArgResults flags) {
  String state = config.stateManagement;
  bool equatable = config.useEquatable;

  if (flags['bloc'] == true) state = 'bloc';
  if (flags['riverpod'] == true) state = 'riverpod';

  if (flags.wasParsed('equatable')) {
    equatable = flags['equatable'];
  }

  return config.copyWith(stateManagement: state, useEquatable: equatable);
}

void _generateBloc(
  String base,
  String feature,
  String snake,
  ArchGenConfig config,
) {
  final blocPath = '$base/presentation/bloc';

  final blocTemplate = PathResolver.getTemplatePath('bloc/bloc.dart.tpl');
  final blocVars = {'Feature': feature, 'feature_snake': snake};
  final blocContent = renderTemplate(blocTemplate, blocVars);
  safeWrite('$blocPath/${snake}_bloc.dart', blocContent);

  final eventTemplate = PathResolver.getTemplatePath('bloc/event.dart.tpl');
  final eventContent = renderTemplate(eventTemplate, blocVars);
  safeWrite('$blocPath/${snake}_event.dart', eventContent);

  final stateTemplate = PathResolver.getTemplatePath('bloc/state.dart.tpl');
  final stateContent = renderTemplate(stateTemplate, blocVars);
  safeWrite('$blocPath/${snake}_state.dart', stateContent);
}

void _generateRiverpod(
  String base,
  String feature,
  String snake,
  ArchGenConfig config,
) {
  final templatePath = PathResolver.getTemplatePath(
    'riverpod/provider.dart.tpl',
  );
  final outputPath = '$base/presentation/providers/${snake}_provider.dart';

  final vars = {'Feature': feature, 'snake': snake};

  final content = renderTemplate(templatePath, vars);
  safeWrite(outputPath, content);
}

void _generateScreen(
  String base,
  String feature,
  String snake,
  ArchGenConfig config,
) {
  final screenPath = '$base/presentation/screens';

  String templatePath;
  if (config.stateManagement == 'bloc') {
    templatePath = PathResolver.getTemplatePath('screen/bloc_screen.dart.tpl');
  } else {
    templatePath = PathResolver.getTemplatePath(
      'screen/riverpod_screen.dart.tpl',
    );
  }

  final vars = {'Feature': feature, 'snake': snake};
  final content = renderTemplate(templatePath, vars);
  safeWrite('$screenPath/${snake}_screen.dart', content);
}

void _generateUsecase(String base, String feature, String snake) {
  final templatePath = PathResolver.getTemplatePath('usecase.dart.tpl');
  final outputPath = '$base/domain/usecases/${snake}_usecase.dart';
  final vars = {'Feature': feature, 'snake': snake};
  final content = renderTemplate(templatePath, vars);
  safeWrite(outputPath, content);
}

void _generateRepository(String base, String feature, String snake) {
  final templatePath = PathResolver.getTemplatePath('repository.dart.tpl');
  final outputPath = '$base/domain/repositories/${snake}_repository.dart';
  final vars = {'Feature': feature, 'snake': snake};
  final content = renderTemplate(templatePath, vars);
  safeWrite(outputPath, content);
}

void _generateDatasource(String base, String feature, String snake) {
  final templatePath = PathResolver.getTemplatePath('datasource.dart.tpl');
  final outputPath = '$base/data/datasources/${snake}_remote_datasource.dart';
  final vars = {'Feature': feature, 'snake': snake};
  final content = renderTemplate(templatePath, vars);
  safeWrite(outputPath, content);
}

void _generateRepositoryImpl(String base, String feature, String snake) {
  final templatePath = PathResolver.getTemplatePath('repository_impl.dart.tpl');
  final outputPath =
      '$base/data/repositories_impl/${snake}_repository_impl.dart';
  final vars = {'Feature': feature, 'snake': snake};
  final content = renderTemplate(templatePath, vars);
  safeWrite(outputPath, content);
}

void _generateEntity(String base, String feature, String snake) {
  final templatePath = PathResolver.getTemplatePath('entity.dart.tpl');
  final outputPath = '$base/domain/entities/${snake}_entity.dart';
  final vars = {'Feature': feature, 'snake': snake};
  final content = renderTemplate(templatePath, vars);
  safeWrite(outputPath, content);
}

void _generateModel(String base, String feature, String snake) {
  final templatePath = PathResolver.getTemplatePath('model.dart.tpl');
  final outputPath = '$base/data/models/${snake}_model.dart';
  final vars = {'Feature': feature, 'snake': snake};
  final content = renderTemplate(templatePath, vars);
  safeWrite(outputPath, content);
}
