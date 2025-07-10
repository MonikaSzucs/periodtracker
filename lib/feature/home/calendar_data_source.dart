import 'package:syncfusion_flutter_calendar/calendar.dart';

class AppCalendarDataSource extends CalendarDataSource {  // Changed class name
  AppCalendarDataSource(List<Appointment> source) {
    appointments = source;
  }

  @override
  List<Appointment> get appointments => super.appointments as List<Appointment>;
  
  void updateAppointments(List<Appointment> newAppointments) {
    appointments = newAppointments;
    notifyListeners(CalendarDataSourceAction.reset, []);
  }
}