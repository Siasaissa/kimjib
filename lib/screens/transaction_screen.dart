import 'package:flutter/material.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Page'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _activityTile(
              icon: Icons.work_outline,
              title: 'Motor',
              status: 'Third Party',
              amount: 'TZS 700,000',
              dueDate: '20 July 2025',
              color: Colors.red,
              background: Colors.amber,
            ),
            _activityTile(
              icon: Icons.work_outline,
              title: 'Motor',
              status: 'Comprehensive',
              amount: 'TZS 700,000',
              dueDate: '20 July 2025',
              color: Colors.red,
              background: Colors.amber,
            ),
          ],
        ),
      ),
    );
  }
}

Widget _activityTile({
  required IconData icon,
  required String title,
  required String status,
  required String amount,
  required String dueDate,
  required Color color,
  required Color background,
}) {
  return Card(
    color: Colors.grey.shade100,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.1),
        child: Icon(icon, color: color),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w600),
              ),
              Text(
                status,
                style: const TextStyle(fontSize: 6, color: Colors.black, fontWeight: FontWeight.w500),
              )
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                amount,
                style: const TextStyle(fontSize: 6, color: Colors.black, fontWeight: FontWeight.w500),
              ),
              Text(
                dueDate,
                style: const TextStyle(
                  fontSize: 6,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
      onTap: () {},
    ),
  );
}
