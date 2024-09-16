import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _darkMode = false;
  bool _notifications = true;
  bool _erpIntegration = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        color: Colors.black,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // General Settings Section
            _buildSectionTitle('General Settings'),
            _buildSettingTile(
              icon: Icons.brightness_6,
              title: 'Dark Mode',
              subtitle: 'Enable or disable dark mode',
              value: _darkMode,
              onChanged: (value) {
                setState(() {
                  _darkMode = value;
                });
              },
              onTap: () {}, // Provide a default function for onTap
            ),
            _buildSettingTile(
              icon: Icons.notifications,
              title: 'Notifications',
              subtitle: 'Enable or disable notifications',
              value: _notifications,
              onChanged: (value) {
                setState(() {
                  _notifications = value;
                });
              },
              onTap: () {}, // Provide a default function for onTap
            ),

            // User Settings Section
            _buildSectionTitle('User Settings'),
            _buildSettingTile(
              icon: Icons.person,
              title: 'Profile',
              subtitle: 'View and edit your profile',
              onTap: () {
                // Navigate to profile page
              },
              onChanged: (value) {}, // Provide a default function for onChanged
            ),
            _buildSettingTile(
              icon: Icons.lock,
              title: 'Change Password',
              subtitle: 'Update your password',
              onTap: () {
                // Navigate to change password page
              },
              onChanged: (value) {}, // Provide a default function for onChanged
            ),

            // ERP Integration Section
            _buildSectionTitle('ERP Integration'),
            _buildSettingTile(
              icon: Icons.sync,
              title: 'ERP Integration',
              subtitle: 'Configure ERP integration settings',
              value: _erpIntegration,
              onChanged: (value) {
                setState(() {
                  _erpIntegration = value;
                });
              },
              onTap: () {}, // Provide a default function for onTap
            ),
            _buildSettingTile(
              icon: Icons.settings,
              title: 'ERP Configuration',
              subtitle: 'Access ERP integration configuration',
              onTap: () {
                // Navigate to ERP configuration page
              },
              onChanged: (value) {}, // Provide a default function for onChanged
            ),

            // Support Section
            _buildSectionTitle('Support'),
            _buildSettingTile(
              icon: Icons.help_outline,
              title: 'Help & Support',
              subtitle: 'Get help with using the app',
              onTap: () {
                // Navigate to help & support page
              },
              onChanged: (value) {}, // Provide a default function for onChanged
            ),
            _buildSettingTile(
              icon: Icons.feedback,
              title: 'Feedback',
              subtitle: 'Provide feedback on the app',
              onTap: () {
                // Navigate to feedback page
              },
              onChanged: (value) {}, // Provide a default function for onChanged
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.blueAccent,
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    String? subtitle,
    bool? value,
    required VoidCallback onTap,
    ValueChanged<bool>? onChanged,
  }) {
    return Card(
      color: Colors.grey.shade900,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.blueAccent,
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        subtitle: subtitle != null
            ? Text(subtitle, style: const TextStyle(color: Colors.grey))
            : null,
        trailing: value != null
            ? Switch(
                value: value,
                onChanged: onChanged,
                activeColor: Colors.blueAccent,
              )
            : null,
        onTap: onTap,
      ),
    );
  }
}
