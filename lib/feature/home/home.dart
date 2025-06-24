import 'package:flutter/material.dart';
import 'package:periodtracker/core/app_colors.dart';
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
    return Container(
        color: Colors.white,
        child: Center(
            child: Text(
                l10n?.titleHome ?? '',
                style: TextStyle(
                  color: AppColorScheme.text(context),
                )
            )
        )
    );
  }
}
