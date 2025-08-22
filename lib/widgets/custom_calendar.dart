import 'package:flutter/material.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/fonts/fonts.dart';
import 'package:cage/utils/routes/responsive.dart';

class CustomCalendar extends StatefulWidget {
  final Function(DateTime) onDateSelected;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const CustomCalendar({
    Key? key,
    required this.onDateSelected,
    this.initialDate,
    this.firstDate,
    this.lastDate,
  }) : super(key: key);

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  late DateTime _selectedDate;
  late DateTime _focusedDate;
  late DateTime _firstDate;
  late DateTime _lastDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();
    _focusedDate = widget.initialDate ?? DateTime.now();
    _firstDate =
        widget.firstDate ?? DateTime.now().subtract(const Duration(days: 365));
    _lastDate =
        widget.lastDate ?? DateTime.now().add(const Duration(days: 365));
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);

    return Container(
      decoration: BoxDecoration(
        color: AppColor.black,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.red, width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          _buildHeader(),

          // Calendar Grid
          _buildCalendarGrid(),

          // Footer
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.red,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(14),
          topRight: Radius.circular(14),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: _previousMonth,
            icon: Icon(Icons.chevron_left, color: AppColor.white, size: 28),
          ),
          Text(
            _getMonthYearString(_focusedDate),
            style: TextStyle(
              fontFamily: AppFonts.appFont,
              color: AppColor.white,
              fontSize: Responsive.sp(18),
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            onPressed: _nextMonth,
            icon: Icon(Icons.chevron_right, color: AppColor.white, size: 28),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Day headers
          _buildDayHeaders(),
          const SizedBox(height: 8),
          // Calendar days
          _buildCalendarDays(),
        ],
      ),
    );
  }

  Widget _buildDayHeaders() {
    const days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    return Row(
      children: days.map((day) {
        return Expanded(
          child: Container(
            height: 40,
            alignment: Alignment.center,
            child: Text(
              day,
              style: TextStyle(
                fontFamily: AppFonts.appFont,
                color: AppColor.red,
                fontSize: Responsive.sp(14),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalendarDays() {
    final daysInMonth = DateTime(
      _focusedDate.year,
      _focusedDate.month + 1,
      0,
    ).day;
    final firstDayOfMonth = DateTime(_focusedDate.year, _focusedDate.month, 1);
    final firstWeekday = firstDayOfMonth.weekday % 7; // Sunday = 0

    List<Widget> dayWidgets = [];

    // Add empty cells for days before the first day of the month
    for (int i = 0; i < firstWeekday; i++) {
      dayWidgets.add(const Expanded(child: SizedBox(height: 40)));
    }

    // Add day cells
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_focusedDate.year, _focusedDate.month, day);
      final isSelected = _isSameDay(date, _selectedDate);
      final isToday = _isSameDay(date, DateTime.now());
      final isEnabled =
          date.isAfter(_firstDate.subtract(const Duration(days: 1))) &&
          date.isBefore(_lastDate.add(const Duration(days: 1)));

      dayWidgets.add(
        Expanded(
          child: GestureDetector(
            onTap: isEnabled ? () => _selectDate(date) : null,
            child: Container(
              height: 40,
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColor.red
                    : isToday
                    ? AppColor.red.withOpacity(0.3)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: isToday && !isSelected
                    ? Border.all(color: AppColor.red, width: 1)
                    : null,
              ),
              alignment: Alignment.center,
              child: Text(
                day.toString(),
                style: TextStyle(
                  fontFamily: AppFonts.appFont,
                  color: isSelected
                      ? AppColor.white
                      : isEnabled
                      ? AppColor.white
                      : AppColor.white.withOpacity(0.3),
                  fontSize: Responsive.sp(14),
                  fontWeight: isSelected || isToday
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
      );
    }

    // Create rows of 7 days each
    List<Widget> rows = [];
    for (int i = 0; i < dayWidgets.length; i += 7) {
      rows.add(Row(children: dayWidgets.skip(i).take(7).toList()));
    }

    return Column(children: rows);
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.black,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(14),
          bottomRight: Radius.circular(14),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontFamily: AppFonts.appFont,
                color: AppColor.white.withOpacity(0.7),
                fontSize: Responsive.sp(16),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              widget.onDateSelected(_selectedDate);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.red,
              foregroundColor: AppColor.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Select Date',
              style: TextStyle(
                fontFamily: AppFonts.appFont,
                fontSize: Responsive.sp(16),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _previousMonth() {
    setState(() {
      _focusedDate = DateTime(_focusedDate.year, _focusedDate.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _focusedDate = DateTime(_focusedDate.year, _focusedDate.month + 1);
    });
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  String _getMonthYearString(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}

// Helper function to show the calendar
Future<DateTime?> showCustomCalendar({
  required BuildContext context,
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
}) async {
  DateTime? selectedDate;

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: CustomCalendar(
          initialDate: initialDate,
          firstDate: firstDate,
          lastDate: lastDate,
          onDateSelected: (date) {
            selectedDate = date;
          },
        ),
      );
    },
  );

  return selectedDate;
}
