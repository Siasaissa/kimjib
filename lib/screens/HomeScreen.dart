import 'package:flutter/material.dart';
import 'package:kimjib/screens/app_drawer.dart';
import 'dashboard_screen.dart';
import 'policies_screen.dart';
import 'claims_screen.dart';
import 'payments_screen.dart';
import 'profile_screen.dart';
import 'buy_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    DashboardScreen(),
    BuyInsuranceScreen(),
    ClaimsScreen(), // Replacing the FAB button action with this
    PaymentsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: AppDrawer(
        onSelectPage: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: _pages[_currentIndex],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF171C6E), // Only one colon
        onPressed: () {
          setState(() {
            _currentIndex = 2;
          });
        },
        child: const Icon(Icons.qr_code_scanner, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Colors.red,
        child: SizedBox(
          height: 25,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTabItem(icon: Icons.home_outlined, label: 'Home', index: 0),
              _buildTabItem(icon: Icons.sync, label: 'Services', index: 1),
              const SizedBox(width: 40), // space for the FAB
              _buildTabItem(icon: Icons.work_outline, label: 'Payments', index: 3),
              _buildTabItem(icon: Icons.person, label: 'Profile', index: 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem({required IconData icon, required String label, required int index}) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isSelected ? Color(0xFF171C6E) : Colors.white),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Color(0xFF171C6E) : Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
