/// Configuration for the code generator.
///
/// Loaded from `arch_gen.yaml` in the project root.
library;

class ArchGenConfig {
  /// State management solution: 'bloc' or 'riverpod'
  final String stateManagement;

  /// Whether to use Equatable package with BLoC

  /// Creates a new configuration instance.
  ArchGenConfig({required this.stateManagement}) {
    if (stateManagement != 'bloc' &&
        stateManagement != 'riverpod' &&
        stateManagement != 'getx' &&
        stateManagement != 'cubit') {
      throw ArgumentError(
        'stateManagement must be "bloc", "riverpod", "getx", or "cubit", got "$stateManagement"',
      );
    }
  }

  factory ArchGenConfig.fromYaml(Map yaml) {
    final stateManagement = yaml['state_management']?.toString();

    return ArchGenConfig(
      stateManagement: stateManagement ?? 'bloc',
    );
  }

  ArchGenConfig copyWith({
    String? stateManagement,
  }) {
    return ArchGenConfig(
      stateManagement: stateManagement ?? this.stateManagement,
    );
  }

  @override
  String toString() {
    return 'ArchGenConfig(stateManagement: $stateManagement, )';
  }
}
