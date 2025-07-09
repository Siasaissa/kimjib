import 'package:flutter/material.dart';

class ProductsPage extends StatelessWidget {
  final List<Map<String, dynamic>> products = [
    {
      'name': 'Auto Insurance',
      'category': 'Vehicle',
      'description': 'Covers accidents, theft, and damages for your car.',
      'icon': Icons.directions_car,
    },
    {
      'name': 'Home Insurance',
      'category': 'Property',
      'description': 'Protects your home against fire, theft, and disasters.',
      'icon': Icons.home,
    },
    {
      'name': 'Health Insurance',
      'category': 'Medical',
      'description': 'Covers hospital visits, medications, and more.',
      'icon': Icons.local_hospital,
    },
    {
      'name': 'Life Insurance',
      'category': 'Life',
      'description': 'Provides financial support for your loved ones.',
      'icon': Icons.favorite,
    },
    {
      'name': 'Travel Insurance',
      'category': 'Travel',
      'description': 'Covers trip cancellations, medical emergencies abroad.',
      'icon': Icons.flight,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Insurance Products', style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(product['icon'], size: 28, color: Colors.red),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(product['name'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text(product['category'], style: TextStyle(color: Colors.grey[600])),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(product['description'], style: TextStyle(fontSize: 14)),
                  SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        // You can link to a detail page or quote form
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                      child: Text('Get Quote'),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}