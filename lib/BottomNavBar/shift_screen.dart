import 'package:flutter/material.dart';

class ShiftScreen extends StatefulWidget {
  const ShiftScreen({super.key});

  @override
  State<ShiftScreen> createState() => _ShiftScreenState();
}

class _ShiftScreenState extends State<ShiftScreen> {
  List<Map<String, dynamic>> shifts = [
    {
      'shift_id': 'shift123',
      'shift_start_time': '2024-09-05 09:00',
      'shift_end_time': '2024-09-05 17:00',
      'shift_type': 'Day',
      'operator_name': 'John Doe',
      'status': 'Ongoing',
    },
    {
      'shift_id': 'shift124',
      'shift_start_time': '2024-09-05 17:00',
      'shift_end_time': '2024-09-06 01:00',
      'shift_type': 'Night',
      'operator_name': 'Jane Smith',
      'status': 'Upcoming',
    },
  ];

  // For logging the new shift activities
  final _formKey = GlobalKey<FormState>();
  String shiftType = 'Day';
  String operatorName = '';
  String activitiesLog = '';
  String equipmentStatus = 'Operational';
  String safetyIssues = '';
  String nextShiftTasks = '';
  DateTime? startTime;
  DateTime? endTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shift Handover Review'),
      ),
      body: Column(
        children: [
          // Card to contain the shift data table
          Card(
            margin: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              scrollDirection:
                  Axis.horizontal, // Make it scrollable horizontally
              child: DataTable(
                border: TableBorder.all(color: Colors.white),
                columns: const [
                  DataColumn(label: Text('Shift Type')),
                  DataColumn(label: Text('Start Time')),
                  DataColumn(label: Text('End Time')),
                  DataColumn(label: Text('Operator Name')),
                  DataColumn(label: Text('Status')),
                ],
                rows: shifts.map((shift) {
                  return DataRow(cells: [
                    DataCell(Text(shift['shift_type'])),
                    DataCell(Text(shift['shift_start_time'])),
                    DataCell(Text(shift['shift_end_time'])),
                    DataCell(Text(shift['operator_name'])),
                    DataCell(Text(shift['status'])),
                  ]);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddLogForm(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // Function to show the form for adding a new log
  void _showAddLogForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Log New Shift Activities'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  // Shift Type Dropdown
                  DropdownButtonFormField<String>(
                    value: shiftType,
                    items: const [
                      DropdownMenuItem(value: 'Day', child: Text('Day')),
                      DropdownMenuItem(value: 'Night', child: Text('Night')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        shiftType = value!;
                      });
                    },
                    decoration: const InputDecoration(labelText: 'Shift Type'),
                  ),
                  // Operator Name Field
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Operator Name'),
                    onChanged: (value) {
                      operatorName = value;
                    },
                    validator: (value) =>
                        value!.isEmpty ? 'Enter operator name' : null,
                  ),
                  // Activities Log Field
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Activities Log'),
                    maxLines: 2,
                    onChanged: (value) {
                      activitiesLog = value;
                    },
                    validator: (value) =>
                        value!.isEmpty ? 'Enter activities' : null,
                  ),
                  // Equipment Status Dropdown
                  DropdownButtonFormField<String>(
                    value: equipmentStatus,
                    items: const [
                      DropdownMenuItem(
                          value: 'Operational', child: Text('Operational')),
                      DropdownMenuItem(
                          value: 'Under Maintenance',
                          child: Text('Under Maintenance')),
                      DropdownMenuItem(
                          value: 'Needs Repair', child: Text('Needs Repair')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        equipmentStatus = value!;
                      });
                    },
                    decoration:
                        const InputDecoration(labelText: 'Equipment Status'),
                  ),
                  // Safety Issues Field
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Safety Issues'),
                    maxLines: 2,
                    onChanged: (value) {
                      safetyIssues = value;
                    },
                  ),
                  // Next Shift Tasks Field
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Next Shift Tasks'),
                    maxLines: 2,
                    onChanged: (value) {
                      nextShiftTasks = value;
                    },
                  ),
                  // Shift Start Time Picker
                  TextButton(
                    onPressed: () async {
                      startTime = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2022),
                        lastDate: DateTime(2025),
                      );
                    },
                    child: const Text('Select Start Time'),
                  ),
                  // Shift End Time Picker
                  TextButton(
                    onPressed: () async {
                      endTime = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2022),
                        lastDate: DateTime(2025),
                      );
                    },
                    child: const Text('Select End Time'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Perform save operation here, like updating the database
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Submit'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
