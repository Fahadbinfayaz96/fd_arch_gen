import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:arch_gen/utils/files_utils.dart';

String getProjectLibPath() {
  final projectRoot = Directory.current.path;
  return path.join(projectRoot, 'lib');
}

void generateCore() {
  final libPath = getProjectLibPath();

  final coreDirs = [
    path.join(libPath, 'core', 'error'),
    path.join(libPath, 'core', 'network'),
    path.join(libPath, 'core', 'utils'),
    path.join(libPath, 'core', 'usecase'),
  ];

  for (var dir in coreDirs) {
    Directory(dir).createSync(recursive: true);
  }

  safeWrite(
    path.join(libPath, 'core', 'error', 'failure.dart'),
    _failureContent(),
  );
  safeWrite(
    path.join(libPath, 'core', 'error', 'exceptions.dart'),
    _exceptionsContent(),
  );
  safeWrite(
    path.join(libPath, 'core', 'network', 'api_client.dart'),
    _apiClientContent(),
  );
  safeWrite(
    path.join(libPath, 'core', 'usecase', 'usecase.dart'),
    _usecaseContent(),
  );

  print("📦 Core generated at: $libPath/core");
}

String _failureContent() => '''
abstract class Failure {
  final String message;

  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}
''';

String _exceptionsContent() => '''
class ServerException implements Exception {}

class CacheException implements Exception {}
''';

String _apiClientContent() => '''
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final http.Client client;

  ApiClient(this.client);

  Future<dynamic> get(String url) async {
    final response = await client.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load data");
    }
  }
}
''';

String _usecaseContent() => '''
import 'package:dartz/dartz.dart';
import '../error/failure.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

// For usecases without params
class NoParams {}
''';
