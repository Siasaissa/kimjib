import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add intl in pubspec.yaml dependencies for currency formatting

class GetQuotePage extends StatefulWidget {
  final String insuranceType;

  const GetQuotePage({Key? key, required this.insuranceType}) : super(key: key);

  @override
  State<GetQuotePage> createState() => _GetQuotePageState();
}

class _GetQuotePageState extends State<GetQuotePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _valueController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  List<Map<String, dynamic>> _quotes = [];
  bool _isLoading = false;

  final List<Map<String, dynamic>> _insurers = [
    {'name': 'Insurer A', 'multiplier': 0.05},
   // {'name': 'Insurer B', 'multiplier': 0.045},
   // {'name': 'Insurer C', 'multiplier': 0.055},
  ];

  final currencyFormatter = NumberFormat.currency(locale: 'en_TZ', symbol: 'TZS ');

  Future<void> _calculateQuotes() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _quotes = [];
    });

    await Future.delayed(const Duration(seconds: 1)); // simulate API call delay

    final double baseValue = double.tryParse(_valueController.text) ?? 0;
    final int age = int.tryParse(_ageController.text) ?? 30;

    final results = _insurers.map((insurer) {
      double premium = baseValue * insurer['multiplier'];
      if (widget.insuranceType.toLowerCase() == 'life' ||
          widget.insuranceType.toLowerCase() == 'health') {
        premium *= (1 + (age - 30) * 0.01);
      }
      return {
        'insurer': insurer['name'],
        'premium': premium,
        'features': [
          '24/7 Customer Support',
          'Fast & Easy Claims',
          'Online Documentation',
          'Flexible Payment Options',
        ],
      };
    }).toList();

    setState(() {
      _quotes = results.toList();
      _isLoading = false;
    });
  }

  Widget _buildDynamicForm() {
    InputDecoration buildInputDecoration(String label, IconData icon) {
      return InputDecoration(
        prefixIcon: Icon(icon, color: Colors.red.shade700),
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        errorStyle: const TextStyle(color: Colors.redAccent),
      );
    }

    switch (widget.insuranceType.toLowerCase()) {
      case 'motor':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _valueController,
              keyboardType: TextInputType.number,
              decoration: buildInputDecoration('Vehicle Value (TZS)', Icons.directions_car),
              validator: (value) =>
              (value == null || value.isEmpty) ? 'Please enter vehicle value' : null,
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: buildInputDecoration('Driver Age', Icons.person),
              validator: (value) =>
              (value == null || value.isEmpty) ? 'Please enter driver age' : null,
            ),
          ],
        );

      case 'health':
      case 'life':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _valueController,
              keyboardType: TextInputType.number,
              decoration: buildInputDecoration('Sum Insured (TZS)', Icons.health_and_safety),
              validator: (value) =>
              (value == null || value.isEmpty) ? 'Please enter sum insured' : null,
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: buildInputDecoration('Age', Icons.cake),
              validator: (value) => (value == null || value.isEmpty) ? 'Please enter your age' : null,
            ),
          ],
        );

      case 'travel':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _valueController,
              keyboardType: TextInputType.number,
              decoration: buildInputDecoration('Trip Cost (TZS)', Icons.flight_takeoff),
              validator: (value) =>
              (value == null || value.isEmpty) ? 'Please enter trip cost' : null,
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: buildInputDecoration('Traveler Age', Icons.person_outline),
              validator: (value) =>
              (value == null || value.isEmpty) ? 'Please enter traveler age' : null,
            ),
          ],
        );

      case 'property':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _valueController,
              keyboardType: TextInputType.number,
              decoration: buildInputDecoration('Property Value (TZS)', Icons.house),
              validator: (value) =>
              (value == null || value.isEmpty) ? 'Please enter property value' : null,
            ),
          ],
        );

      default:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Center(
            child: Text(
              'Unknown insurance type',
              style: TextStyle(fontSize: 18, color: Colors.red.shade400),
            ),
          ),
        );
    }
  }

  @override
  void dispose() {
    _valueController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final insuranceTypeCapitalized =
        '${widget.insuranceType[0].toUpperCase()}${widget.insuranceType.substring(1)}';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red.shade700,
        foregroundColor: Colors.white,
        title: Text('$insuranceTypeCapitalized Insurance Quote'),
        centerTitle: true,
        elevation: 6,
        shadowColor: Colors.red,
      ),
      body: Container(
        color: Colors.grey.shade100,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: ScrollConfiguration(
          behavior: const BouncingScrollBehavior(),
          child: ListView(
            children: [
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 6,
                shadowColor: Colors.red.shade100,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: Form(
                    key: _formKey,
                    child: _buildDynamicForm(),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _calculateQuotes,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 8,
                    shadowColor: Colors.red,
                  ),
                  child: _isLoading
                      ? SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                  )
                      : const Text(
                    'Calculate Premiums',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, letterSpacing: 0.7,color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 36),
              if (_quotes.isNotEmpty) ...[
                Text(
                  'Quotes from Insurers',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade700,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 24),
                ..._quotes.map(
                      (quote) => Card(
                    margin: const EdgeInsets.only(bottom: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    elevation: 5,
                    shadowColor: Colors.red.shade100,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.verified_user, color: Colors.red.shade700, size: 26),
                              const SizedBox(width: 10),
                              Text(
                                quote['insurer'],
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.red.shade800,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Premium:',
                            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey.shade800),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            currencyFormatter.format(quote['premium']),
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            'Features',
                            style: TextStyle(fontWeight: FontWeight.w700, color: Colors.grey.shade900),
                          ),
                          const SizedBox(height: 10),
                          ...List<Widget>.from(quote['features'].map(
                                (feature) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  Icon(Icons.check_circle, size: 18, color: Colors.green.shade600),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      feature,
                                      style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
                )
              ],
              if (_quotes.isEmpty && !_isLoading)
                Center(
                  child: Text(
                    'Fill in the details and tap "Calculate Premiums" to get quotes.',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
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
