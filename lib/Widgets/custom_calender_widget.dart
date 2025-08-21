import 'package:ELibrary/Utilities/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import '../Utilities/text_style_helper.dart';

class CustomCalenderWidget extends StatelessWidget {
  final DateTime? firstDay,lastDay,focusDay;
  final Function(DateTime) onSelectDay;
  const CustomCalenderWidget({super.key, this.firstDay, this.lastDay, required this.onSelectDay, this.focusDay});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360.w,
      height: 407.h,
      decoration: BoxDecoration(
        color: const Color(0xff323741),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: TableCalendar(
        startingDayOfWeek: StartingDayOfWeek.monday,
        rowHeight: 48.h,
        daysOfWeekHeight: 48.h,
        firstDay: firstDay ?? DateTime(2020),
        lastDay: lastDay ?? DateTime.now(),
        focusedDay: focusDay ?? firstDay ?? DateTime.now(),
        selectedDayPredicate: (day) => isSameDay(focusDay, day),
        onDaySelected: (selectedDay, focusedDay) {
          context.pop();
          onSelectDay(selectedDay);
        },
        calendarStyle: CalendarStyle(
          cellMargin: EdgeInsets.symmetric(horizontal: 2.r,vertical: 4.r),
          todayDecoration: BoxDecoration(
            color: ThemeClass.of(context).primaryColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(8.r),
          ),
          selectedDecoration: BoxDecoration(
            color: ThemeClass.of(context).primaryColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(8.r),
          ),
          defaultDecoration: BoxDecoration(
            color: const Color(0xFF3B414A),
            borderRadius: BorderRadius.circular(8.r),
          ),
          weekendDecoration: BoxDecoration(
            color: const Color(0xFF3B414A),
            borderRadius: BorderRadius.circular(8.r),
          ),
          outsideDaysVisible: true,
          defaultTextStyle: TextStyleHelper.of(context).s16SemiBoldTextStyle,
          weekendTextStyle: TextStyleHelper.of(context).s16SemiBoldTextStyle,
          outsideTextStyle: TextStyleHelper.of(context).s16SemiBoldTextStyle.copyWith(color: const Color(0xff656A78)),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyleHelper.of(context).s16SemiBoldTextStyle.copyWith(color: const Color(0xff656A78),),
          weekendStyle: TextStyleHelper.of(context).s16SemiBoldTextStyle.copyWith(color: const Color(0xff656A78),),
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyleHelper.of(context).s16SemiBoldTextStyle,
          leftChevronIcon: const Icon(Icons.chevron_left, color: Colors.white),
          rightChevronIcon: const Icon(Icons.chevron_right, color: Colors.white),
        ),
      ),
    );
  }
}