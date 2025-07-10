import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:periodtracker/feature/home/calendar_data_source.dart';
import 'package:periodtracker/feature/home/home_model.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class HomeViewModel with ChangeNotifier {
  final HomeModel _model = HomeModel();
  late final AppCalendarDataSource _calendarDataSource;

  HomeViewModel() {
    _calendarDataSource = AppCalendarDataSource(_model.appointments);
  }

  // Getters
  List<Appointment> get appointments => _model.appointments;
  Color get selectedColor => _model.selectedColor;
  CalendarDataSource get calendarDataSource => _calendarDataSource;
  Color _selectedColor = Colors.blue;

  // Handle double-tap logic
  void handleDateTap(DateTime date, BuildContext context) {
    showAppointmentEditor(context, date);
  }

  Widget _buildColorCircle(Color color, bool isDark, StateSetter setState) {
  return GestureDetector(
    onTap: () {
      setState(() {
        _selectedColor = color; // Update the selected color
        _model.selectedColor = color;
      });
    },
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: _selectedColor == color 
              ? (isDark ? Colors.white : Colors.black) 
              : Colors.transparent,
          width: 2,
        ),
      ),
    ),
  );
}

  
void showAppointmentEditor(BuildContext context, DateTime selectedDate, [Appointment? existingAppointment]) {
  final textController = TextEditingController(text: existingAppointment?.subject ?? '');
  final startTimeController = TextEditingController(
    text: existingAppointment?.startTime.toString().substring(11, 16) ?? '09:00'
  );
  final endTimeController = TextEditingController(
    text: existingAppointment?.endTime.toString().substring(11, 16) ?? '10:00'
  );
  bool isAllDay = existingAppointment?.isAllDay ?? false;
  final isDark = Theme.of(context).brightness == Brightness.dark;
  Color _tempSelectedColor = existingAppointment?.color ?? _selectedColor;

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
                  SizedBox(height: 16),
                  Text('Select Color:', 
                      style: TextStyle(color: isDark ? Colors.white : Colors.black)),
                  SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildColorCircle(Colors.red, isDark, setState),
                        _buildColorCircle(Colors.blue, isDark, setState),
                        _buildColorCircle(Colors.orange, isDark, setState),
                      ],
                    ),
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
                    color: _selectedColor, // Use the selected color
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
}}


// Parse time (utility function)
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