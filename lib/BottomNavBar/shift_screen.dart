import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shift Management App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ShiftScreen(),
    );
  }
}

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

  final _autoFormKey = GlobalKey<FormState>();
  int requiredOperators = 1;
  TimeOfDay? shiftDuration;
  DateTime startDate = DateTime.now();

  void _generateShifts(int operatorCount, TimeOfDay? duration) {
    if (duration == null || operatorCount <= 0) return;

    DateTime currentStartTime = startDate;
    int shiftCounter = shifts.length + 1;

    for (int i = 0; i < operatorCount; i++) {
      DateTime shiftEndTime = currentStartTime.add(
        Duration(hours: duration.hour, minutes: duration.minute),
      );

      shifts.add({
        'shift_id': 'shift${shiftCounter++}',
        'shift_start_time': currentStartTime.toString(),
        'shift_end_time': shiftEndTime.toString(),
        'shift_type': i % 2 == 0 ? 'Day' : 'Night',
        'operator_name': 'Auto Operator ${i + 1}',
        'status': 'Scheduled',
      });

      currentStartTime = shiftEndTime;
    }

    setState(() {}); // Update UI after generating shifts
  }

  void _showModifyShiftBottomSheet(Map<String, dynamic> shift) {
    final TextEditingController startTimeController =
        TextEditingController(text: shift['shift_start_time']);
    final TextEditingController endTimeController =
        TextEditingController(text: shift['shift_end_time']);
    final TextEditingController operatorNameController =
        TextEditingController(text: shift['operator_name']);

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: startTimeController,
                decoration: const InputDecoration(labelText: 'Start Time'),
              ),
              TextFormField(
                controller: endTimeController,
                decoration: const InputDecoration(labelText: 'End Time'),
              ),
              TextFormField(
                controller: operatorNameController,
                decoration: const InputDecoration(labelText: 'Operator Name'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        shift['shift_start_time'] = startTimeController.text;
                        shift['shift_end_time'] = endTimeController.text;
                        shift['operator_name'] = operatorNameController.text;
                      });
                      Navigator.of(context).pop(); // Close the bottom sheet
                    },
                    child: const Text('Save'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the bottom sheet
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEndShiftBottomSheet(Map<String, dynamic> shift) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Are you sure you want to end this shift?'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        shift['status'] = 'Ended';
                      });
                      Navigator.of(context).pop(); // Close the bottom sheet
                    },
                    child: const Text('Yes'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the bottom sheet
                    },
                    child: const Text('No'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAutoScheduleForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _autoFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(labelText: 'Operators Required'),
                  onChanged: (value) {
                    requiredOperators = int.tryParse(value) ?? 1;
                  },
                  validator: (value) {
                    final parsedValue = int.tryParse(value ?? '');
                    if (parsedValue == null || parsedValue <= 0) {
                      return 'Enter valid operator count';
                    }
                    return null;
                  },
                ),
                TextButton(
                  onPressed: () async {
                    shiftDuration = await showTimePicker(
                      context: context,
                      initialTime: const TimeOfDay(hour: 8, minute: 0),
                    );
                  },
                  child: const Text('Select Shift Duration'),
                ),
                TextButton(
                  onPressed: () async {
                    startDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2022),
                          lastDate: DateTime(2025),
                        ) ??
                        DateTime.now();
                  },
                  child: const Text('Select Start Date'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_autoFormKey.currentState?.validate() ?? false) {
                      _generateShifts(requiredOperators, shiftDuration);
                      Navigator.of(context).pop(); // Close the bottom sheet
                    }
                  },
                  child: const Text('Submit'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the bottom sheet
                  },
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddLogForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _autoFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                DropdownButtonFormField<String>(
                  value: 'Day',
                  items: const [
                    DropdownMenuItem(value: 'Day', child: Text('Day')),
                    DropdownMenuItem(value: 'Night', child: Text('Night')),
                  ],
                  onChanged: (value) {},
                  decoration: const InputDecoration(labelText: 'Shift Type'),
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Operator Name'),
                  onChanged: (value) {},
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Activities Log'),
                  maxLines: 2,
                  onChanged: (value) {},
                ),
                DropdownButtonFormField<String>(
                  value: 'Operational',
                  items: const [
                    DropdownMenuItem(
                        value: 'Operational', child: Text('Operational')),
                    DropdownMenuItem(
                        value: 'Under Maintenance',
                        child: Text('Under Maintenance')),
                  ],
                  onChanged: (value) {},
                  decoration:
                      const InputDecoration(labelText: 'Equipment Status'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the bottom sheet
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shift Management with Auto Scheduling'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                border: TableBorder.all(color: Colors.white),
                columns: const [
                  DataColumn(label: Text('Shift Type')),
                  DataColumn(label: Text('Start Time')),
                  DataColumn(label: Text('End Time')),
                  DataColumn(label: Text('Operator Name')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: shifts.map((shift) {
                  return DataRow(cells: [
                    DataCell(Text(shift['shift_type'] ?? '')),
                    DataCell(Text(shift['shift_start_time'] ?? '')),
                    DataCell(Text(shift['shift_end_time'] ?? '')),
                    DataCell(Text(shift['operator_name'] ?? '')),
                    DataCell(Text(shift['status'] ?? '')),
                    DataCell(Row(
                      children: [
                        TextButton(
                          onPressed: () => _showModifyShiftBottomSheet(shift),
                          child: const Text('Modify'),
                        ),
                        TextButton(
                          onPressed: () => _showEndShiftBottomSheet(shift),
                          child: const Text('End Shift'),
                        ),
                      ],
                    )),
                  ]);
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              _showAutoScheduleForm(context);
            },
            child: const Text('Auto Schedule Shifts'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddLogForm(context); // Use this to manually log shift activities
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
