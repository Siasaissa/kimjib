import 'package:flutter/material.dart';
import 'package:kimjib/screens/app_drawer.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[800],
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.home),
              onPressed: (){
                Navigator.pushReplacementNamed(context, '/home');
              }
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // Profile Picture Circle
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue[800],
              child: const Icon(Icons.person, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 15),

            const Text('Ahmed',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Text('Ahmed@humtech.co.tz',
                style: TextStyle(color: Colors.grey)),

            const SizedBox(height: 30),

            // User Info Cards
            _buildInfoCard(Icons.phone, 'Phone', '+255 712 345 678'),
            const SizedBox(height: 15),
            _buildInfoCard(Icons.location_on, 'Address', 'Dar es Salaam, Tanzania'),
            const SizedBox(height: 15),
            _buildInfoCard(Icons.calendar_today, 'Date of Birth', 'Jan 1, 1990'),

            const SizedBox(height: 30),
            // Action Buttons
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.edit),
                label: const Text('Edit Profile'),
                onPressed: () {
                  // TODO: Navigate to Edit Profile Screen
                },
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  side: BorderSide(color: Colors.red.shade300),
                ),
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text('Logout', style: TextStyle(color: Colors.red)),
                onPressed: () {
                  // TODO: Handle logout
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String title, String value) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      color: Colors.grey.shade100,
      child: ListTile(
        leading: Icon(icon, color: Colors.blue[800]),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value),
      ),
    );
  }
}
