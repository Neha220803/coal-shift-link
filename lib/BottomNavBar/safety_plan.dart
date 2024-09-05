import 'package:flutter/material.dart';

// Mock data for SMP entries
final List<Map<String, dynamic>> smpEntries = [
  {
    "smp_id": "smp789",
    "hazard_id": "hazard123",
    "control_measures": "Ensure proper ventilation in work areas.",
    "monitoring_status": "Active",
    "created_at": "2024-09-05T09:30:00Z",
    "updated_at": "2024-09-05T11:00:00Z",
  },
  {
    "smp_id": "smp790",
    "hazard_id": "hazard124",
    "control_measures": "Use protective gloves during operation.",
    "monitoring_status": "Resolved",
    "created_at": "2024-09-06T10:30:00Z",
    "updated_at": "2024-09-07T12:30:00Z",
  },
  // Add more entries as needed
];

class SafetyPlanScreen extends StatelessWidget {
  const SafetyPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Safety Management Plan (SMP)'),
      ),
      body: ListView.builder(
        itemCount: smpEntries.length,
        itemBuilder: (context, index) {
          final smp = smpEntries[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text('Hazard ID: ${smp['hazard_id']}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Control Measures: ${smp['control_measures']}'),
                  Text('Monitoring Status: ${smp['monitoring_status']}'),
                  Text('Last Updated: ${smp['updated_at']}'),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () {
                  _showSMPDetails(context, smp);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  // Function to display more details about the SMP in a dialog
  void _showSMPDetails(BuildContext context, Map<String, dynamic> smp) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('SMP Details: ${smp['hazard_id']}'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Hazard ID: ${smp['hazard_id']}'),
                Text('Control Measures: ${smp['control_measures']}'),
                Text('Monitoring Status: ${smp['monitoring_status']}'),
                Text('Created At: ${smp['created_at']}'),
                Text('Last Updated At: ${smp['updated_at']}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
