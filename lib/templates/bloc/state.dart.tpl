part of '{{feature_snake}}_bloc.dart';

class {{Feature}}State extends Equatable {
  const {{Feature}}State();

  @override
  List<Object?> get props => [];
}

class {{Feature}}Initial extends {{Feature}}State {}

class {{Feature}}Loading extends {{Feature}}State {}

class {{Feature}}Loaded extends {{Feature}}State {}

class {{Feature}}Error extends {{Feature}}State {
  final String message;
  const {{Feature}}Error({required this.message});
}