import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:kimjib/screens/app_drawer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? nidaFilePath;
  String? licenseFilePath;
  String? tinFilePath;

  Future<void> pickFile(String docType) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png'],
    );

    if (result != null && result.files.single.path != null) {
      final path = result.files.single.path!;
      final fileName = result.files.single.name;

      setState(() {
        if (docType == 'NIDA') {
          nidaFilePath = path;
        } else if (docType == 'License') {
          licenseFilePath = path;
        } else if (docType == 'TIN') {
          tinFilePath = path;
        }
      });

      print('Selected $docType file: $fileName');
    }
  }

  void _previewFile(String filePath) async {
    final result = await OpenFile.open(filePath);

    if (result.type != ResultType.done) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not open file: ${result.message}")),
      );
    }
  }

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
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.red.shade50,
              child: const Icon(Icons.person_outline, size: 60, color: Colors.red),
            ),
            const SizedBox(height: 15),
            const Text('Ahmed', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Text('Ahmed@humtech.co.tz', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 30),

            _buildInfoCard(Icons.phone, 'Phone', '+255 712 345 678'),
            const SizedBox(height: 15),
            _buildInfoCard(Icons.location_on, 'Address', 'Dar es Salaam, Tanzania'),
            const SizedBox(height: 15),
            _buildInfoCard(Icons.person_2, 'Next Kin', 'Brother, +255 613 803 662'),
            const SizedBox(height: 15),
            _buildInfoCard(Icons.calendar_today, 'Date of Birth', 'Jan 1, 1990'),
            const SizedBox(height: 30),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'My Documents',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey),
              ),
            ),
            const SizedBox(height: 10),

            _buildKycCard(
              icon: Icons.badge,
              title: 'NIDA Document',
              filePath: nidaFilePath,
              onUpload: () => pickFile('NIDA'),
              onPreview: () => _previewFile(nidaFilePath!),
            ),
            const SizedBox(height: 10),
            _buildKycCard(
              icon: Icons.card_membership,
              title: 'License Document',
              filePath: licenseFilePath,
              onUpload: () => pickFile('License'),
              onPreview: () => _previewFile(licenseFilePath!),
            ),
            const SizedBox(height: 10),
            _buildKycCard(
              icon: Icons.numbers,
              title: 'TIN Document',
              filePath: tinFilePath,
              onUpload: () => pickFile('TIN'),
              onPreview: () => _previewFile(tinFilePath!),
            ),

            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                icon: const Icon(Icons.edit, size: 20),
                label: const Text('Edit Profile'),
                onPressed: () {
                  // Temporary controllers for demonstration
                  TextEditingController nameController = TextEditingController(text: 'Ahmed');
                  TextEditingController emailController = TextEditingController(text: 'Ahmed@humtech.co.tz');
                  TextEditingController phoneController = TextEditingController(text: '+255 712 345 678');
                  TextEditingController addressController = TextEditingController(text: 'Dar es Salaam, Tanzania');
                  TextEditingController kinController = TextEditingController(text: 'Brother, +255 613 803 662');
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
                                controller: kinController,
                                decoration: const InputDecoration(
                                  labelText: 'Next Kin',
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  side: BorderSide(color: Colors.red.shade300),
                ),
                icon: const Icon(Icons.logout, color: Colors.red, size: 20),
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
          backgroundColor: Colors.red.withOpacity(0.1),
          radius: 20,
          child: Icon(icon, color: Colors.red, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value),
      ),
    );
  }

  Widget _buildKycCard({
    required IconData icon,
    required String title,
    required String? filePath,
    required VoidCallback onUpload,
    required VoidCallback onPreview,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.grey.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.red.withOpacity(0.1),
                  radius: 20,
                  child: Icon(icon, color: Colors.red, size: 20),
                ),
                const SizedBox(width: 10),
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: onUpload,
                  icon: const Icon(Icons.upload_file, size: 20),
                  label: const Text("Upload"),
                ),
                const SizedBox(width: 8),
                if (filePath != null)
                  OutlinedButton.icon(
                    onPressed: onPreview,
                    icon: const Icon(Icons.remove_red_eye, size: 20),
                    label: const Text("Preview"),
                  ),
              ],
            ),
            if (filePath != null)
              Padding(
                padding: const EdgeInsets.only(top: 4, left: 8),
                child: Text(
                  'Selected: ${filePath.split('/').last}',
                  style: const TextStyle(fontSize: 12, color: Colors.green),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
