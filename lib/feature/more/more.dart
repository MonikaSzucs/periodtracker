import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

class More extends StatefulWidget {
  const More({super.key});

  @override
  State<More> createState() => _MoreState();
}

class _MoreState extends State<More> {

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
              l10n?.titleMore ?? '',
            )
        )
    );
  }
}
