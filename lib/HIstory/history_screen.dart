import 'package:desktopadmin/HIstory/income_history_page.dart';
import 'package:desktopadmin/Services/constans.dart';
import 'package:desktopadmin/Services/responsive.dart';
import 'package:desktopadmin/Main/header.dart';
import 'package:desktopadmin/HIstory/outcome_history_page.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  dynamic lokal = 'id_ID';

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting(lokal);

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(defaultpadding),
        child: Column(
          children: [
            Header(
              title: 'Riwayat Transaksi',
            ),
            const SizedBox(
              height: 20,
            ),
            if (Responsive.isMobile(context))
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white30),
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 400,
                width: Responsive.isMobile(context) ? double.maxFinite : 400,
                child: TableCalendar(
                  locale: lokal,
                  firstDay: DateTime.utc(2022, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  onFormatChanged: (format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  },
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  daysOfWeekStyle: const DaysOfWeekStyle(
                      weekdayStyle: TextStyle(color: Colors.white),
                      weekendStyle: TextStyle(color: Colors.white70)),
                ),
              ),
            if (!Responsive.isMobile(context))
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white30),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      height: 400,
                      width: 400,
                      child: TableCalendar(
                        locale: lokal,
                        firstDay: DateTime.utc(2022, 1, 1),
                        lastDay: DateTime.utc(2030, 12, 31),
                        focusedDay: _focusedDay,
                        calendarFormat: _calendarFormat,
                        onFormatChanged: (format) {
                          setState(() {
                            _calendarFormat = format;
                          });
                        },
                        selectedDayPredicate: (day) {
                          return isSameDay(_selectedDay, day);
                        },
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            _selectedDay = selectedDay;
                            _focusedDay = focusedDay;
                          });
                        },
                        daysOfWeekStyle: const DaysOfWeekStyle(
                            weekdayStyle: TextStyle(color: Colors.white),
                            weekendStyle: TextStyle(color: Colors.white70)),
                      ),
                    ),
                  ),
                  SizedBox(
                          width: 10,
                        ),
                  Expanded(flex: 4, child: Container(
                    height: 400,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white38),
                      borderRadius: BorderRadius.circular(10)

                    ),
                  ))
                ],
              ),
            Container(
              padding: EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  if (Responsive.isMobile(context))
                    IncomeHistoryListPage(
                      selectedDate: _selectedDay,
                    ),
                  if (Responsive.isMobile(context))
                    OutcomeHistoryListPage(
                      selectedDate: _selectedDay,
                    ),
                  if (!Responsive.isMobile(context))
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: IncomeHistoryListPage(
                            selectedDate: _selectedDay,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 2,
                          child: OutcomeHistoryListPage(
                            selectedDate: _selectedDay,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
