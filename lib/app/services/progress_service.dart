import 'package:get/get.dart';
import '../models/routine.dart';
import 'storage_service.dart';

class ProgressService extends GetxService {
  final StorageService _storage = Get.find<StorageService>();
  final progressCache = <DateTime, double>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _loadRecentProgress();
  }

  // 최근 진행률 로드 (최근 3개월)
  void _loadRecentProgress() {
    final now = DateTime.now();
    for (var i = 0; i < 90; i++) {
      final date = now.subtract(Duration(days: i));
      final dateKey = DateTime(date.year, date.month, date.day);
      final progress = _storage.loadCompletionRate(dateKey);
      if (progress != null) {
        progressCache[dateKey] = progress;
      }
    }
  }

  // 오늘의 진행률 계산 및 저장
  Future<void> updateTodayProgress(List<Routine> routines) async {
    if (routines.isEmpty) return;

    final today = DateTime.now();
    final dateKey = DateTime(today.year, today.month, today.day);

    final completedCount = routines.where((r) => r.isDone).length;
    final progress = completedCount / routines.length;

    progressCache[dateKey] = progress;
    await _storage.saveCompletionRate(dateKey, progress);
  }

  // 특정 날짜의 진행률 조회
  double getProgress(DateTime date) {
    final dateKey = DateTime(date.year, date.month, date.day);
    return progressCache[dateKey] ?? 0.0;
  }

  // 주간 평균 진행률 계산
  double getWeeklyAverage() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));

    double sum = 0;
    int count = 0;

    for (var i = 0; i < 7; i++) {
      final date = weekStart.add(Duration(days: i));
      final progress = getProgress(date);
      if (progress > 0) {
        sum += progress;
        count++;
      }
    }

    return count > 0 ? sum / count : 0.0;
  }

  // 월간 평균 진행률 계산
  double getMonthlyAverage() {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);

    double sum = 0;
    int count = 0;

    for (var date = monthStart;
        date.isBefore(now.add(const Duration(days: 1)));
        date = date.add(const Duration(days: 1))) {
      final progress = getProgress(date);
      if (progress > 0) {
        sum += progress;
        count++;
      }
    }

    return count > 0 ? sum / count : 0.0;
  }

  // 진행률 업데이트 메서드
  Future<void> updateProgress(DateTime date, double progress) async {
    final dateKey = DateTime(date.year, date.month, date.day);
    progressCache[dateKey] = progress;
    await _storage.saveCompletionRate(dateKey, progress);
  }
}
