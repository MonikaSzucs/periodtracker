import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:periodtracker/feature/home/home_viewmodel.dart';
import 'package:periodtracker/l10n/app_localizations.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final screenHeight = MediaQuery.of(context).size.height;

    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(),
      child: Consumer<HomeViewModel>(
        builder: (context, viewModel, _) {
          return Scaffold(
            body: Stack(
              children: [
                // Background image
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
                // Calendar and other UI components
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: Text(
                        AppLocalizations.of(context)?.titleHome ?? 'Calendar',
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
                            child: ConstrainedBox(
                              constraints: BoxConstraints(minHeight: constraints.maxHeight),
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width * 0.06,
                                  right: MediaQuery.of(context).size.width * 0.06,
                                  bottom: kBottomNavigationBarHeight + 
                                      MediaQuery.of(context).padding.bottom + 10,
                                ),
                                child: SizedBox(
                                  height: screenHeight * 0.9,
                                  child: SfCalendar(
                                    view: CalendarView.month,
                                    dataSource: viewModel.calendarDataSource,
                                    onTap: (CalendarTapDetails details) {
                                      if (details.targetElement == CalendarElement.calendarCell) {
                                        viewModel.handleDateTap(details.date!, context);
                                      } else if (details.targetElement == CalendarElement.appointment) {
                                        viewModel.showAppointmentEditor(
                                          context, 
                                          details.date!, 
                                          details.appointments?.first,
                                        );
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
                                        height: 50,
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
                                            SizedBox(height: 50),
                                            Text(
                                              timeRange,
                                              style: TextStyle(
                                                color: Colors.white.withOpacity(0.8),
                                                fontSize: 10,
                                                fontStyle: appointment.isAllDay ? FontStyle.italic : FontStyle.normal,
                                              ),
                                            ),
                                          ],
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
                                        color: textColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      dateTextStyle: TextStyle(color: textColor),
                                    ),
                                    backgroundColor: Colors.transparent,
                                    todayHighlightColor: isDark ? Colors.blueAccent : Colors.black,
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
                                      navigationDirection: MonthNavigationDirection.vertical,
                                      monthCellStyle: MonthCellStyle(
                                        textStyle: TextStyle(
                                          color: textColor,
                                          fontSize: 15,
                                        ),
                                        leadingDatesTextStyle: TextStyle(
                                          color: textColor.withOpacity(0.4),
                                          fontSize: 15,
                                        ),
                                        trailingDatesTextStyle: TextStyle(
                                          color: textColor.withOpacity(0.4),
                                          fontSize: 15,
                                        ),
                                        leadingDatesBackgroundColor: Colors.grey.withOpacity(0.4),
                                        trailingDatesBackgroundColor: Colors.grey.withOpacity(0.4),
                                        todayBackgroundColor: Colors.blue.withOpacity(0.3),
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
          );
        },
      ),
    );
  }
}