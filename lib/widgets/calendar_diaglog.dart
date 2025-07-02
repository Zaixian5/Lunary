import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarDialog extends StatefulWidget {
  final Function(String) onDateSelected;

  const CalendarDialog({super.key, required this.onDateSelected});

  @override
  State<CalendarDialog> createState() => _CalendarDialogState();
}

class _CalendarDialogState extends State<CalendarDialog> {
  late DateTime selectedMonth;

  @override
  void initState() {
    super.initState();
    selectedMonth = DateTime.now();
  }

  void _goToPreviousMonth() {
    setState(() {
      selectedMonth = DateTime(selectedMonth.year, selectedMonth.month - 1);
    });
  }

  void _goToNextMonth() {
    setState(() {
      selectedMonth = DateTime(selectedMonth.year, selectedMonth.month + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(selectedMonth.year, selectedMonth.month, 1);
    final lastDay = DateTime(selectedMonth.year, selectedMonth.month + 1, 0);
    final startOffset = firstDay.weekday % 7;

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.4),
      body: Center(
        child: Container(
          width: 320,
          padding: const EdgeInsets.only(top: 8, bottom: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white.withOpacity(0.95),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 상단 헤더
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.menu_book, color: Colors.pink),
                    const SizedBox(width: 8),
                    const Text(
                      '일기 보기',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, thickness: 0.8),

              // 날짜 선택 바
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: _goToPreviousMonth,
                      child: const Icon(Icons.chevron_left),
                    ),
                    Text(
                      '${selectedMonth.year}년 ${selectedMonth.month}월',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    GestureDetector(
                      onTap: _goToNextMonth,
                      child: const Icon(Icons.chevron_right),
                    ),
                  ],
                ),
              ),

              // 요일 표시 (한글)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: ['일', '월', '화', '수', '목', '금', '토'].map((label) {
                    return Expanded(
                      child: Center(
                        child: Text(
                          label,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 8),

              // 날짜들
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: startOffset + lastDay.day,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemBuilder: (context, index) {
                    if (index < startOffset) return const SizedBox.shrink();

                    final day = index - startOffset + 1;
                    final date = DateTime(
                      selectedMonth.year,
                      selectedMonth.month,
                      day,
                    );
                    final dateId = DateFormat('yyyy-MM-dd').format(date);

                    return GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        widget.onDateSelected(dateId); // 선택된 날짜 전달
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '$day',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF444444),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
