import 'package:flutter/material.dart';
import 'app_drawer.dart';
import 'HomeScreen.dart';
import 'package:carousel_slider/carousel_slider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final List<String> imgList = [
    'assets/banner1.jpg',
    'assets/banner2.jpg',
    'assets/banner3.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.red,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Dashboard',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            padding: const EdgeInsets.all(5),
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          Stack(
            children: [
              IconButton(
                padding: const EdgeInsets.all(5),
                icon: const Icon(Icons.notifications),
                onPressed: () {
                  // Handle notification icon press
                },
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color:  Color(0xFF171C6E),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: const Text(
                    '3', // Replace with your notification count
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          )
        ],
      ),

      drawer: const AppDrawer(),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
            color:  Color(0xFF171C6E),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    //const CircleAvatar(
                     // radius: 30,
                    //  backgroundColor: Colors.white,
                    //  child: Icon(Icons.person, color: Colors.red, size: 30),
                   // ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Welcome, ',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Ahmed!',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Digitizing and automating policy management, claims handling, and underwriting',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 15),
            const Text('News',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),

            // Carousel with dot indicator
            Column(
              children: [
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red,
                          blurRadius: 4,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: CarouselSlider(
                        options: CarouselOptions(
                          height: 100,
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 3),
                          viewportFraction: 1.0,
                          enlargeCenterPage: false,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _currentIndex = index;
                            });
                          },
                        ),
                        items: imgList.map((imagePath) {
                          return Image.asset(
                            imagePath,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(imgList.length, (index) {
                    return Container(
                      width: 8.0,
                      height: 8.0,
                      margin: const EdgeInsets.symmetric(horizontal: 3.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentIndex == index
                            ? Colors.red
                            : Colors.grey[300],
                      ),
                    );
                  }),
                ),
              ],
            ),

            const SizedBox(height: 24),
            const Text(
              'Quick Overview',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              childAspectRatio: 1 / 1.2,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: _dashboardCard(Icons.policy_outlined, 'Policies', '3'),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: _dashboardCard(Icons.refresh, 'Claims', '1'),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: _dashboardCard(Icons.work_outline, 'Transaction', '150,000'),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: _dashboardCard(Icons.timer_outlined, 'Renewals', '2'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Recent Transactions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Column(
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
          ],
        ),
      ),
    );
  }

  static Widget _dashboardCard(IconData icon, String label, String value) {
    final Color baseColor = Colors.red;
    return IntrinsicHeight(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: baseColor,
              blurRadius: 3,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,  // important to shrink to content height
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
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
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                label,
                style: const TextStyle(fontSize: 15),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
              style: const TextStyle(fontSize: 8,fontWeight: FontWeight.w600),
                ),
                Text(
                  status,
                  style: const TextStyle(fontSize: 6, color: Colors.black,fontWeight: FontWeight.w500,),
                )
               ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  amount,
                  style: const TextStyle(fontSize: 6, color: Colors.black,fontWeight: FontWeight.w500,),
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


}
