import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class CommissionPage extends StatefulWidget {
  @override
  _CommissionPageState createState() => _CommissionPageState();
}

class _CommissionPageState extends State<CommissionPage> {
  String _selectedPeriod = 'This Month';
  String? _selectedProduct;
  DateTimeRange? _selectedDateRange;

  final List<String> _periods = ['This Month', 'Last Month', 'This Quarter', 'This Year'];
  final List<String> _products = ['Auto Insurance', 'Home Insurance', 'Life Insurance'];
  final NumberFormat _currencyFormat = NumberFormat.currency(symbol: 'Tzs. ');
  final List<double> monthlyEarnings = [500, 800, 0, 300, 500, 800, 0, 300, 200, 500, 200, 400];

  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2023),
      lastDate: DateTime(2026),
    );
    if (picked != null) {
      setState(() => _selectedDateRange = picked);
    }
  }

  /// Show payout schedule in a bottom sheet
  void _showPayoutSchedule() {
    final schedules = [
      {'date': 'Aug 30, 2025', 'amount': 1500.00},
      {'date': 'Sep 30, 2025', 'amount': 1700.00},
      {'date': 'Oct 30, 2025', 'amount': 2000.00},
    ];

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Payout Schedule',
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
              ),
              SizedBox(height: 16),
              ...schedules.map((item) => ListTile(
                title: Text(item['date'] as String),
                trailing: Text(
                  _currencyFormat.format(item['amount']),
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.green[700]),
                ),
              )),
              SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  /// Confirmation dialog for early payout request
  Future<void> _requestEarlyPayout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Request Early Payout'),
        content: Text(
            'Do you want to request an early payout? This may be subject to approval.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Request', style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // In a real app, trigger an API call here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Early payout request submitted')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title:
        Text('Commission', style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(),
            SizedBox(height: 16),
            _buildFilterSection(),
            SizedBox(height: 24),
            _buildPerformanceOverview(),
            SizedBox(height: 24),
            _buildSectionHeader('Recent Commissions', 'View All'),
            SizedBox(height: 12),
            _buildCommissionTable(),
            SizedBox(height: 24),
            _buildSectionHeader('Payout Status', null),
            SizedBox(height: 12),
            _buildPayoutCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('My Commission',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500)),
              SizedBox(height: 4),
              Text(_currencyFormat.format(8420.50),
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.red)),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey[200]!),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05), blurRadius: 8)
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedPeriod,
              icon: Icon(Icons.keyboard_arrow_down, color: Colors.red),
              items: _periods.map((String value) {
                return DropdownMenuItem(value: value, child: Text(value));
              }).toList(),
              onChanged: (newVal) =>
                  setState(() => _selectedPeriod = newVal!),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterSection() {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Product Type',
              filled: true,
              fillColor: Colors.white,
              border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            value: _selectedProduct,
            items: _products.map((type) {
              return DropdownMenuItem(value: type, child: Text(type));
            }).toList(),
            onChanged: (val) => setState(() => _selectedProduct = val),
          ),
        ),
        SizedBox(width: 12),
        ElevatedButton.icon(
          onPressed: _pickDateRange,
          icon: Icon(
            Icons.date_range,
            color: Colors.white,
          ),
          label: Text(
            'Date Range',
            style: TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }

  Widget _buildPerformanceOverview() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05), blurRadius: 16),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetricCard('Earned', 4250.00, Colors.blue[800]!),
              _buildMetricCard('Pending', 1250.00, Colors.orange[600]!),
              _buildMetricCard('Paid Out', 3000.00, Colors.green[600]!),
            ],
          ),
          SizedBox(
            height: 250,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: 650,
                child: BarChart(
                  BarChartData(
                    maxY: 1000,
                    barTouchData: BarTouchData(
                      enabled: false,
                      touchTooltipData: BarTouchTooltipData(
                        tooltipBgColor: Colors.transparent,
                        tooltipPadding: EdgeInsets.zero,
                        tooltipMargin: 0,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          return BarTooltipItem(
                            '${monthlyEarnings[group.x.toInt()].toStringAsFixed(0)}',
                            TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles:
                        SideTitles(showTitles: true, reservedSize: 35),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            final months = [
                              'Jan',
                              'Feb',
                              'Mar',
                              'Apr',
                              'May',
                              'Jun',
                              'Jul',
                              'Aug',
                              'Sep',
                              'Oct',
                              'Nov',
                              'Dec'
                            ];
                            if (value.toInt() >= 0 &&
                                value.toInt() < months.length) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(months[value.toInt()],
                                    style: TextStyle(fontSize: 10)),
                              );
                            }
                            return SizedBox.shrink();
                          },
                        ),
                      ),
                      rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    gridData: FlGridData(show: true),
                    borderData: FlBorderData(show: false),
                    barGroups:
                    List.generate(monthlyEarnings.length, (index) {
                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: monthlyEarnings[index],
                            width: 18,
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(4),
                            rodStackItems: [],
                          ),
                        ],
                        showingTooltipIndicators: [0],
                      );
                    }),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, double amount, Color color) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          SizedBox(height: 4),
          Text(_currencyFormat.format(amount),
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: color)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String? actionText) {
    return Row(
      children: [
        Text(title,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red)),
        Spacer(),
        if (actionText != null)
          TextButton(
            onPressed: () {},
            child: Text(actionText,
                style: TextStyle(
                    color: Colors.red, fontWeight: FontWeight.w500)),
            style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap),
          ),
      ],
    );
  }

  Widget _buildCommissionTable() {
    final List<Map<String, dynamic>> commissions = [
      {
        'policyNo': 'Tz-2023-001',
        'customer': 'Ahmed Siasa',
        'product': 'Auto Insurance',
        'date': 'May 15, 2023',
        'amount': 450.00,
        'status': 'Paid',
        'statusColor': Colors.green,
      },
      {
        'policyNo': 'Tz-2023-002',
        'customer': 'Ahmed Siasa',
        'product': 'Home Insurance',
        'date': 'May 18, 2023',
        'amount': 620.00,
        'status': 'Pending',
        'statusColor': Colors.orange,
      },
      {
        'policyNo': 'Tz-2023-003',
        'customer': 'Ahmed Siasa',
        'product': 'Life Insurance',
        'date': 'May 20, 2023',
        'amount': 1200.00,
        'status': 'Paid',
        'statusColor': Colors.green,
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05), blurRadius: 8)
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border:
              Border(bottom: BorderSide(color: Colors.grey[100]!)),
            ),
            child: Row(
              children: [
                Expanded(
                    flex: 2,
                    child: Text('Policy',
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                            fontSize: 12))),
                Expanded(
                    flex: 3,
                    child: Text('Product',
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                            fontSize: 12))),
                Expanded(
                    flex: 2,
                    child: Text('Date',
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                            fontSize: 12))),
                Expanded(
                    flex: 2,
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: Text('Amount',
                            style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                                fontSize: 12)))),
              ],
            ),
          ),
          ...commissions.map((commission) {
            return Container(
              padding:
              EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        color: commission == commissions.last
                            ? Colors.transparent
                            : Colors.grey[100]!)),
              ),
              child: Row(
                children: [
                  Expanded(
                      flex: 2,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(commission['policyNo'],
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13)),
                            SizedBox(height: 2),
                            Text(commission['customer'],
                                style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12)),
                          ])),
                  Expanded(
                      flex: 3,
                      child: Text(commission['product'],
                          style: TextStyle(fontSize: 13))),
                  Expanded(
                      flex: 2,
                      child: Text(commission['date'],
                          style: TextStyle(
                              fontSize: 13, color: Colors.grey[600]))),
                  Expanded(
                      flex: 2,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                                _currencyFormat
                                    .format(commission['amount']),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: Colors.red)),
                            SizedBox(height: 2),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                  color: commission['statusColor']
                                      .withOpacity(0.1),
                                  borderRadius:
                                  BorderRadius.circular(4)),
                              child: Text(commission['status'],
                                  style: TextStyle(
                                      color:
                                      commission['statusColor'],
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500)),
                            ),
                          ])),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildPayoutCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05), blurRadius: 8)
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.blue[50], shape: BoxShape.circle),
                child: Icon(Icons.account_balance_wallet,
                    color: Colors.red),
              ),
              SizedBox(width: 12),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Next Payout',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14)),
                        SizedBox(height: 2),
                        Text('Standard Chartered Bank •••• 3662',
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 12)),
                      ])),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(_currencyFormat.format(1000.00),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.green[600])),
                    SizedBox(height: 2),
                    Text('Jun 30, 2023',
                        style: TextStyle(
                            color: Colors.grey[600], fontSize: 12)),
                  ]),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _showPayoutSchedule,
                  style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  child: Text('View Schedule',
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.w500)),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _requestEarlyPayout,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  child: Text('Request Early',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
