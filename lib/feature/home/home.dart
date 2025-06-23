import 'package:flutter/material.dart';
import 'package:periodtracker/core/app_colors.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.green,
        child: Center(
            child: Text(
                "Home",
                style: TextStyle(
                  color: AppColorScheme.text(context),
                )
            )
        )
    );
  }
}
