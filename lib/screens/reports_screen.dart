import 'package:flutter/material.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final _formKey = GlobalKey<FormState>();

  // Dropdown values
  String? branch;
  String? insurer;
  String? customerSegment;
  String? insuranceType;
  String? businessType;
  String? policyType;
  String? currency;
  String? quarter;
  String? month;
  String? product;

  DateTime? fromDate;
  DateTime? toDate;

  final TextEditingController clientName = TextEditingController();
  final TextEditingController supplierName = TextEditingController();
  final TextEditingController account = TextEditingController();
  final TextEditingController debitNo = TextEditingController();
  final TextEditingController riskNote = TextEditingController();
  final TextEditingController year = TextEditingController();

  final List<String> branches = ['Dar', 'Arusha', 'Dodoma'];
  final List<String> insurers = ['Heritage', 'Jubilee', 'NIC'];
  final List<String> segments = ['Retail', 'Corporate'];
  final List<String> insuranceTypes = ['Health', 'Motor', 'Life'];
  final List<String> businessTypes = ['New', 'Renewal'];
  final List<String> policyTypes = ['Comprehensive', 'Third Party'];
  final List<String> currencies = ['TZS', 'USD', 'GBP'];
  final List<String> quarters = ['Q1', 'Q2', 'Q3', 'Q4'];
  final List<String> months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];
  final List<String> products = ['Product A', 'Product B', 'Product C'];

  Future<void> _selectDate(BuildContext context, bool isFrom) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        isFrom ? fromDate = picked : toDate = picked;
      });
    }
  }

  @override
  void dispose() {
    clientName.dispose();
    supplierName.dispose();
    account.dispose();
    debitNo.dispose();
    riskNote.dispose();
    year.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insurance Report', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Wrap(
              spacing: 16,
              runSpacing: 10,
              children: [
                buildDropdown('Select Branch', branches, branch, (val) => setState(() => branch = val)),
                buildDropdown('Select Insurer', insurers, insurer, (val) => setState(() => insurer = val)),
                buildTextField('Client Name', controller: clientName),
                buildTextField('Supplier Name', controller: supplierName),
                buildTextField('Account', controller: account),
                buildDropdown('Customer Segment', segments, customerSegment, (val) => setState(() => customerSegment = val)),
                buildDropdown('Insurance Type', insuranceTypes, insuranceType, (val) => setState(() => insuranceType = val)),
                buildDropdown('Business Type', businessTypes, businessType, (val) => setState(() => businessType = val)),
                buildDropdown('Policy Type', policyTypes, policyType, (val) => setState(() => policyType = val)),
                buildDropdown('Select Currency', currencies, currency, (val) => setState(() => currency = val)),
                buildTextField('Debit No', controller: debitNo),
                buildTextField('Risk Note', controller: riskNote),
                buildTextField('Year', controller: year),
                buildDropdown('Quarter', quarters, quarter, (val) => setState(() => quarter = val)),
                buildDropdown('Month', months, month, (val) => setState(() => month = val)),
                buildDropdown('Product', products, product, (val) => setState(() => product = val)),
                buildDatePicker('From Date', fromDate, () => _selectDate(context, true)),
                buildDatePicker('To Date', toDate, () => _selectDate(context, false)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.bar_chart, color: Colors.white),
                      label: const Text('Show Report', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                    const SizedBox(width: 10),
                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          branch = null;
                          insurer = null;
                          customerSegment = null;
                          insuranceType = null;
                          businessType = null;
                          policyType = null;
                          currency = null;
                          quarter = null;
                          month = null;
                          product = null;
                          fromDate = null;
                          toDate = null;
                          clientName.clear();
                          supplierName.clear();
                          account.clear();
                          debitNo.clear();
                          riskNote.clear();
                          year.clear();
                        });
                      },
                      child: const Text('Clear'),
                    ),
                    const SizedBox(width: 10),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Exit'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDropdown(String label, List<String> items, String? value, void Function(String?)? onChanged) {
    return SizedBox(
      width: 300,
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(labelText: label),
        value: value,
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget buildTextField(String label, {required TextEditingController controller}) {
    return SizedBox(
      width: 300,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }

  Widget buildDatePicker(String label, DateTime? date, VoidCallback onTap) {
    return SizedBox(
      width: 300,
      child: TextFormField(
        readOnly: true,
        controller: TextEditingController(
          text: date != null ? date.toString().split(' ')[0] : '',
        ),
        onTap: onTap,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}
