import 'package:flutter/material.dart';

void main() => runApp(const MainApp());

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          color: Colors.blueAccent,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 25),
        ),
      ),
      home: const SettingsPage(),
    );
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _darkMode = false;
  bool _notifications = true;
  bool _erpIntegration = false;
  final List<Map<String, String>> _profiles = [];
  final List<String> _feedbacks = [];
  final TextEditingController _profileNameController = TextEditingController();
  final TextEditingController _profileEmailController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();
  final TextEditingController _apiKeyController = TextEditingController();
  final TextEditingController _erpUrlController = TextEditingController();
  String? _selectedProfile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
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
            onTap: () {},
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
            onTap: () {},
          ),

          // User Settings Section
          _buildSectionTitle('User Settings'),
          _buildSettingTile(
            icon: Icons.person,
            title: 'Profile',
            subtitle: 'View and edit your profile',
            onTap: () => _showProfileDialog(),
          ),
          _buildSettingTile(
            icon: Icons.lock,
            title: 'Change Password',
            subtitle: 'Update your password',
            onTap: () => _showChangePasswordDialog(),
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
            onTap: () {},
          ),
          _buildSettingTile(
            icon: Icons.settings,
            title: 'ERP Configuration',
            subtitle: 'Access ERP integration configuration',
            onTap: () => _showErpIntegrationDialog(),
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
            onChanged: (value) {},
          ),
          _buildSettingTile(
            icon: Icons.feedback,
            title: 'Feedback',
            subtitle: 'Provide feedback on the app',
            onTap: () => _showFeedbackDialog(),
          ),
        ],
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

  void _showProfileDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Manage Profiles'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _profileNameController,
                decoration: const InputDecoration(labelText: 'Profile Name'),
              ),
              TextField(
                controller: _profileEmailController,
                decoration: const InputDecoration(labelText: 'Profile Email'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _profiles.add({
                      'name': _profileNameController.text,
                      'email': _profileEmailController.text,
                    });
                    _profileNameController.clear();
                    _profileEmailController.clear();
                  });
                  Navigator.pop(context);
                },
                child: const Text('Add Profile'),
              ),
              const SizedBox(height: 10),
              _profiles.isNotEmpty
                  ? Column(
                      children: _profiles.map((profile) {
                        return ListTile(
                          title: Text(profile['name'] ?? ''),
                          subtitle: Text(profile['email'] ?? ''),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  _profileNameController.text =
                                      profile['name']!;
                                  _profileEmailController.text =
                                      profile['email']!;
                                  _selectedProfile = profile['email'];
                                  Navigator.pop(context);
                                  _showProfileDialog();
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  setState(() {
                                    _profiles.remove(profile);
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    )
                  : const Text('No profiles available.'),
            ],
          ),
        );
      },
    );
  }

  void _showChangePasswordDialog() {
    final TextEditingController _accountController = TextEditingController();
    final TextEditingController _newPasswordController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _accountController,
                decoration: const InputDecoration(labelText: 'Account Email'),
              ),
              TextField(
                controller: _newPasswordController,
                decoration: const InputDecoration(labelText: 'New Password'),
                obscureText: true,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Add logic to change password for the specified account
                  final accountEmail = _accountController.text;
                  final newPassword = _newPasswordController.text;
                  // Assuming password change is successful
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Password changed for $accountEmail')),
                  );
                },
                child: const Text('Change Password'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showErpIntegrationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ERP Integration'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _apiKeyController,
                decoration: const InputDecoration(labelText: 'API Key'),
              ),
              TextField(
                controller: _erpUrlController,
                decoration: const InputDecoration(labelText: 'ERP URL'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Add logic to handle ERP integration settings
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('ERP settings saved successfully')),
                  );
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showFeedbackDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Feedback'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _feedbackController,
                decoration: const InputDecoration(labelText: 'Your Feedback'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _feedbacks.add(_feedbackController.text);
                    _feedbackController.clear();
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Feedback submitted successfully')),
                  );
                },
                child: const Text('Submit'),
              ),
              const SizedBox(height: 10),
              _feedbacks.isNotEmpty
                  ? Column(
                      children: _feedbacks.map((feedback) {
                        return ListTile(
                          title: Text(feedback),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                _feedbacks.remove(feedback);
                              });
                            },
                          ),
                        );
                      }).toList(),
                    )
                  : const Text('No feedback submitted yet.'),
            ],
          ),
        );
      },
    );
  }
}
