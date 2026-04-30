import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../getx/{{snake}}_controller.dart';

class {{Feature}}View extends GetView<{{Feature}}Controller> {
  const {{Feature}}View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('{{Feature}}'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (controller.error.value.isNotEmpty) {
          return Center(child: Text(controller.error.value));
        }
        
        return ListView.builder(
          itemCount: controller.items.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(controller.items[index].toString()),
            );
          },
        );
      }),
    );
  }
}