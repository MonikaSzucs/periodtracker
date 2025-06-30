import 'package:flutter/material.dart';
import 'package:periodtracker/core/app_colors.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../l10n/app_localizations.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentPage = 0;
  List<Appointment> appointments = [];

  void _showAppointmentEditor(BuildContext context, DateTime selectedDate, [Appointment? existingAppointment]) {
    final textController = TextEditingController(text: existingAppointment?.subject ?? '');
    final startTimeController = TextEditingController(
      text: existingAppointment?.startTime.toString().substring(11, 16) ?? '09:00'
    );
    final endTimeController = TextEditingController(
      text: existingAppointment?.endTime.toString().substring(11, 16) ?? '10:00'
    );
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDark ? Colors.grey[900] : Colors.white,
          title: Text(
            existingAppointment == null ? 'Add Appointment' : 'Edit Appointment',
            style: TextStyle(color: isDark ? Colors.white : Colors.black),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: textController,
                  decoration: InputDecoration(
                    labelText: 'Note',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: startTimeController,
                        decoration: InputDecoration(
                          labelText: 'Start Time (HH:MM)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.datetime,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: endTimeController,
                        decoration: InputDecoration(
                          labelText: 'End Time (HH:MM)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.datetime,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            if (existingAppointment != null)
              TextButton(
                onPressed: () {
                  setState(() {
                    appointments.remove(existingAppointment);
                  });
                  Navigator.pop(context);
                },
                child: Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            TextButton(
              onPressed: () {
                final startTime = _parseTime(selectedDate, startTimeController.text);
                final endTime = _parseTime(selectedDate, endTimeController.text);
                
                if (startTime != null && endTime != null && endTime.isAfter(startTime)) {
                  setState(() {
                    if (existingAppointment != null) {
                      appointments.remove(existingAppointment);
                    }
                    appointments.add(Appointment(
                      startTime: startTime,
                      endTime: endTime,
                      subject: textController.text,
                      color: Colors.blue,
                      notes: 'Custom note',
                    ));
                  });
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Invalid time format or end time before start time')),
                  );
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  DateTime? _parseTime(DateTime date, String time) {
    try {
      final parts = time.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      return DateTime(date.year, date.month, date.day, hour, minute);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final navBarHeight = kBottomNavigationBarHeight;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  isDark
                      ? 'assets/images/backgrounddark.jpg'
                      : 'assets/images/backgroundlight.jpg',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Text(
                  l10n?.titleHome ?? 'Calendar',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: screenWidth * 0.06,
                            right: screenWidth * 0.06,
                            bottom: navBarHeight + bottomPadding + 10,
                          ),
                          child: SizedBox(
                            height: screenHeight * 0.9,
                            child: SfCalendar(
                              view: CalendarView.month,
                              dataSource: _CalendarDataSource(appointments),
                              onTap: (CalendarTapDetails details) {
                                if (details.targetElement == CalendarElement.calendarCell) {
                                  _showAppointmentEditor(context, details.date!);
                                } else if (details.appointments != null && details.appointments!.isNotEmpty) {
                                  _showAppointmentEditor(context, details.date!, details.appointments!.first);
                                }
                              },
                              headerStyle: CalendarHeaderStyle(
                                backgroundColor: Colors.transparent,
                                textStyle: TextStyle(
                                  color: Colors.red,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              viewHeaderStyle: ViewHeaderStyle(
                                dayTextStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                dateTextStyle: TextStyle(color: Colors.black),
                              ),
                              backgroundColor: Colors.transparent,
                              todayHighlightColor: isDark ? Colors.blueAccent : Colors.blue,
                              cellBorderColor: Colors.transparent,
                              monthViewSettings: MonthViewSettings(
                                showAgenda: true,
                                agendaViewHeight: screenHeight * 0.4,
                                agendaStyle: AgendaStyle(
                                  backgroundColor: isDark
                                      ? Colors.black.withOpacity(0.5)
                                      : Colors.white.withOpacity(0.7),
                                  dayTextStyle: TextStyle(color: textColor),
                                  dateTextStyle: TextStyle(color: textColor),
                                  appointmentTextStyle: TextStyle(color: textColor),
                                ),
                                dayFormat: 'EEE',
                                showTrailingAndLeadingDates: true,
                                monthCellStyle: MonthCellStyle(
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                  leadingDatesTextStyle: TextStyle(
                                    color: Colors.black.withOpacity(0.4),
                                    fontSize: 15,
                                  ),
                                  trailingDatesTextStyle: TextStyle(
                                    color: Colors.black.withOpacity(0.4),
                                    fontSize: 15,
                                  ),
                                  leadingDatesBackgroundColor: Colors.grey.withOpacity(0.4),
                                  trailingDatesBackgroundColor: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAppointmentEditor(context, DateTime.now());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class _CalendarDataSource extends CalendarDataSource {
  _CalendarDataSource(List<Appointment> source) {
    appointments = source;
  }
}