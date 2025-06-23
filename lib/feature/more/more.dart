import 'package:flutter/material.dart';

class More extends StatefulWidget {
  const More({super.key});

  @override
  State<More> createState() => _MoreState();
}

class _MoreState extends State<More> {

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.blue,
        child: const Center(
            child: Text("More")
        )
    );
  }
}
