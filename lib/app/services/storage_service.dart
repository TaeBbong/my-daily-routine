import 'package:get_storage/get_storage.dart';
import '../models/routine.dart';

class StorageService {
  static const String ROUTINES_KEY = 'routines';
  final _box = GetStorage();

  Future<void> init() async {
    await GetStorage.init();
  }

  // 루틴 목록 저장
  Future<void> saveRoutines(List<Routine> routines) async {
    final routinesList = routines.map((routine) => routine.toJson()).toList();
    await _box.write(ROUTINES_KEY, routinesList);
  }

  // 루틴 목록 불러오기
  List<Routine> loadRoutines() {
    final routinesList = _box.read<List>(ROUTINES_KEY);
    if (routinesList == null) return [];

    return routinesList
        .map((json) => Routine.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  // 특정 날짜의 완료율 저장
  Future<void> saveCompletionRate(DateTime date, double rate) async {
    final key = 'completion_${date.year}_${date.month}_${date.day}';
    await _box.write(key, rate);
  }

  // 특정 날짜의 완료율 불러오기
  double? loadCompletionRate(DateTime date) {
    final key = 'completion_${date.year}_${date.month}_${date.day}';
    return _box.read<double>(key);
  }
}
