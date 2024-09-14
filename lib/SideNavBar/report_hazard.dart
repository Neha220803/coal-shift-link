import 'package:flutter/material.dart';

class ReportNewHazard extends StatefulWidget {
  const ReportNewHazard({super.key});

  @override
  State<ReportNewHazard> createState() => _ReportNewHazardState();
}

class _ReportNewHazardState extends State<ReportNewHazard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Report a New Hazard"),
      ),
    );
  }
}
