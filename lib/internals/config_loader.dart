import 'dart:io';
import 'package:yaml/yaml.dart';

import 'config.dart';

ArchGenConfig loadConfig() {
  final file = File('arch_gen.yaml');

  if (!file.existsSync()) {
    print("⚠️ No arch_gen.yaml found, using defaults (bloc, equatable: true)");
    return ArchGenConfig(stateManagement: 'bloc', useEquatable: true);
  }

  try {
    final content = file.readAsStringSync();

    if (content.trim().isEmpty) {
      print("⚠️ arch_gen.yaml is empty, using defaults");
      return ArchGenConfig(stateManagement: 'bloc', useEquatable: true);
    }

    final yamlMap = loadYaml(content);

    if (yamlMap is! Map) {
      print("❌ Invalid arch_gen.yaml: Root must be a key-value map");
      print("⚠️ Using defaults instead");
      return ArchGenConfig(stateManagement: 'bloc', useEquatable: true);
    }

    String? stateManagement = yamlMap['state_management']?.toString();
    bool? useEquatable = yamlMap['use_equatable'] as bool?;

    if (stateManagement != null &&
        stateManagement != 'bloc' &&
        stateManagement != 'riverpod') {
      print("⚠️ Invalid state_management: '$stateManagement'");
      print("   Allowed values: 'bloc' or 'riverpod'");
      print("   Using default: 'bloc'");
      stateManagement = 'bloc';
    }

    return ArchGenConfig(
      stateManagement: stateManagement ?? 'bloc',
      useEquatable: useEquatable ?? true,
    );
  } on YamlException catch (e) {
    print("❌ Error parsing arch_gen.yaml:");
    print("   $e");
    print("⚠️ Using default configuration (bloc, equatable: true)");
    return ArchGenConfig(stateManagement: 'bloc', useEquatable: true);
  } on FormatException catch (e) {
    print("❌ Invalid format in arch_gen.yaml:");
    print("   $e");
    print("⚠️ Using default configuration");
    return ArchGenConfig(stateManagement: 'bloc', useEquatable: true);
  } catch (e) {
    print("❌ Unexpected error loading arch_gen.yaml:");
    print("   $e");
    print("⚠️ Using default configuration");
    return ArchGenConfig(stateManagement: 'bloc', useEquatable: true);
  }
}
