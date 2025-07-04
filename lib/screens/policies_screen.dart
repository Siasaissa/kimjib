import 'package:flutter/material.dart';
import 'app_drawer.dart';

class PoliciesScreen extends StatelessWidget {
  const PoliciesScreen({super.key});

  final List<Map<String, String>> policies = const [
    {
      'type': 'Car Insurance',
      'policyNumber': 'CAR123456',
      'expiry': '2025-12-31',
      'sumInsured': 'TSh 10,000,000',
      'premium': 'TSh 500,000',
      'status': 'Active',
    },
    {
      'type': 'Health Insurance',
      'policyNumber': 'HLT789012',
      'expiry': '2024-11-15',
      'sumInsured': 'TSh 5,000,000',
      'premium': 'TSh 250,000',
      'status': 'Expired',
    },
    {
      'type': 'Motor Insurance',
      'policyNumber': 'M789012',
      'expiry': '2025-06-15',
      'sumInsured': 'TSh 50,000,000',
      'premium': 'TSh 250,000',
      'status': 'Active',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Policies', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[800],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const AppDrawer(),
      body: ListView.builder(
        itemCount: policies.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final policy = policies[index];
          final isActive = policy['status'] == 'Active';

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 6,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.policy, color: Colors.blue, size: 28),
                      const SizedBox(width: 10),
                      Text(
                        policy['type']!,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isActive ? Colors.green[100] : Colors.red[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          policy['status']!,
                          style: TextStyle(
                            color: isActive ? Colors.green[800] : Colors.red[800],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  _infoRow(Icons.confirmation_number, 'Policy No:', policy['policyNumber']),
                  _infoRow(Icons.calendar_today, 'Expiry:', policy['expiry']),
                  _infoRow(Icons.account_balance_wallet, 'Sum Insured:', policy['sumInsured']),
                  _infoRow(Icons.account_balance_wallet, 'Premium:', policy['premium']),

                  const SizedBox(height: 16),
                  if (!isActive)
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Handle renewal
                        },
                        icon: const Icon(Icons.refresh, size: 18,color: Colors.white,),
                        label: const Text('Renew',
                        style: TextStyle(color: Colors.white),),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[700],
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey[700]),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              value ?? '',
              style: const TextStyle(color: Colors.black87),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
