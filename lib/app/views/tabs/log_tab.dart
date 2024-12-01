import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../controllers/log_tab_controller.dart';
import '../../themes/app_colors.dart';

class LogTabView extends GetView<LogTabController> {
  const LogTabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('진행 기록'),
      ),
      body: Column(
        children: [
          // 통계 카드 추가
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    '주간 평균',
                    controller.weeklyAverage,
                    Icons.view_week,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    '월간 평균',
                    controller.monthlyAverage,
                    Icons.calendar_month,
                  ),
                ),
              ],
            ),
          ),
          // 기존 캘린더 위젯
          Obx(() => TableCalendar(
                firstDay: DateTime.utc(2024, 1, 1),
                lastDay: DateTime.utc(2024, 12, 31),
                focusedDay: controller.focusedDay.value,
                selectedDayPredicate: (day) =>
                    isSameDay(controller.selectedDay.value, day),
                onDaySelected: controller.onDaySelected,
                calendarStyle: CalendarStyle(
                  outsideDaysVisible: false,
                  weekendTextStyle: const TextStyle(color: Colors.red),
                  holidayTextStyle: const TextStyle(color: Colors.red),
                ),
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, date, _) {
                    return Container(
                      margin: const EdgeInsets.all(4.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: controller.getColorForDate(date),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${date.day}',
                        style: TextStyle(
                          color: controller.getColorForDate(date) ==
                                  AppColors.progress0
                              ? Colors.black
                              : Colors.white,
                        ),
                      ),
                    );
                  },
                ),
              )),
          const SizedBox(height: 20),
          // 진행률 범례
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLegendItem('0%', AppColors.progress0),
                _buildLegendItem('20%', AppColors.progress20),
                _buildLegendItem('40%', AppColors.progress40),
                _buildLegendItem('60%', AppColors.progress60),
                _buildLegendItem('80%', AppColors.progress80),
                _buildLegendItem('100%', AppColors.progress100),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildStatCard(String title, RxDouble value, IconData icon) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Obx(() => Text(
                  '${(value.value * 100).toStringAsFixed(1)}%',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
