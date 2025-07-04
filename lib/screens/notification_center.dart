import 'package:flutter/material.dart';
import 'package:kimjib/screens/app_drawer.dart';

class NotificationCenterScreen extends StatelessWidget {
  const NotificationCenterScreen({super.key});

  final List<Map<String, String>> notifications = const [
    {
      'title': 'Payment Successful',
      'message': 'Your insurance payment of Tsh. 25,000 was received.',
      'time': 'Just now',
    },
    {
      'title': 'Policy Renewal Reminder',
      'message': 'Your Premium Plan expires in 3 days. Renew now!',
      'time': '2 hours ago',
    },
    {
      'title': 'New Insurance Offer',
      'message': 'Get 10% discount on Family Plan this month.',
      'time': 'Yesterday',
    },
    {
      'title': 'Auto-Pay Activated',
      'message': 'Auto-pay has been enabled for your next billing cycle.',
      'time': '3 days ago',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Center', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[800],
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon:  Icon(Icons.home),
            onPressed: (){
              Navigator.pushReplacementNamed(context, '/home');
            },

          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: notifications.isEmpty
          ? const Center(
        child: Text(
          'No notifications yet.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return _buildNotificationCard(notification);
        },
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, String> notification) {
    IconData icon;
    Color iconColor;

    // Dynamic icon based on title keyword
    if (notification['title']!.toLowerCase().contains('payment')) {
      icon = Icons.payment;
      iconColor = Colors.green;
    } else if (notification['title']!.toLowerCase().contains('reminder')) {
      icon = Icons.notifications_active;
      iconColor = Colors.orange;
    } else if (notification['title']!.toLowerCase().contains('offer')) {
      icon = Icons.local_offer;
      iconColor = Colors.purple;
    } else if (notification['title']!.toLowerCase().contains('auto-pay')) {
      icon = Icons.autorenew;
      iconColor = Colors.blue;
    } else {
      icon = Icons.notifications;
      iconColor = Colors.grey;
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.grey.shade100,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: iconColor.withOpacity(0.2),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(notification['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(notification['message']!),
        trailing: Text(notification['time']!, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        onTap: () {
          // navigate to detailed view of a specific notification
        },
      ),
    );
  }
}
