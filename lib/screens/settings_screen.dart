import 'package:flutter/material.dart';
import 'package:kimjib/screens/app_drawer.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsOn = false; // toggle state for notification

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
            icon: const Icon(Icons.home, color: Colors.white),
          )
        ],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _profileCard(),
            const SizedBox(height: 24),
            const Text(
              'Account Settings',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            _settingsTile(Icons.lock_outline, 'Change Password', () {}),
            _NotificationTile(
              icon: Icons.notifications,
              title: 'Notification Settings',
              isChecked: _notificationsOn,
              onTap: () {
                setState(() {
                  _notificationsOn = !_notificationsOn;
                });
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'App Preferences',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            _settingsTile(Icons.language, 'Language', () {
              _showLanguageDialog(context);
            }),
            _settingsTile(Icons.info_outline, 'About Kimjib', () {
              _showaboutDialog(context);
            }),
            _settingsTile(Icons.help_outline, 'Help & Support', () {
              _showHelpDialog(context);
            }),
            const SizedBox(height: 24),
            const Divider(),
            _settingsTile(Icons.logout, 'Logout', () {
              Navigator.pushReplacementNamed(context, '/login');
            }, color: Colors.redAccent),
          ],
        ),
      ),
    );
  }
  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('English'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('Swahili'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              // Add more languages if needed
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        );
      },
    );
  }
  void _showaboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('About Kimjib'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('this is the insurance company that come up to '
                  'support hustler by let them not to start over once they loose their property'
                  'Hence they take a coverage of lost happened like that of house,car and even Health of themselves or their relatives'
                  'that are known by insurance ')
              // Add more languages if needed
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        );
      },
    );
  }
  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Call us Through'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('+255 613 803 662',
              style: TextStyle(fontSize: 15, color: Colors.blue[800],fontWeight: FontWeight.bold),)
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        );
      },
    );
  }


  Widget _profileCard() {
    return Card(
      elevation: 3,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.red, width: 3),
              ),
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: Colors.red),
              ),
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Ahmed',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 1),
                Text(
                  'ahmed@humtech.co.tz',
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 1),
                Text(
                  '0713803662',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _settingsTile(IconData icon, String title, VoidCallback onTap, {Color color = Colors.blue}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: color == Colors.redAccent ? Colors.redAccent : Colors.black87,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.red),
        onTap: onTap,
      ),
    );
  }

  Widget _NotificationTile({
    required IconData icon,
    required String title,
    required bool isChecked,
    required VoidCallback onTap,
    Color color = Colors.blue,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: color == Colors.redAccent ? Colors.redAccent : Colors.black87,
          ),
        ),
        trailing: Icon(
          isChecked ? Icons.radio_button_checked : Icons.radio_button_unchecked,
          color: Colors.red,
        ),
        onTap: onTap,
      ),
    );
  }
}
