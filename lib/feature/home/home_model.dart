import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class HomeModel {
  List<Appointment> appointments = [];
  DateTime? lastTapDate;
  DateTime? lastTapTime;
  Color _selectedColor = Colors.blue;

  Color get selectedColor => _selectedColor;
  set selectedColor(Color color) {
    _selectedColor = color;
  }

  // Add/update/delete appointments
  void addAppointment(Appointment appointment) {
    appointments.add(appointment);
  }

  void updateAppointment(int index, Appointment appointment) {
    appointments[index] = appointment;
  }

  void deleteAppointment(Appointment appointment) {
    appointments.remove(appointment);
  }
}