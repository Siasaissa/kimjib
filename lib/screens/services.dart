import 'package:flutter/material.dart';
import 'app_drawer.dart';
import 'insurance_screen.dart';
import 'claims_screen.dart';
import 'products_screen.dart';
import 'reports_screen.dart';
import 'profoma_screen.dart';
import 'transaction_screen.dart';

class ServicePage extends StatelessWidget {
  const ServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Services', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.red,
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 16, // increased vertical spacing
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          childAspectRatio: 1 / 1.2,
          children: [
            _buildGridItem(context, Icons.shield_outlined, 'Insurance', const InsuranceScreen()),
            _buildGridItem(context, Icons.refresh, 'Claims', const ClaimsScreen()),
            _buildGridItem(context, Icons.move_to_inbox, 'Products', const ProductsPage()),
            _buildGridItem(context, Icons.article_sharp, 'Reports', const ReportPage()),
            _buildGridItem(context, Icons.description, 'Profoma', const ProfomaPage()),
            _buildGridItem(context, Icons.work_outline, 'Transaction', const TransactionScreen()),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(BuildContext context, IconData icon, String label, Widget destinationPage) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destinationPage),
        );
      },
      child: _dashboardCard(icon, label),
    );
  }

  static Widget _dashboardCard(IconData icon, String label) {
    final Color baseColor = Colors.red;
    return IntrinsicHeight(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: baseColor.withOpacity(0.3),
              blurRadius: 3,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: baseColor.withOpacity(0.1),
              ),
              child: Icon(
                icon,
                size: 36,
                color: baseColor,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              label,
              style: const TextStyle(fontSize: 15),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
