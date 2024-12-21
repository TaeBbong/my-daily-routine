import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/progress_service.dart';
import '../themes/app_colors.dart';

class LogTabController extends GetxController {
  final ProgressService _progressService = Get.find<ProgressService>();

  // 캘린더 관련 변수들
  final Rx<DateTime> selectedDay = DateTime.now().obs;
  final Rx<DateTime> focusedDay = DateTime.now().obs;
  final RxDouble weeklyAverage = 0.0.obs;
  final RxDouble monthlyAverage = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    print('now: ${DateTime.now()}');
    _updateStatistics();

    // ProgressService의 progressCache 변경 감지
    ever(_progressService.progressCache, (_) {
      _updateStatistics();
      update(); // UI 업데이트 트리거
    });
  }

  void _updateStatistics() {
    weeklyAverage.value = _progressService.getWeeklyAverage();
    monthlyAverage.value = _progressService.getMonthlyAverage();
  }

  // 날짜 선택 시 호출되는 메서드
  void onDaySelected(DateTime selected, DateTime focused) {
    // 선택된 날짜가 오늘 이후면 선택하지 않음
    if (selected.isAfter(DateTime.now())) return;

    selectedDay.value = selected;
    focusedDay.value = focused;
  }

  // 완료율에 따른 색상 반환
  Color getColorForDate(DateTime date) {
    // 미래 날짜는 흰색 처리
    if (date.isAfter(DateTime.now())) {
      print('date: $date, rate: 0');
      return AppColors.progress0;
    }

    final rate = _progressService.getProgress(date);
    print('date: $date, rate: $rate');
    if (rate >= 1.0) return AppColors.progress100;
    if (rate >= 0.8) return AppColors.progress80;
    if (rate >= 0.6) return AppColors.progress60;
    if (rate >= 0.4) return AppColors.progress40;
    if (rate >= 0.2) return AppColors.progress20;
    return AppColors.progress0;
  }

  // 선택된 날짜의 진행률 가져오기
  double getSelectedDayProgress() {
    return _progressService.getProgress(selectedDay.value);
  }
}
