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
    return Container(
        color: Colors.white,
        child: Center(
            child: Text(
              l10n?.titleReport ?? '',
            )
        )
    );
  }
}
