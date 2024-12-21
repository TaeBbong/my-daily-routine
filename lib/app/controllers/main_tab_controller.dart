import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../models/routine.dart';
import '../views/widgets/routine_dialog.dart';
import '../services/storage_service.dart';
import '../services/progress_service.dart';

class MainTabController extends GetxController {
  final RxBool isEditMode = false.obs;
  final RxList<Routine> routines = <Routine>[].obs;
  final Rx<DateTime> currentTime = DateTime.now().obs;
  final StorageService _storage = Get.find<StorageService>();
  final ProgressService _progressService = Get.find<ProgressService>();

  @override
  void onInit() {
    super.onInit();
    _loadRoutines();
    _updateTime();
  }

  void _loadRoutines() {
    routines.value = _storage.loadRoutines();
  }

  // 루틴 변경시마다 저장하는 메서드
  Future<void> _saveRoutines() async {
    await _storage.saveRoutines(routines);
    // 진행률 업데이트
    final progress = _calculateTodayCompletionRate();
    await _progressService.updateProgress(DateTime.now(), progress);
  }

  // 완료율 계산
  double _calculateTodayCompletionRate() {
    if (routines.isEmpty) return 0.0;
    final completedCount = routines.where((r) => r.isDone).length;
    return completedCount / routines.length;
  }

  void _updateTime() {
    Future.delayed(const Duration(seconds: 1), () {
      currentTime.value = DateTime.now();
      _updateTime();
    });
  }

  void toggleEditMode() {
    isEditMode.value = !isEditMode.value;
  }

  Future<void> toggleRoutine(String id) async {
    final index = routines.indexWhere((routine) => routine.id == id);
    if (index != -1) {
      final routine = routines[index];
      routines[index] = routine.copyWith(isDone: !routine.isDone);
      await _saveRoutines();

      // 진행률 업데이트
      final progress = _calculateTodayCompletionRate();
      await _progressService.updateProgress(DateTime.now(), progress);
    }
  }

  // 루틴 추가
  Future<void> addRoutine() async {
    final result = await Get.dialog<String>(RoutineDialog());
    if (result != null) {
      final routine = Routine(
        id: const Uuid().v4(),
        title: result,
        isDone: false,
        date: DateTime.now(),
      );
      routines.add(routine);
      await _saveRoutines();
    }
  }

  // 루틴 수정
  Future<void> editRoutine(Routine routine) async {
    final result = await Get.dialog<String>(RoutineDialog(routine: routine));
    if (result != null) {
      final index = routines.indexWhere((r) => r.id == routine.id);
      if (index != -1) {
        routines[index] = routine.copyWith(title: result);
        await _saveRoutines();
      }
    }
  }

  // 루틴 삭제
  Future<void> deleteRoutine(String id) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('루틴 삭제'),
        content: const Text('이 루틴을 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('삭제'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      routines.removeWhere((routine) => routine.id == id);
      await _saveRoutines();
    }
  }
}
