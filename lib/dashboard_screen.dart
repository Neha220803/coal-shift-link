import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart'; // Import for Pie Charts
import 'package:shift_link/utils/responsive.dart';
import 'package:shift_link/utils/constants.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shift Summary & Upcoming Shifts
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      ShiftSummary(),
                      const SizedBox(height: defaultPadding),
                      UpcomingShifts(),
                      const SizedBox(height: defaultPadding),
                      PendingSafetyIssues(),
                      const SizedBox(height: defaultPadding),
                      CriticalAlerts(),
                    ],
                  ),
                ),
                if (!Responsive.isMobile(context))
                  const SizedBox(width: defaultPadding),
                // Optional performance metrics for non-mobile screens
                if (!Responsive.isMobile(context))
                  Expanded(flex: 2, child: PerformanceMetrics()),
              ],
            ),
            const SizedBox(height: defaultPadding),

            // Quick Access Section
            // QuickAccess(),
          ],
        ),
      ),
    );
  }
}

class ShiftSummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Shift Summary",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // Add a SingleChildScrollView to make it responsive on mobile
            SingleChildScrollView(
              scrollDirection: Axis.horizontal, // Enable horizontal scrolling
              child: SizedBox(
                width:
                    MediaQuery.of(context).size.width, // Full width on mobile
                child: DataTable(
                  columns: const <DataColumn>[
                    DataColumn(label: Text('Task')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Flagged Issues')),
                  ],
                  rows: const <DataRow>[
                    DataRow(cells: [
                      DataCell(Text('Task 1')),
                      DataCell(Text('Ongoing')),
                      DataCell(Text('No')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Task 2')),
                      DataCell(Text('Completed')),
                      DataCell(Text('Yes')),
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UpcomingShifts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Upcoming Shifts",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // Add a SingleChildScrollView to handle overflow on smaller screens
            SingleChildScrollView(
              scrollDirection: Axis.horizontal, // Enable horizontal scrolling
              child: SizedBox(
                width:
                    MediaQuery.of(context).size.width, // Full width on mobile
                child: DataTable(
                  columns: const <DataColumn>[
                    DataColumn(label: Text('Shift')),
                    DataColumn(label: Text('Assigned To')),
                    DataColumn(label: Text('Major Tasks')),
                  ],
                  rows: const <DataRow>[
                    DataRow(cells: [
                      DataCell(Text('Morning Shift')),
                      DataCell(Text('John, Sarah')),
                      DataCell(Text('Task A, Task B')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Afternoon Shift')),
                      DataCell(Text('Mike, Lucy')),
                      DataCell(Text('Task C, Task D')),
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget for Pending Safety Issues with Pie Chart
class PendingSafetyIssues extends StatelessWidget {
  final Map<String, double> dataMap = {
    "Resolved": 70,
    "Unresolved": 30,
  };

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Pending Safety Issues",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            PieChart(
              dataMap: dataMap,
              chartType: ChartType.ring,
              baseChartColor: Colors.grey[300]!,
              colorList: const [Colors.green, Colors.red],
              chartRadius: MediaQuery.of(context).size.width / 3,
              legendOptions: const LegendOptions(
                showLegends: true,
                legendPosition: LegendPosition.right,
              ),
              chartValuesOptions: const ChartValuesOptions(
                showChartValuesInPercentage: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget for Critical Alerts with Pie Chart
class CriticalAlerts extends StatelessWidget {
  final Map<String, double> dataMap = {
    "Critical": 10,
    "Non-Critical": 90,
  };

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Critical Alerts",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            PieChart(
              dataMap: dataMap,
              chartType: ChartType.ring,
              baseChartColor: Colors.grey[300]!,
              colorList: const [Colors.red, Colors.orange],
              chartRadius: MediaQuery.of(context).size.width / 3,
              legendOptions: const LegendOptions(
                showLegends: true,
                legendPosition: LegendPosition.right,
              ),
              chartValuesOptions: const ChartValuesOptions(
                showChartValuesInPercentage: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget for Performance Metrics (Optional)
class PerformanceMetrics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Performance Metrics",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text("Graphical representation of productivity."),
            SizedBox(height: 8),
            // Add charts or graphs here
          ],
        ),
      ),
    );
  }
}

// Widget for Quick Access buttons
class QuickAccess extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.list_alt),
              label: const Text("Shift Logs"),
              onPressed: () {
                // Navigate to Shift Logs
              },
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.security),
              label: const Text("SMP Status"),
              onPressed: () {
                // Navigate to SMP Status
              },
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.report),
              label: const Text("Hazard Reports"),
              onPressed: () {
                // Navigate to Hazard Reports
              },
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.warning_amber),
              label: const Text("Alerts"),
              onPressed: () {
                // Navigate to Alerts
              },
            ),
          ],
        ),
      ),
    );
  }
}
