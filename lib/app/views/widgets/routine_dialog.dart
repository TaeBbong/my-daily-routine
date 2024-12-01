import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/routine.dart';

class RoutineDialog extends StatelessWidget {
  final Routine? routine;
  final TextEditingController _titleController = TextEditingController();

  RoutineDialog({Key? key, this.routine}) : super(key: key) {
    if (routine != null) {
      _titleController.text = routine!.title;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(routine == null ? '새로운 루틴 추가' : '루틴 수정'),
      content: TextField(
        controller: _titleController,
        decoration: const InputDecoration(
          labelText: '루틴 이름',
          hintText: '루틴 이름을 입력하세요',
        ),
        autofocus: true,
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('취소'),
        ),
        TextButton(
          onPressed: () {
            if (_titleController.text.trim().isEmpty) {
              Get.snackbar('오류', '루틴 이름을 입력해주세요');
              return;
            }
            Get.back(result: _titleController.text.trim());
          },
          child: const Text('확인'),
        ),
      ],
    );
  }
}
