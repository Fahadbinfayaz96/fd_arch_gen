import 'package:get/get.dart';
import '../../domain/usecases/{{snake}}_usecase.dart';
import '../../domain/entities/{{snake}}_entity.dart';
import '../../../../core/usecase/usecase.dart'; 

class {{Feature}}Controller extends GetxController {
  final {{Feature}}UseCase useCase;
  
  final items = <{{Feature}}Entity>[].obs;
  final isLoading = false.obs;
  final error = ''.obs;

  {{Feature}}Controller(this.useCase);

  @override
  void onInit() {
    super.onInit();
    fetchItems();
  }

  Future<void> fetchItems() async {
    isLoading.value = true;
    
    final result = await useCase(NoParams());
    
    result.fold(
      (failure) => error.value = failure.message,
      (data) => items.value = data,
    );
    
    isLoading.value = false;
  }
}