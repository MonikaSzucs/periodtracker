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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            isDark
                ? 'assets/images/backgrounddark.jpg'
                : 'assets/images/backgroundlight.jpg',
          ), // Your image path
          fit: BoxFit.cover, // Covers entire screen
        ),
      ),
      child: Column(
        children: [
          // Header with title
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

          // Calendar
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SfCalendar(
                view: CalendarView.month,
                blackoutDatesTextStyle: TextStyle(
                  color: Colors.black, // Set your desired color here
                  fontWeight: FontWeight.bold,
                  fontSize: 14
                ),
                backgroundColor: Colors.transparent,
                todayHighlightColor: isDark ? Colors.blueAccent : Colors.blue,
                cellBorderColor: Colors.transparent,
                appointmentTextStyle: TextStyle(color: textColor),
                headerStyle: CalendarHeaderStyle(
                  textStyle: TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                monthViewSettings: MonthViewSettings(
                  showAgenda: true,
                  agendaStyle: AgendaStyle(
                    backgroundColor: isDark
                        ? Colors.black.withValues(alpha: 0.5)
                        : Colors.white.withValues(alpha: 0.7),
                    dayTextStyle: TextStyle(color: textColor),
                    dateTextStyle: TextStyle(color: textColor),
                    appointmentTextStyle: TextStyle(color: textColor),
                  ),
                  // Additional month view text styling
                  dayFormat: 'EEE',
                  showTrailingAndLeadingDates: true,
                  monthCellStyle: MonthCellStyle(
                    textStyle: TextStyle(
                      fontStyle: FontStyle.normal,
                      fontSize: 15,
                      color: Colors.black,
                    ),
                    leadingDatesTextStyle: TextStyle(
                      fontStyle: FontStyle.normal,
                      fontSize: 15,
                      color: Colors.black,
                    ),
                    trailingDatesTextStyle: TextStyle(
                      fontStyle: FontStyle.normal,
                      fontSize: 15,
                      color: Colors.black,  // Changed to use textColor variable
                    ),
                    leadingDatesBackgroundColor: Colors.grey,
                    trailingDatesBackgroundColor: Colors.grey
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
