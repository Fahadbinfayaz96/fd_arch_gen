/// Generates a complete Clean Architecture feature.
///
/// [name] - The feature name (e.g., 'todo', 'user_profile')
/// [config] - Configuration for state management and options
///
/// Creates the following structure:
/// - data layer (models, datasources, repositories)
/// - domain layer (entities, repositories, usecases)
/// - presentation layer (screens, bloc/providers)
library;

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
    ensureDependencies(['flutter_bloc', 'equatable']);
  } else if (config.stateManagement == 'riverpod') {
    ensureDependencies(['flutter_riverpod']);
  } else if (config.stateManagement == 'getx') {
    ensureDependencies(['get']);
  }
  if (config.stateManagement == 'cubit') {
    ensureDependencies(['flutter_bloc', 'equatable']);
  }

  ensureDependencies(['dartz', 'get_it', 'http']);

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
  if (config.stateManagement == 'cubit') {
    dirs.add('$base/presentation/cubit');
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
  } else if (config.stateManagement == 'getx') {
    _generateGetX(base, feature, snake, config);
    print("📦 Generated GetX files");
  } else if (config.stateManagement == 'cubit') {
    _generateCubit(base, feature, snake, config);
    print("📦 Generated Cubit files");
  }

  _generateScreen(base, feature, snake, config);
  _generateEntity(base, feature, snake);
  _generateModel(base, feature, snake);
  _generateRepository(base, feature, snake);
  _generateDatasource(base, feature, snake);
  _generateRepositoryImpl(base, feature, snake);
  _generateUsecase(base, feature, snake);

  registerFeatureDI(feature, snake, stateManagement: config.stateManagement);

  print('''
✅ Feature '$name' generated using ${config.stateManagement}

🙏 If this tool helped you, please consider:
⭐ Giving feedback: https://github.com/Fahadbinfayaz96/fd_arch_gen/issues
📦 Leaving a like on pub.dev

Your feedback helps improve the tool 🚀
''');
}

ArchGenConfig mergeFlags(ArchGenConfig config, ArgResults flags) {
  String state = config.stateManagement;

  if (flags['bloc'] == true) state = 'bloc';
  if (flags['riverpod'] == true) state = 'riverpod';
  if (flags['getx'] == true) state = 'getx';
  if (flags['cubit'] == true) state = 'cubit';

  return config.copyWith(
    stateManagement: state,
  );
}

void _generateGetX(
  String base,
  String feature,
  String snake,
  ArchGenConfig config,
) {
  final getxPath = '$base/presentation/getx';
  Directory(getxPath).createSync(recursive: true);

  final controllerTemplate =
      PathResolver.getTemplatePath('getx/controller.dart.tpl');
  final controllerVars = {'Feature': feature, 'snake': snake};
  final controllerContent = renderTemplate(controllerTemplate, controllerVars);
  safeWrite('$getxPath/${snake}_controller.dart', controllerContent);

  final bindingTemplate = PathResolver.getTemplatePath('getx/binding.dart.tpl');
  final bindingContent = renderTemplate(bindingTemplate, controllerVars);
  safeWrite('$getxPath/${snake}_binding.dart', bindingContent);

  final viewTemplate = PathResolver.getTemplatePath('getx/view.dart.tpl');
  final viewContent = renderTemplate(viewTemplate, controllerVars);
  safeWrite('$base/presentation/screens/${snake}_screen.dart', viewContent);
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

void _generateCubit(
  String base,
  String feature,
  String snake,
  ArchGenConfig config,
) {
  final cubitPath = '$base/presentation/cubit';
  Directory(cubitPath).createSync(recursive: true);

  final cubitTemplate = PathResolver.getTemplatePath('cubit/cubit.dart.tpl');
  final cubitVars = {
    'Feature': feature,
    'feature_snake': snake,
    'useEquatable': 'true',
  };
  final cubitContent = renderTemplate(cubitTemplate, cubitVars);
  safeWrite('$cubitPath/${snake}_cubit.dart', cubitContent);

  final stateTemplate = PathResolver.getTemplatePath('cubit/state.dart.tpl');
  final stateContent = renderTemplate(stateTemplate, cubitVars);
  safeWrite('$cubitPath/${snake}_state.dart', stateContent);
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
  } else if (config.stateManagement == 'riverpod') {
    templatePath = PathResolver.getTemplatePath(
      'screen/riverpod_screen.dart.tpl',
    );
  } else if (config.stateManagement == 'cubit') {
    templatePath = PathResolver.getTemplatePath('screen/cubit_screen.dart.tpl');
  } else if (config.stateManagement == 'getx') {
    return;
  } else {
    templatePath =
        PathResolver.getTemplatePath('screen/riverpod_screen.dart.tpl');
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
