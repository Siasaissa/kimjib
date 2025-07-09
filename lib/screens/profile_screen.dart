import 'package:flutter/material.dart';
import 'package:kimjib/screens/app_drawer.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
        iconTheme: const IconThemeData(color: Colors.white),
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
              backgroundColor: Colors.red.shade50,
              child: const Icon(Icons.person_outline, size: 60, color: Colors.red),
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
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.edit),
                label: const Text('Edit Profile'),
                onPressed: () {
                  // Temporary controllers for demonstration
                  TextEditingController nameController = TextEditingController(text: 'Ahmed');
                  TextEditingController emailController = TextEditingController(text: 'Ahmed@humtech.co.tz');
                  TextEditingController phoneController = TextEditingController(text: '+255 712 345 678');
                  TextEditingController addressController = TextEditingController(text: 'Dar es Salaam, Tanzania');
                  TextEditingController dateController = TextEditingController(text: 'Jan 1, 1990');


                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Edit Profile'),
                        content: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: nameController,
                                decoration: const InputDecoration(
                                  labelText: 'Name',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: emailController,
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: phoneController,
                                decoration:  const InputDecoration(
                                  labelText: 'Phone',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: addressController,
                                decoration: const InputDecoration(
                                  labelText: 'Address',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: dateController,
                                decoration: const InputDecoration(
                                  labelText: 'Date of Birth'
                                ),
                              )
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Save'),
                            onPressed: () {
                              String newName = nameController.text;
                              String newEmail = emailController.text;
                              String newPhone = phoneController.text;
                              String newAddress = addressController.text;
                              String newdate = dateController.text;

                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
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
                  Navigator.pushReplacementNamed(context, '/login');
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
        leading: CircleAvatar(
          backgroundColor: Colors.red.withOpacity(0.1), // light red background
          radius: 20, // size of the circle
          child: Icon(
            icon,
            color: Colors.red,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(value),
      ),
    );
  }
}
