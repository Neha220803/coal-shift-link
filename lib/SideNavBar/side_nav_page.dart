import 'package:flutter/material.dart';
import 'package:shift_link/SideNavBar/pdf_report_screen.dart'; // Import the PDFReportScreen
import 'package:shift_link/SideNavBar/report_hazard.dart';
import 'package:shift_link/SideNavBar/setting.dart'; // Import the SettingsPage

class SideNavPage extends StatefulWidget {
  const SideNavPage({super.key});

  @override
  State<SideNavPage> createState() => _SideNavPageState();
}

class _SideNavPageState extends State<SideNavPage> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(child: Center(child: Text("Shift Link"))),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text(
              "Dashboard",
              style: TextStyle(color: Colors.white),
            ),
            tileColor: Colors.blue[100],
            onTap: () {
              // Navigate to Dashboard
            },
          ),
          ListTile(
            leading: const Icon(Icons.report),
            title: const Text(
              "Report Hazard",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ReportNewHazard(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.picture_as_pdf),
            title: const Text(
              "PDF Report",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PDFReportScreen(
                    completedWork: 120, // Pass your actual data here
                    pendingWork: 80,    // Pass your actual data here
                    danger: true,       // Pass your actual data here
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text(
              "Settings",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(), // Navigate to SettingsPage
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.headphones_outlined),
            title: const Text(
              "Help & Support",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              // Navigate to Help & Support
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text(
              "Log Out",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              // Handle Log Out
            },
          ),
        ],
      ),
    );
  }
}
