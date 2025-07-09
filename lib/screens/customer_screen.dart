import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomerPage extends StatefulWidget {
  @override
  _CustomerPageState createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  final NumberFormat _currencyFormat = NumberFormat.currency(symbol: 'Tzs. ');
  final List<String> _customerTypes = ['All', 'Individual', 'Corporate'];
  String _selectedType = 'All';

  final List<Map<String, dynamic>> _customers = [
    {
      'name': 'Ahmed Siasa',
      'type': 'Individual',
      'email': 'ahmed@example.com',
      'phone': '+255 765 123 456',
      'policyCount': 3,
      'totalPremium': 8200.00
    },
    {
      'name': 'Humtech Ltd.',
      'type': 'Corporate',
      'email': 'contact@humtech.co.tz',
      'phone': '+255 714 987 654',
      'policyCount': 5,
      'totalPremium': 17450.00
    },
  ];

  List<Map<String, dynamic>> get _filteredCustomers {
    if (_selectedType == 'All') return _customers;
    return _customers.where((c) => c['type'] == _selectedType).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Customers', style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            _buildFilter(),
            SizedBox(height: 16),
            Expanded(child: _buildCustomerList()),
          ],
        ),
      ),
    );
  }

  Widget _buildFilter() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Customer Type',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      value: _selectedType,
      items: _customerTypes.map((type) {
        return DropdownMenuItem(value: type, child: Text(type));
      }).toList(),
      onChanged: (val) => setState(() => _selectedType = val!),
    );
  }

  Widget _buildCustomerList() {
    return ListView.builder(
      itemCount: _filteredCustomers.length,
      itemBuilder: (context, index) {
        final customer = _filteredCustomers[index];
        return Container(
          margin: EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(customer['name'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red)),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.email, size: 14, color: Colors.grey[600]),
                  SizedBox(width: 6),
                  Text(customer['email'], style: TextStyle(color: Colors.grey[700], fontSize: 13)),
                ],
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.phone, size: 14, color: Colors.grey[600]),
                  SizedBox(width: 6),
                  Text(customer['phone'], style: TextStyle(color: Colors.grey[700], fontSize: 13)),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Chip(
                    label: Text('Policies: ${customer['policyCount']}', style: TextStyle(fontSize: 12)),
                    backgroundColor: Colors.red.withOpacity(0.1),
                    labelStyle: TextStyle(color: Colors.red),
                  ),
                  SizedBox(width: 8),
                  Chip(
                    label: Text(_currencyFormat.format(customer['totalPremium']), style: TextStyle(fontSize: 12)),
                    backgroundColor: Colors.green.withOpacity(0.1),
                    labelStyle: TextStyle(color: Colors.green[700]),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
