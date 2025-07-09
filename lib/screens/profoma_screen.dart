import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProformaPage extends StatelessWidget {
  final NumberFormat currencyFormat = NumberFormat.currency(symbol: 'Tzs. ');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Proforma Invoice'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Customer Details'),
              _buildDetailRow('Name:', 'Ahmed Siasa'),
              _buildDetailRow('Phone:', '+255 712 345 678'),
              _buildDetailRow('Email:', 'ahmed@example.com'),
              const SizedBox(height: 24),

              _buildSectionTitle('Insurance Product'),
              _buildDetailRow('Type:', 'Auto Insurance'),
              _buildDetailRow('Coverage:', 'Comprehensive'),
              _buildDetailRow('Period:', '1 Year'),
              _buildDetailRow('Start Date:', 'July 10, 2025'),
              const SizedBox(height: 24),

              _buildSectionTitle('Premium Breakdown'),
              _buildDetailRow('Base Premium:', currencyFormat.format(850_000)),
              _buildDetailRow('Stamp Duty:', currencyFormat.format(10_000)),
              _buildDetailRow('Training Levy:', currencyFormat.format(7_500)),
              _buildDetailRow('VAT (18%):', currencyFormat.format(153_000)),
              const Divider(thickness: 1),
              _buildDetailRow('Total Premium:', currencyFormat.format(1_020_500), isBold: true, color: Colors.red),
              const SizedBox(height: 32),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.download,color: Colors.white,),
                    label: const Text('Download',style: TextStyle(color: Colors.white,),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.share, color: Colors.red),
                    label: const Text('Share', style: TextStyle(color: Colors.red)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
    ),
  );

  Widget _buildDetailRow(String label, String value, {bool isBold = false, Color? color}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Expanded(flex: 3, child: Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[700]))),
        Expanded(
          flex: 5,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: color ?? Colors.black,
            ),
          ),
        ),
      ],
    ),
  );
}
