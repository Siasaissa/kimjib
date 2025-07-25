import 'package:flutter/material.dart';
import 'package:kimjib/screens/get_quote_screen.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _allProducts = [
    {
      'name': 'Auto Insurance',
      'category': 'Motor',
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
      'category': 'Health',
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

  List<Map<String, dynamic>> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _filteredProducts = List.from(_allProducts);
  }

  void _filterProducts(String query) {
    final filtered = _allProducts.where((product) {
      final name = product['name'].toString().toLowerCase();
      final category = product['category'].toString().toLowerCase();
      return name.contains(query.toLowerCase()) || category.contains(query.toLowerCase());
    }).toList();

    setState(() {
      _filteredProducts = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Insurance Products',
          style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.6),
        ),
        backgroundColor: Colors.red.shade700,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 6,
        shadowColor: Colors.red.shade300,
      ),
      body: Container(
        color: Colors.grey.shade100,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            Material(
              elevation: 3,
              shadowColor: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(14),
              child: TextField(
                controller: _searchController,
                onChanged: _filterProducts,
                decoration: InputDecoration(
                  hintText: 'Search by name or category...',
                  prefixIcon: const Icon(Icons.search, color: Colors.red),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.red.shade400, width: 2),
                  ),
                ),
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: _filteredProducts.isNotEmpty
                  ? ScrollConfiguration(
                behavior: const BouncingScrollBehavior(),
                child: ListView.builder(
                  itemCount: _filteredProducts.length,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    final product = _filteredProducts[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 5,
                      shadowColor: Colors.red.shade100,
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(product['icon'], size: 30, color: Colors.red.shade700),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product['name'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        product['category'],
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Text(
                              product['description'],
                              style: TextStyle(fontSize: 15, color: Colors.grey.shade800),
                            ),
                            const SizedBox(height: 18),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => GetQuotePage(
                                        insuranceType: product['category'],
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  elevation: 5,
                                  shadowColor: Colors.red,
                                ),
                                child: const Text(
                                  'Get Quote',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
                  : Center(
                child: Text(
                  'No products found.',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BouncingScrollBehavior extends ScrollBehavior {
  const BouncingScrollBehavior();
  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) =>
      child;
}
