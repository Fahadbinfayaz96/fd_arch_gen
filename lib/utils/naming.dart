String toPascalCase(String input) {
  return input
      .split('_')
      .map((e) => e[0].toUpperCase() + e.substring(1))
      .join();
}

String toSnakeCase(String input) {
  return input
      .replaceAllMapped(RegExp(r'[A-Z]'), (match) {
        return '_${match.group(0)!.toLowerCase()}';
      })
      .replaceAll(RegExp(r'^_'), '')
      .toLowerCase();
}
