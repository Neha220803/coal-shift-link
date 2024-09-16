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

  // Automatic shift scheduling form
  final _autoFormKey = GlobalKey<FormState>();
  int requiredOperators = 1;
  TimeOfDay? shiftDuration;
  DateTime startDate = DateTime.now();

  // Function to generate shifts automatically
  void _generateShifts(int operatorCount, TimeOfDay? duration) {
    if (duration == null) return;

    // Shift scheduling logic based on duration and operator count
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
        'operator_name': 'Auto Operator $i',
        'status': 'Scheduled',
      });

      // Update currentStartTime for the next shift
      currentStartTime = shiftEndTime;
    }

    setState(() {}); // Update UI after generating shifts
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shift Management with Auto Scheduling'),
      ),
      body: Column(
        children: [
          // Shift Data Table
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
          const SizedBox(height: 10),
          // Button to show form for automatic scheduling
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

  // Function to show the automatic shift scheduling form
  void _showAutoScheduleForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Auto Schedule Shifts'),
          content: Form(
            key: _autoFormKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  // Number of operators input
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration:
                        const InputDecoration(labelText: 'Operators Required'),
                    onChanged: (value) {
                      requiredOperators = int.parse(value);
                    },
                    validator: (value) =>
                        value!.isEmpty || int.parse(value) <= 0
                            ? 'Enter valid operator count'
                            : null,
                  ),
                  // Shift Duration Picker
                  TextButton(
                    onPressed: () async {
                      shiftDuration = await showTimePicker(
                        context: context,
                        initialTime: const TimeOfDay(hour: 8, minute: 0),
                      );
                    },
                    child: const Text('Select Shift Duration'),
                  ),
                  // Start Date Picker
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
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_autoFormKey.currentState!.validate()) {
                  // Generate shifts automatically
                  _generateShifts(requiredOperators, shiftDuration);
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

  // Function to show the form for logging new shift activities
  void _showAddLogForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Log New Shift Activities'),
          content: Form(
            key: _autoFormKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  // Shift Type Dropdown
                  DropdownButtonFormField<String>(
                    value: 'Day',
                    items: const [
                      DropdownMenuItem(value: 'Day', child: Text('Day')),
                      DropdownMenuItem(value: 'Night', child: Text('Night')),
                    ],
                    onChanged: (value) {},
                    decoration: const InputDecoration(labelText: 'Shift Type'),
                  ),
                  // Operator Name Field
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Operator Name'),
                    onChanged: (value) {},
                  ),
                  // Activities Log Field
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Activities Log'),
                    maxLines: 2,
                    onChanged: (value) {},
                  ),
                  // Equipment Status Dropdown
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
                ],
              ),
            ),
          ),
          actions: [
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
