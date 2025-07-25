import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

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
  bool _showBankDetails = false;

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
        iconTheme: const IconThemeData(color: Colors.white),
      ),
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

                    // Bank Transfer Details (shown when bank transfer selected)
                    if (_showBankDetails) _buildBankTransferDetails(),

                    // Card Form (shown when card payment selected)
                    if (_showCardForm) _buildCardForm(),

                    // Mobile Payment Form (shown when mobile wallet selected)
                    if (_selectedPaymentMethod == 'Mobile Wallet' && !_showCardForm)
                      _buildMobilePaymentForm(),

                    // Auto Pay Toggle
                    if (_selectedInsuranceType != null &&
                        !_showCardForm &&
                        _selectedPaymentMethod != 'Mobile Wallet' &&
                        !_showBankDetails)
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

  Widget _buildBankTransferDetails() {
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
            Text('Bank Transfer Instructions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                )),
            const SizedBox(height: 16),
            _buildBankDetailRow('Bank Name', 'CRDB Bank'),
            _buildBankDetailRow('Account Name', 'KimJib Insurance Ltd'),
            _buildBankDetailRow('Account Number', '0152012345678'),
            _buildBankDetailRow('Swift Code', 'CORUTZTZ'),
            _buildBankDetailRow('Reference', 'INS-${_selectedInsuranceType!.substring(0, 3).toUpperCase()}${DateTime.now().year}'),
            const SizedBox(height: 16),
            Text('After making the transfer, please upload proof of payment below:',
                style: TextStyle(color: Colors.grey.shade600)),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              icon: Icon(Icons.upload_file, color: primaryColor),
              label: const Text('Upload Payment Proof'),
              onPressed: () {
                // Implement file upload functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Upload functionality would be implemented here')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBankDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,  // Fixed width for label
            child: Text(label,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                )),
          ),
          Expanded(  // Add Expanded here
            child: Text(value,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis),  // Add overflow
          ),
          IconButton(
            icon: Icon(Icons.copy, size: 18, color: primaryColor),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Copied $value to clipboard')),
              );
            },
          ),
        ],
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
              _showBankDetails = false;
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
            _buildDetailRow('Policy Number', 'INS-${_selectedInsuranceType!.substring(0, 3).toUpperCase()}${DateTime.now().year}7890', theme),
            const SizedBox(height: 12),
            _buildDetailRow('Coverage Period', '${_formatDate(DateTime.now())} - ${_formatDate(DateTime.now().add(const Duration(days: 365)))}', theme),
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
            _showBankDetails = false;
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
            _showBankDetails = true;
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
            _showBankDetails = false;
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
          Expanded(  // Add Expanded here
            child: Text(value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis),
          ),
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


  Future<void> _deliverPolicy() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(
                level: 0,
                child: pw.Text('Insurance Policy',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    )),
              ),
              pw.SizedBox(height: 20),
              pw.Text('KimJib Insurance Ltd',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  )),
              pw.Text('Policy Effective: ${_formatDate(DateTime.now())}'),
              pw.Divider(),
              pw.Text('Policy Details',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  )),
              pw.Text('Insurance Type: $_selectedInsuranceType'),
              pw.Text('Policy Number: INS-${_selectedInsuranceType!.substring(0, 3).toUpperCase()}${DateTime.now().year}7890'),
              pw.Text('Coverage Period: ${_formatDate(DateTime.now())} - ${_formatDate(DateTime.now().add(const Duration(days: 365)))}'),
              pw.Divider(),
              pw.Text('Policy Terms and Conditions',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  )),
              pw.Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit...'),
              pw.Spacer(),
              pw.Text('This is your official policy document. Please keep it safe.',
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontStyle: pw.FontStyle.italic,
                  )),
            ],
          );
        },
      ),
    );

    // For demo purposes, we'll just show the PDF
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );

    // In a real app, you would also want to email this to the user:
    /*
    final Email email = Email(
      body: 'Please find attached your insurance policy document.',
      subject: 'Your KimJib Insurance Policy',
      recipients: ['customer@email.com'],
      attachmentPaths: [policyPdfPath],
    );

    await FlutterEmailSender.send(email);
    */
  }
  void _showReceiptPopup(BuildContext context) {
    double amount = _calculatePremium(_selectedInsuranceType!);
    String paymentMethod = _selectedPaymentMethod ?? 'Unknown';
    String policyNumber = 'INS-${_selectedInsuranceType!.substring(0, 3).toUpperCase()}${DateTime.now().year}7890';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 4,
          child: Container(
            constraints: BoxConstraints(maxWidth: 500),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header with logo/icon
                    Icon(
                      Icons.verified_outlined,
                      size: 48,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'PAYMENT RECEIPT',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'KimJib Insurance Ltd',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Divider(height: 1, thickness: 1, color: Colors.grey.shade300),

                    // Receipt details section
                    const SizedBox(height: 24),
                    _buildReceiptSection(
                      title: 'Receipt Details',
                      children: [
                        _buildReceiptRow('Receipt No:', 'RC${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}'),
                        _buildReceiptRow('Date:', _formatDate(DateTime.now())),
                        _buildReceiptRow('Time:', '${TimeOfDay.now().format(context)}'),
                      ],
                    ),

                    // Payment information section
                    const SizedBox(height: 16),
                    _buildReceiptSection(
                      title: 'Payment Information',
                      children: [
                        _buildReceiptRow('Policy Number:', policyNumber),
                        _buildReceiptRowWithIcon('Insurance Type:', _selectedInsuranceType!, Icons.shield),
                        _buildReceiptRow('Payment Method:', paymentMethod),
                      ],
                    ),

                    // Amount section
                    const SizedBox(height: 16),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Total Amount Paid',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'TZS ${amount.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Footer
                    const SizedBox(height: 24),
                    Divider(height: 1, thickness: 1, color: Colors.grey.shade300),
                    const SizedBox(height: 16),
                    Text(
                      'Thank you for choosing KimJib Insurance!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This is your official receipt. Please keep it for your records.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Close button
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'CLOSE RECEIPT',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    //download  button
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.of(context).pop(); // Close the dialog
                        await _generateAndSaveReceipt();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'DOWNLOAD RECEIPT',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildReceiptSection({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: primaryColor,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildReceiptRowWithIcon(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value, {bool isBold = false, Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
                color: valueColor,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    double amount = _calculatePremium(_selectedInsuranceType!);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 5,
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animated Checkmark
              TweenAnimationBuilder(
                duration: const Duration(milliseconds: 500),
                tween: Tween<double>(begin: 0, end: 1),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: Curves.elasticOut.transform(value),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.green.shade100,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.check_circle,
                        size: 60,
                        color: Colors.green.shade600,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              // Success Message
              Text(
                'Payment Successful!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),

              const SizedBox(height: 16),

              // Amount
              Text(
                'TZS ${amount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),

              const SizedBox(height: 8),

              // Payment Details
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildDetailItem(
                      icon: Icons.payment,
                      label: 'Payment Method',
                      value: _selectedPaymentMethod!,
                    ),
                    const Divider(height: 16),
                    _buildDetailItem(
                      icon: Icons.medical_services,
                      label: 'Insurance Type',
                      value: _selectedInsuranceType!,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: primaryColor),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        _showReceiptPopup(context);
                      },
                      child: Text(
                        'View Receipt',
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        Navigator.pop(context);
                        await _generateAndSaveReceipt();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Receipt downloaded successfully'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      child: const Text(
                        'Download',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem({required IconData icon, required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _generateReceipt() async {
    final pdf = pw.Document();

    // Add customer name from card form (or use a default if empty)
    final customerName = _cardNameController.text.isNotEmpty
        ? _cardNameController.text
        : 'Customer';

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header with company logo and info
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('KIMJIB INSURANCE LTD',
                          style: pw.TextStyle(
                            fontSize: 18,
                            fontWeight: pw.FontWeight.bold,
                          )),
                      pw.Text('P.O. Box 12345, Dar es Salaam, Tanzania'),
                      pw.Text('Phone: +255 123 456 789'),
                      pw.Text('Email: info@kimjib.co.tz'),
                    ],
                  ),
                  pw.Text('OFFICIAL RECEIPT',
                      style: pw.TextStyle(
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.red,
                      )),
                ],
              ),

              pw.SizedBox(height: 20),
              pw.Divider(thickness: 2),
              pw.SizedBox(height: 10),

              // Customer Information
              pw.Text('Customer: $customerName',
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  )),
              pw.Text('Date: ${_formatDate(DateTime.now())}'),
              pw.Text('Receipt No: RC${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}'),
              pw.SizedBox(height: 20),

              // Payment Details
              pw.Text('PAYMENT DETAILS',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    decoration: pw.TextDecoration.underline,
                  )),
              pw.SizedBox(height: 10),

              // Payment information table
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Description',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Amount (TZS)',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('$_selectedInsuranceType Premium Payment'),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                            _calculatePremium(_selectedInsuranceType!)
                                .toStringAsFixed(2)),
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 15),

              // Payment method and reference
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Payment Method: $_selectedPaymentMethod'),
                      pw.Text('Reference: INS-${_selectedInsuranceType!.substring(0, 3).toUpperCase()}${DateTime.now().year}'),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('TOTAL PAID',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('TZS ${_calculatePremium(_selectedInsuranceType!).toStringAsFixed(2)}',
                          style: pw.TextStyle(
                              fontSize: 16, fontWeight: pw.FontWeight.bold)),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 30),

              // Footer and signature
              pw.Divider(thickness: 1),
              pw.SizedBox(height: 10),
              pw.Text('Thank you for your payment!',
                  style: pw.TextStyle(fontStyle: pw.FontStyle.italic)),
              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Column(
                    children: [
                      pw.Text('Authorized Signature'),
                      pw.SizedBox(height: 40), // Space for signature
                      pw.Text('KimJib Insurance Ltd'),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    // Show the PDF preview and save option
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );

    // Optional: Email the receipt to customer
    // await _sendReceiptByEmail(pdf, customerName);
  }

  Future<void> _generateAndSaveReceipt() async {
    final pdf = pw.Document();
    double amount = _calculatePremium(_selectedInsuranceType!);
    String paymentMethod = _selectedPaymentMethod ?? 'Unknown';
    String policyNumber = 'INS-${_selectedInsuranceType!.substring(0, 3).toUpperCase()}${DateTime.now().year}7890';
    String receiptNumber = 'RC${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';
    String customerName = _cardNameController.text.isNotEmpty
        ? _cardNameController.text
        : 'Customer';

    // Get current time without using BuildContext
    final now = DateTime.now();
    final timeString = '${now.hour}:${now.minute.toString().padLeft(2, '0')}';

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {  // This is pdf.Context, not Flutter's BuildContext
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('KimJib Insurance Ltd',
                          style: pw.TextStyle(
                            fontSize: 20,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.red,
                          )),
                      pw.Text('P.O. Box 12345, Dar es Salaam, Tanzania'),
                      pw.Text('Phone: +255 123 456 789'),
                      pw.Text('Email: info@kimjib.co.tz'),
                    ],
                  ),
                  pw.Text('PAYMENT RECEIPT',
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                      )),
                ],
              ),

              pw.SizedBox(height: 20),
              pw.Divider(),
              pw.SizedBox(height: 10),

              // Receipt details
              pw.Text('Receipt Number: $receiptNumber'),
              pw.Text('Date: ${_formatDate(DateTime.now())}'),
              pw.Text('Time: $timeString'),  // Use our calculated time string

              pw.SizedBox(height: 20),

              // Payment information
              pw.Text('Payment Information',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  )),
              pw.SizedBox(height: 10),

              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        child: pw.Text('Policy Number'),
                        padding: const pw.EdgeInsets.all(8),
                      ),
                      pw.Padding(
                        child: pw.Text(policyNumber),
                        padding: const pw.EdgeInsets.all(8),
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        child: pw.Text('Insurance Type'),
                        padding: const pw.EdgeInsets.all(8),
                      ),
                      pw.Padding(
                        child: pw.Text(_selectedInsuranceType!),
                        padding: const pw.EdgeInsets.all(8),
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        child: pw.Text('Payment Method'),
                        padding: const pw.EdgeInsets.all(8),
                      ),
                      pw.Padding(
                        child: pw.Text(paymentMethod),
                        padding: const pw.EdgeInsets.all(8),
                      ),
                    ],
                  ),
                ],
              ),

              pw.SizedBox(height: 20),

              // Amount section
              pw.Container(
                alignment: pw.Alignment.center,
                padding: const pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Column(
                  children: [
                    pw.Text('Total Amount Paid',
                        style: pw.TextStyle(
                          fontSize: 14,
                        )),
                    pw.SizedBox(height: 8),
                    pw.Text('TZS ${amount.toStringAsFixed(2)}',
                        style: pw.TextStyle(
                          fontSize: 24,
                          fontWeight: pw.FontWeight.bold,
                        )),
                  ],
                ),
              ),

              pw.SizedBox(height: 30),

              // Footer
              pw.Divider(),
              pw.SizedBox(height: 10),
              pw.Text('Thank you for choosing KimJib Insurance!',
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontStyle: pw.FontStyle.italic,
                  )),
              pw.Text('This is your official receipt. Please keep it for your records.',
                  style: pw.TextStyle(
                    fontSize: 12,
                  )),
            ],
          );
        },
      ),
    );

    try {
      // Get the downloads directory
      final directory = await getDownloadsDirectory();
      if (directory == null) {
        throw Exception('Cannot access downloads directory');
      }

      // Create file
      final file = File('${directory.path}/KimJib_Receipt_$receiptNumber.pdf');

      // Save the PDF file
      await file.writeAsBytes(await pdf.save());

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Receipt downloaded to ${file.path}'),
          duration: const Duration(seconds: 3),
        ),
      );

      // Optional: Open the file after saving
      // OpenFile.open(file.path);

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving receipt: ${e.toString()}'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _sendReceiptByEmail(pw.Document pdf, String customerName) async {
    try {
      // Save PDF temporarily
      final output = await getTemporaryDirectory();
      final file = File('${output.path}/receipt.pdf');
      await file.writeAsBytes(await pdf.save());

      final Email email = Email(
        body: 'Dear $customerName,\n\nPlease find attached your payment receipt...',
        subject: 'Your Payment Receipt from KimJib Insurance',
        recipients: ['customer@email.com'],
        attachmentPaths: [file.path],
      );

      await FlutterEmailSender.send(email);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not send email: ${e.toString()}')),
      );
    }
  }
}
Widget _buildReceiptRow(String label, String value, {bool isBold = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isBold
              ? const TextStyle(fontWeight: FontWeight.bold)
              : null,
        ),
        Text(
          value,
          style: isBold
              ? const TextStyle(fontWeight: FontWeight.bold)
              : null,
        ),
      ],
    ),
  );
}
