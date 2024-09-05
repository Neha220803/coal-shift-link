import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // Dummy data for alerts and notifications
  final List<Map<String, dynamic>> alerts = [
    {
      'alert_id': 'alert1',
      'type': 'Safety',
      'message': 'Critical safety issue detected',
      'priority': 'High',
      'status': 'Unresolved',
    },
    {
      'alert_id': 'alert2',
      'type': 'Equipment',
      'message': 'Equipment malfunction',
      'priority': 'Medium',
      'status': 'Unresolved',
    },
  ];

  final List<Map<String, dynamic>> notifications = [
    {
      'notification_id': 'notif1',
      'message': 'Upcoming shift change for Day Shift',
      'status': 'Unread',
      'created_at': '2024-09-05T09:00:00Z',
    },
    {
      'notification_id': 'notif2',
      'message': 'Safety Management Plan review scheduled',
      'status': 'Unread',
      'created_at': '2024-09-05T09:30:00Z',
    },
  ];

  // Function to mark alert as acknowledged
  void acknowledgeAlert(int index) {
    setState(() {
      alerts[index]['status'] = 'Acknowledged';
    });
  }

  // Function to resolve an alert
  void resolveAlert(int index) {
    setState(() {
      alerts[index]['status'] = 'Resolved';
    });
  }

  // Function to mark notification as read
  void markNotificationAsRead(int index) {
    setState(() {
      notifications[index]['status'] = 'Read';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Alerts and Notifications"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Alerts Section
            const Text(
              "Alerts",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              itemCount: alerts.length,
              itemBuilder: (context, index) {
                final alert = alerts[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(
                      "${alert['type']} Alert: ${alert['message']}",
                      style: TextStyle(
                        color: alert['priority'] == 'High'
                            ? Colors.red
                            : Colors.orange,
                      ),
                    ),
                    subtitle: Text("Priority: ${alert['priority']}"),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'Acknowledge') {
                          acknowledgeAlert(index);
                        } else if (value == 'Resolve') {
                          resolveAlert(index);
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        const PopupMenuItem(
                          value: 'Acknowledge',
                          child: Text('Acknowledge'),
                        ),
                        const PopupMenuItem(
                          value: 'Resolve',
                          child: Text('Resolve'),
                        ),
                      ],
                    ),
                    leading: Icon(
                      alert['status'] == 'Acknowledged'
                          ? Icons.check
                          : Icons.warning_amber_outlined,
                      color: alert['status'] == 'Acknowledged'
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            // Notifications Section
            const Text(
              "Notifications",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(notification['message']),
                    subtitle: Text("Status: ${notification['status']}"),
                    trailing: IconButton(
                      icon: Icon(
                        notification['status'] == 'Unread'
                            ? Icons.mark_email_unread
                            : Icons.mark_email_read,
                        color: notification['status'] == 'Unread'
                            ? Colors.blue
                            : Colors.green,
                      ),
                      onPressed: () => markNotificationAsRead(index),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
