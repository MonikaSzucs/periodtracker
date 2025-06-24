import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(isDark ? 'assets/images/backgrounddark.jpg': 'assets/images/backgroundlight.jpg'),
            fit: BoxFit.cover, // Covers entire screen
          ),
        ),
        child: Center(
            child: Text(
              l10n?.titleReport ?? '',
            )
        )
    );
  }
}
