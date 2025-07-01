import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  late _CalendarDataSource _calendarDataSource;
  DateTime? _lastTapTime;
  DateTime? _lastTapDate;

  @override
  void initState() {
    super.initState();
    _calendarDataSource = _CalendarDataSource(appointments);
  }

  void _handleDateTap(DateTime date) {
    final now = DateTime.now();
    if (_lastTapDate == date && 
        _lastTapTime != null && 
        now.difference(_lastTapTime!) < const Duration(milliseconds: 300)) {
      // Double tap detected
      _showAppointmentEditor(context, date);
    }
    _lastTapTime = now;
    _lastTapDate = date;
  }

  void _showAppointmentEditor(BuildContext context, DateTime selectedDate, [Appointment? existingAppointment]) {
    final textController = TextEditingController(text: existingAppointment?.subject ?? '');
    final startTimeController = TextEditingController(
      text: existingAppointment?.startTime.toString().substring(11, 16) ?? '09:00'
    );
    final endTimeController = TextEditingController(
      text: existingAppointment?.endTime.toString().substring(11, 16) ?? '10:00'
    );
    bool isAllDay = existingAppointment?.isAllDay ?? false;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
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
                    Container(
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[800] : Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Row(
                        children: [
                          Checkbox(
                            value: isAllDay,
                            onChanged: (value) {
                              setState(() {
                                isAllDay = value ?? false;
                                if (isAllDay) {
                                  startTimeController.text = '00:00';
                                  endTimeController.text = '23:59';
                                }
                              });
                            },
                          ),
                          Text('All Day Event',
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black,
                                fontSize: 16,
                              )),
                        ],
                      ),
                    ),
                    if (!isAllDay) SizedBox(height: 16),
                    if (!isAllDay)
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: startTimeController,
                              decoration: InputDecoration(
                                labelText: 'Start Time (HH:MM)',
                                border: OutlineInputBorder(),
                                filled: isAllDay,
                                fillColor: isDark ? Colors.grey[700] : Colors.grey[300],
                              ),
                              keyboardType: TextInputType.datetime,
                              enabled: !isAllDay,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: TextField(
                              controller: endTimeController,
                              decoration: InputDecoration(
                                labelText: 'End Time (HH:MM)',
                                border: OutlineInputBorder(),
                                filled: isAllDay,
                                fillColor: isDark ? Colors.grey[700] : Colors.grey[300],
                              ),
                              keyboardType: TextInputType.datetime,
                              enabled: !isAllDay,
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
                        _calendarDataSource.updateAppointments(List<Appointment>.from(appointments));
                      });
                      Navigator.pop(context);
                    },
                    child: Text('Delete', style: TextStyle(color: Colors.red)),
                  ),
                TextButton(
                  onPressed: () {
                    DateTime startTime;
                    DateTime endTime;
                    
                    if (isAllDay) {
                      startTime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
                      endTime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 23, 59);
                    } else {
                      final parsedStart = _parseTime(selectedDate, startTimeController.text);
                      final parsedEnd = _parseTime(selectedDate, endTimeController.text);
                      
                      if (parsedStart == null || parsedEnd == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please enter valid times in HH:MM format')),
                        );
                        return;
                      }
                      
                      if (!parsedEnd.isAfter(parsedStart)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('End time must be after start time')),
                        );
                        return;
                      }
                      
                      startTime = parsedStart;
                      endTime = parsedEnd;
                    }
                    
                    final newAppointment = Appointment(
                      startTime: startTime,
                      endTime: endTime,
                      subject: textController.text.isEmpty 
                          ? (isAllDay ? 'All Day Event' : 'Appointment')
                          : textController.text,
                      color: isAllDay ? Colors.green : Colors.blue,
                      isAllDay: isAllDay,
                    );

                    setState(() {
                      if (existingAppointment != null) {
                        final index = appointments.indexOf(existingAppointment);
                        if (index != -1) {
                          appointments[index] = newAppointment;
                        }
                      } else {
                        appointments.add(newAppointment);
                      }
                      _calendarDataSource.updateAppointments(List<Appointment>.from(appointments));
                    });
                    Navigator.pop(context);
                  },
                  child: Text('Save'),
                ),
              ],
            );
          },
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
                              dataSource: _calendarDataSource,
                              onTap: (CalendarTapDetails details) {
                                if (details.targetElement == CalendarElement.calendarCell) {
                                  _handleDateTap(details.date!);
                                  if (details.appointments != null && details.appointments!.isNotEmpty) {
                                    return;
                                  }
                                } else if (details.targetElement == CalendarElement.appointment &&
                                    details.appointments != null &&
                                    details.appointments!.isNotEmpty) {
                                  _showAppointmentEditor(context, details.date!, details.appointments!.first);
                                }
                              },
                              selectionDecoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(color: Colors.blue, width: 2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              appointmentBuilder: (context, details) {
                                final appointment = details.appointments.first;
                                final startTime = appointment.startTime;
                                final endTime = appointment.endTime;

                                final timeFormat = DateFormat.jm();
                                final timeRange = appointment.isAllDay 
                                    ? 'All Day' 
                                    : '${timeFormat.format(startTime)} - ${timeFormat.format(endTime)}';

                                return Container(
                                  decoration: BoxDecoration(
                                    color: appointment.color,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  padding: EdgeInsets.all(4),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        appointment.subject,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        timeRange,
                                        style: TextStyle(
                                          color: Colors.white.withValues(alpha:0.8),
                                          fontSize: 10,
                                          fontStyle: appointment.isAllDay ? FontStyle.italic : FontStyle.normal,
                                        ),
                                      )
                                    ]
                                  ),
                                );
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
                                      ? Colors.black.withValues(alpha:0.5)
                                      : Colors.white.withValues(alpha:0.7),
                                  dayTextStyle: TextStyle(color: textColor),
                                  dateTextStyle: TextStyle(color: textColor),
                                  appointmentTextStyle: TextStyle(color: textColor),
                                ),
                                dayFormat: 'EEE',
                                showTrailingAndLeadingDates: true,
                                navigationDirection: MonthNavigationDirection.vertical,
                                monthCellStyle: MonthCellStyle(
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                  leadingDatesTextStyle: TextStyle(
                                    color: Colors.black.withValues(alpha:0.4),
                                    fontSize: 15,
                                  ),
                                  trailingDatesTextStyle: TextStyle(
                                    color: Colors.black.withValues(alpha:0.4),
                                    fontSize: 15,
                                  ),
                                  leadingDatesBackgroundColor: Colors.grey.withValues(alpha:0.4),
                                  trailingDatesBackgroundColor: Colors.grey,
                                  todayBackgroundColor: Colors.blue.withValues(alpha: 0.3),
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

  @override
  List<Appointment> get appointments => super.appointments as List<Appointment>;
  
  void updateAppointments(List<Appointment> newAppointments) {
    appointments = newAppointments;
    notifyListeners(CalendarDataSourceAction.reset, []);
  }
}