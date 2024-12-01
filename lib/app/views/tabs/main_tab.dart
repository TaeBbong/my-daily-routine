import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/main_tab_controller.dart';

class MainTabView extends GetView<MainTabController> {
  const MainTabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => Text(
                  DateFormat('yyyy년 MM월 dd일')
                      .format(controller.currentTime.value),
                  style: const TextStyle(fontSize: 16),
                )),
            Obx(() => Text(
                  DateFormat('HH:mm:ss').format(controller.currentTime.value),
                  style: const TextStyle(fontSize: 24),
                )),
          ],
        ),
        actions: [
          Obx(() => controller.isEditMode.value
              ? TextButton(
                  onPressed: controller.toggleEditMode,
                  child:
                      const Text('완료', style: TextStyle(color: Colors.white)),
                )
              : const SizedBox()),
        ],
      ),
      body: Obx(() => ListView.builder(
            itemCount: controller.routines.length,
            itemBuilder: (context, index) {
              final routine = controller.routines[index];
              return ListTile(
                title: Text(routine.title),
                trailing: controller.isEditMode.value
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => controller.editRoutine(routine),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () =>
                                controller.deleteRoutine(routine.id),
                          ),
                        ],
                      )
                    : IconButton(
                        icon: Icon(
                          routine.isDone
                              ? Icons.check_circle
                              : Icons.check_circle_outline,
                          color: routine.isDone ? Colors.green : Colors.grey,
                        ),
                        onPressed: () => controller.toggleRoutine(routine.id),
                      ),
              );
            },
          )),
      floatingActionButton: Obx(() => FloatingActionButton(
            onPressed: controller.isEditMode.value
                ? controller.addRoutine
                : controller.toggleEditMode,
            child: Icon(
              controller.isEditMode.value ? Icons.add : Icons.edit,
            ),
          )),
    );
  }
}
