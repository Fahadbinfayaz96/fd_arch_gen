import 'package:args/args.dart';
import '../internals/config_loader.dart';
import '../generators/feature_generator.dart';

void featureCommand(String name, ArgResults flags) async {
  final baseConfig = loadConfig();
  final config = mergeFlags(baseConfig, flags);
  generateFeature(name, config);
}
