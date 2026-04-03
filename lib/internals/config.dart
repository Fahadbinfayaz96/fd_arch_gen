class ArchGenConfig {
  final String stateManagement;
  final bool useEquatable;

  ArchGenConfig({required this.stateManagement, required this.useEquatable}) {
    if (stateManagement != 'bloc' && stateManagement != 'riverpod') {
      throw ArgumentError(
        'stateManagement must be "bloc" or "riverpod", got "$stateManagement"',
      );
    }
  }

  factory ArchGenConfig.fromYaml(Map yaml) {
    final stateManagement = yaml['state_management']?.toString();
    final useEquatable = yaml['use_equatable'] as bool?;

    return ArchGenConfig(
      stateManagement: stateManagement ?? 'bloc',
      useEquatable: useEquatable ?? true,
    );
  }

  ArchGenConfig copyWith({String? stateManagement, bool? useEquatable}) {
    return ArchGenConfig(
      stateManagement: stateManagement ?? this.stateManagement,
      useEquatable: useEquatable ?? this.useEquatable,
    );
  }

  @override
  String toString() {
    return 'ArchGenConfig(stateManagement: $stateManagement, useEquatable: $useEquatable)';
  }
}
