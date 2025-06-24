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
    return Container(
        color: Colors.white,
        child: Center(
            child: Text(
              l10n?.titleMore ?? '',
            )
        )
    );
  }
}
