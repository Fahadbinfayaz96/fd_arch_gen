import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/{{feature_snake}}_usecase.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/usecase/usecase.dart';
part '{{feature_snake}}_state.dart';


class {{Feature}}Cubit extends Cubit<{{Feature}}State> {
  final {{Feature}}UseCase useCase;

  {{Feature}}Cubit(this.useCase) : super({{Feature}}Initial());

  Future<void> fetchItems() async {
    emit({{Feature}}Loading());
    
    final result = await useCase(NoParams());
    
    result.fold(
      (failure) => emit({{Feature}}Error(failure.message)),
      (data) => emit({{Feature}}Loaded(data)),
    );
  }
}
