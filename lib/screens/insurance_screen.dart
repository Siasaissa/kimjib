import 'package:flutter/material.dart';
import 'package:kimjib/screens/app_drawer.dart';

class InsuranceScreen extends StatefulWidget {
  const InsuranceScreen({super.key});

  @override
  State<InsuranceScreen> createState() => _InsuranceScreenState();
}

class _InsuranceScreenState extends State<InsuranceScreen> {
  final Color primaryColor = Colors.red; // Red color scheme
  DateTime dueDate = DateTime.now().add(const Duration(days: 7));
  String? _selectedInsuranceType;
  String? _selectedPaymentMethod;
  bool _autoPayEnabled = false;
  bool _isProcessing = false;
  bool _showCardForm = false;

  // Form controllers
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _cardNameController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();

  final List<String> insuranceTypes = [
    'Health Insurance',
    'Auto Insurance',
    'Home Insurance',
    'Life Insurance',
    'Travel Insurance'
  ];

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _cardNameController.dispose();
    _mobileNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Insurance Payment'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      drawer: AppDrawer(),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Insurance Type Selection
                    _buildInsuranceTypeDropdown(theme),
                    const SizedBox(height: 24),

                    // Policy Summary
                    if (_selectedInsuranceType != null)
                      _buildPolicyCard(theme),
                    const SizedBox(height: 24),

                    // Payment Amount
                    if (_selectedInsuranceType != null)
                      _buildPaymentCard(theme),
                    const SizedBox(height: 24),

                    // Payment Methods
                    if (_selectedInsuranceType != null)
                      _buildPaymentMethodsSection(theme),
                    const SizedBox(height: 16),

                    // Card Form (shown when card payment selected)
                    if (_showCardForm) _buildCardForm(),

                    // Mobile Payment Form (shown when mobile wallet selected)
                    if (_selectedPaymentMethod == 'Mobile Wallet' && !_showCardForm)
                      _buildMobilePaymentForm(),

                    // Auto Pay Toggle
                    if (_selectedInsuranceType != null &&
                        !_showCardForm &&
                        _selectedPaymentMethod != 'Mobile Wallet')
                      _buildAutoPayToggle(theme),

                    // Pay Button
                    if (_selectedInsuranceType != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 24, bottom: 8),
                        child: _buildPayButton(context),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCardForm() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Enter Card Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                )),
            const SizedBox(height: 16),
            TextFormField(
              controller: _cardNumberController,
              decoration: InputDecoration(
                labelText: 'Card Number',
                hintText: '4242 4242 4242 4242',
                prefixIcon: Icon(Icons.credit_card, color: primaryColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              keyboardType: TextInputType.number,
              maxLength: 19,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _expiryController,
                    decoration: InputDecoration(
                      labelText: 'Expiry Date (MM/YY)',
                      hintText: '12/25',
                      prefixIcon: Icon(Icons.calendar_today, color: primaryColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _cvvController,
                    decoration: InputDecoration(
                      labelText: 'CVV',
                      hintText: '123',
                      prefixIcon: Icon(Icons.lock, color: primaryColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 3,
                    obscureText: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _cardNameController,
              decoration: InputDecoration(
                labelText: 'Cardholder Name',
                hintText: 'Ahmed Rugaza',
                prefixIcon: Icon(Icons.person, color: primaryColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobilePaymentForm() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mobile Payment',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                )),
            const SizedBox(height: 16),
            TextFormField(
              controller: _mobileNumberController,
              decoration: InputDecoration(
                labelText: 'Mobile Number',
                hintText: '07XX XXX XXX',
                prefixIcon: Icon(Icons.phone_android, color: primaryColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 8),
            Text('You will receive a payment request on your mobile device',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildInsuranceTypeDropdown(ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Select Insurance Type',
            border: InputBorder.none,
            icon: Icon(Icons.medical_services, color: primaryColor),
          ),
          value: _selectedInsuranceType,
          items: insuranceTypes
              .map((type) => DropdownMenuItem(
            value: type,
            child: Text(type),
          ))
              .toList(),
          onChanged: (value) {
            setState(() {
              _selectedInsuranceType = value;
              _selectedPaymentMethod = null;
              _showCardForm = false;
            });
          },
          hint: const Text('Choose your insurance'),
        ),
      ),
    );
  }

  Widget _buildPolicyCard(ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.assignment, color: primaryColor),
                const SizedBox(width: 12),
                Text('Policy Details',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    )),
              ],
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Insurance Type', _selectedInsuranceType!, theme),
            const SizedBox(height: 12),
            _buildDetailRow('Policy Number', 'INS-2023-${_selectedInsuranceType!.substring(0, 3).toUpperCase()}7890', theme),
            const SizedBox(height: 12),
            _buildDetailRow('Coverage Period', 'Jan 2023 - Dec 2023', theme),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentCard(ThemeData theme) {
    double amount = _calculatePremium(_selectedInsuranceType!);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.payment, color: primaryColor),
                const SizedBox(width: 12),
                Text('Payment Due',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    )),
              ],
            ),
            const SizedBox(height: 16),
            Text('TZS ${amount.toStringAsFixed(2)}',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                )),
            const SizedBox(height: 8),
            Text('Current Balance',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                )),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today,
                      size: 18, color: Colors.orange.shade700),
                  const SizedBox(width: 8),
                  Text('Due by ${_formatDate(dueDate)}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.orange.shade700,
                        fontWeight: FontWeight.w500,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _calculatePremium(String insuranceType) {
    switch (insuranceType) {
      case 'Health Insurance':
        return 245000; // TZS amount
      case 'Auto Insurance':
        return 185500;
      case 'Home Insurance':
        return 320750;
      case 'Life Insurance':
        return 150250;
      case 'Travel Insurance':
        return 75000;
      default:
        return 0.00;
    }
  }

  Widget _buildPaymentMethodsSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 12),
          child: Text('Payment Method',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              )),
        ),
        _buildPaymentOption(
          icon: Icons.credit_card,
          title: 'Credit/Debit Card',
          subtitle: 'Visa, Mastercard, Amex',
          isSelected: _selectedPaymentMethod == 'Credit/Debit Card',
          onTap: () => setState(() {
            _selectedPaymentMethod = 'Credit/Debit Card';
            _showCardForm = true;
          }),
        ),
        const SizedBox(height: 12),
        _buildPaymentOption(
          icon: Icons.account_balance,
          title: 'Bank Transfer',
          subtitle: 'Direct bank payment',
          isSelected: _selectedPaymentMethod == 'Bank Transfer',
          onTap: () => setState(() {
            _selectedPaymentMethod = 'Bank Transfer';
            _showCardForm = false;
          }),
        ),
        const SizedBox(height: 12),
        _buildPaymentOption(
          icon: Icons.phone_android,
          title: 'Mobile Wallet',
          subtitle: 'M-Pesa, Tigo Pesa, Airtel Money',
          isSelected: _selectedPaymentMethod == 'Mobile Wallet',
          onTap: () => setState(() {
            _selectedPaymentMethod = 'Mobile Wallet';
            _showCardForm = false;
          }),
        ),
      ],
    );
  }

  Widget _buildPaymentOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: isSelected ? 2 : 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? primaryColor : Colors.grey.shade200,
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isSelected ? primaryColor.withOpacity(0.2) : Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon,
                    color: isSelected ? primaryColor : Colors.grey.shade600),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        )),
                    Text(subtitle,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                        )),
                  ],
                ),
              ),
              if (isSelected)
                Icon(Icons.check_circle, color: primaryColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAutoPayToggle(ThemeData theme) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(Icons.autorenew, color: primaryColor),
            const SizedBox(width: 12),
            Expanded(
              child: Text('Enable Auto-Pay',
                  style: theme.textTheme.bodyLarge),
            ),
            Switch(
              value: _autoPayEnabled,
              activeColor: primaryColor,
              onChanged: (value) {
                setState(() {
                  _autoPayEnabled = value;
                });
                if (value) {
                  _showAutoPayConfirmation();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPayButton(BuildContext context) {
    bool isFormValid = _selectedPaymentMethod != null &&
        ((_selectedPaymentMethod == 'Credit/Debit Card' &&
            _cardNumberController.text.isNotEmpty &&
            _expiryController.text.isNotEmpty &&
            _cvvController.text.isNotEmpty &&
            _cardNameController.text.isNotEmpty) ||
            (_selectedPaymentMethod == 'Mobile Wallet' &&
                _mobileNumberController.text.isNotEmpty) ||
            (_selectedPaymentMethod == 'Bank Transfer'));

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
      ),
      onPressed: !isFormValid ? null : () => _processPayment(context),
      child: _isProcessing
          ? const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.white,
        ),
      )
          : const Text('PAY NOW',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildDetailRow(String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                )),
          ),
          Text(value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              )),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day} ${_getMonthName(date.month)} ${date.year}';
  }

  String _getMonthName(int month) {
    return [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ][month - 1];
  }

  void _showAutoPayConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enable Auto-Pay?'),
        content: const Text('Your payment will be automatically processed on the due date each month.'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() => _autoPayEnabled = false);
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Auto-Pay enabled successfully')),
              );
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  Future<void> _processPayment(BuildContext context) async {
    if (_selectedPaymentMethod == null) return;

    setState(() => _isProcessing = true);

    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isProcessing = false);

    _showConfirmationDialog(context);
  }

  void _showConfirmationDialog(BuildContext context) {
    double amount = _calculatePremium(_selectedInsuranceType!);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check_circle,
                    size: 48, color: Colors.green.shade600),
              ),
              const SizedBox(height: 24),
              Text('Payment Successful!',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(height: 8),
              Text('TZS ${amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(height: 16),
              Text('Paid via $_selectedPaymentMethod',
                  style: TextStyle(color: Colors.grey.shade600)),
              const SizedBox(height: 8),
              Text('For $_selectedInsuranceType',
                  style: TextStyle(color: Colors.grey.shade600)),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Done',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}