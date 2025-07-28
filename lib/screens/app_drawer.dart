import 'package:flutter/material.dart';
import 'package:kimjib/screens/transaction_screen.dart';
import 'settings_screen.dart';
import 'notification_center.dart';
import 'commission_screen.dart';
import 'dashboard_screen.dart';
import 'faqs_screen.dart';
import 'terms_and_conditions_screen.dart';

class AppDrawer extends StatelessWidget {
  final Function(int)? onSelectPage;

  const AppDrawer({super.key, this.onSelectPage});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Header
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.red),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Colors.red),
            ),
            accountName: const Text('Ahmed Siasa'),
            accountEmail: const Text('ahmed@humtech.co.tz'),
          ),

          // Main menu items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Dashboard'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=> DashboardScreen()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.policy),
                  title: const Text('Notifications Center'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=> NotificationCenterScreen()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SettingsScreen()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.work_outline),
                  title: const Text('Transaction'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TransactionScreen()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.badge_outlined),
                  title: const Text('Commission'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  CommissionPage()),
                    );
                  },
                ),
               /* ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Customers'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  CustomerPage()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.download),
                  title: const Text('Downloads'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  DownloadsPage()),
                    );
                  },
                ),*/
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('FAQS'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  FAQsPage()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.rule_outlined),
                  title: const Text('Terms and Conditions'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  TermsAndConditionsPage()),
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                ),
              ],
            ),
          ),

          // Footer
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: const [
                Divider(),
                Text(
                  '© 2025 Humtech ICT solution',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                SizedBox(height: 4),
                Text(
                  'App version 1.0.0',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
