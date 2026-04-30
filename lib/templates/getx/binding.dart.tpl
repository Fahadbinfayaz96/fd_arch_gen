import 'package:get/get.dart';
import '{{snake}}_controller.dart';
import '../../../../core/di/injection_container.dart';

class {{Feature}}Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<{{Feature}}Controller>(
      () => {{Feature}}Controller(sl()),
    );
  }
}