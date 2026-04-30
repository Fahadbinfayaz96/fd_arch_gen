part of '{{feature_snake}}_cubit.dart';


abstract class {{Feature}}State extends Equatable {
  const {{Feature}}State();
  
  @override
  List<Object?> get props => [];
}



class {{Feature}}Initial extends {{Feature}}State {}

class {{Feature}}Loading extends {{Feature}}State {}

class {{Feature}}Loaded extends {{Feature}}State {
  final List<dynamic> items;
  
  {{Feature}}Loaded(this.items);
  
  @override
  List<Object?> get props => [items];
}

class {{Feature}}Error extends {{Feature}}State {
  final String message;
  
  {{Feature}}Error(this.message);
  
  @override
  List<Object?> get props => [message];
}