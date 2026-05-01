import 'dart:io';

const Map<String, String> packageVersions = {
  'flutter_bloc': '^9.1.1',
  'equatable': '^2.0.8',
  'flutter_riverpod': '^2.6.1',
  'get': '^4.7.3',
  'dartz': '^0.10.1',
  'get_it': '^9.2.1',
  'http': '^1.1.0',
};

void ensureDependencies(List<String> packages) {
  final pubspecFile = File('pubspec.yaml');

  if (!pubspecFile.existsSync()) {
    print("⚠️ pubspec.yaml not found in current directory");
    print("   Make sure you're running this in a Flutter project root");
    return;
  }

  String content = pubspecFile.readAsStringSync();
  bool updated = false;
  final missingPackages = <String>[];

  for (var pkg in packages) {
    final pattern = RegExp(
      r'^[\s]*' + RegExp.escape(pkg) + r':',
      multiLine: true,
    );
    if (!pattern.hasMatch(content)) {
      missingPackages.add(pkg);
    }
  }

  if (missingPackages.isEmpty) {
    print("✅ All dependencies already present");
    return;
  }

  print("📦 Adding missing dependencies: ${missingPackages.join(', ')}");

  // Add each missing dependency
  for (var pkg in missingPackages) {
    final version = packageVersions[pkg] ?? '^1.0.0';
    final dependencyLine = "  $pkg: $version\n";

    if (content.contains('dependencies:')) {
      final depsIndex = content.indexOf('dependencies:');
      final afterDeps = content.substring(depsIndex);
      final nextSection = RegExp(r'\n\w+_:').firstMatch(afterDeps);

      if (nextSection != null) {
        final insertPos = depsIndex + nextSection.start;
        content = content.substring(0, insertPos) +
            dependencyLine +
            content.substring(insertPos);
      } else {
        final depsEnd = _findDependenciesEnd(content, depsIndex);
        content = content.substring(0, depsEnd) +
            dependencyLine +
            content.substring(depsEnd);
      }
    } else {
      content = content.trimRight();
      if (!content.endsWith('\n')) content += '\n';
      content += '\ndependencies:\n$dependencyLine';
    }

    updated = true;
    print("  ✅ Added $pkg: $version");
  }

  if (updated) {
    pubspecFile.writeAsStringSync(content);
    print("📦 Running flutter pub get...");

    final processResult = Process.runSync(
        'flutter',
        [
          'pub',
          'get',
        ],
        runInShell: true);

    if (processResult.exitCode == 0) {
      print("✅ Dependencies installed successfully");
    } else {
      print("❌ Failed to run flutter pub get");
      if (processResult.stderr.toString().isNotEmpty) {
        print("   Error: ${processResult.stderr}");
      }
      print("   You may need to run 'flutter pub get' manually");
    }
  }
}

int _findDependenciesEnd(String content, int depsStartIndex) {
  final lines = content.split('\n');
  int lineIndex = content.substring(0, depsStartIndex).split('\n').length - 1;

  for (int i = lineIndex + 1; i < lines.length; i++) {
    final line = lines[i];
    if (line.isNotEmpty && !line.startsWith(' ') && !line.startsWith('\t')) {
      int pos = 0;
      for (int j = 0; j < i; j++) {
        pos += lines[j].length + 1;
      }
      return pos;
    }
  }

  return content.length;
}
