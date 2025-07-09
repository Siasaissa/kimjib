import 'package:flutter/material.dart';

class DownloadsPage extends StatelessWidget {
  final List<Map<String, dynamic>> downloads = [
    {
      'title': 'Policy Document',
      'subtitle': 'Auto Insurance • Jan 2024',
      'date': '01 Jan 2024',
      'icon': Icons.picture_as_pdf,
    },
    {
      'title': 'Receipt',
      'subtitle': 'Payment Receipt • Dec 2023',
      'date': '31 Dec 2023',
      'icon': Icons.receipt_long,
    },
    {
      'title': 'Claim Form',
      'subtitle': 'Home Insurance • Claim Form',
      'date': '20 Nov 2023',
      'icon': Icons.description,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Downloads', style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.separated(
          itemCount: downloads.length,
          separatorBuilder: (_, __) => Divider(color: Colors.grey[300]),
          itemBuilder: (context, index) {
            final file = downloads[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.red.withOpacity(0.1),
                child: Icon(file['icon'], color: Colors.red),
              ),
              title: Text(file['title'], style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(file['subtitle']),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(file['date'], style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                  SizedBox(height: 4),
                  Icon(Icons.download, size: 18, color: Colors.grey[700]),
                ],
              ),
              onTap: () {
                // Handle file download/view
              },
            );
          },
        ),
      ),
    );
  }
}
