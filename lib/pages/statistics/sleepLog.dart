import 'package:flutter/material.dart';
import 'package:fitness/components/textStyle/textstyle.dart';

class SleepLog extends StatelessWidget {
  const SleepLog({super.key});

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Color(0xFF2E2F55),
    appBar: AppBar(
      backgroundColor: const Color(0xFF2E2F55),
      centerTitle: true,
      title: Text(
        'Statistics',
        style: titleTextStyle(),
      ),
    ),
  );
}
}
