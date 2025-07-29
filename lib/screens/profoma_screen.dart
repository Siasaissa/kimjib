import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class MyPoliciesPage extends StatefulWidget {
  const MyPoliciesPage({super.key});

  @override
  State<MyPoliciesPage> createState() => _MyPoliciesPageState();
}

String _searchQuery = '';

class _MyPoliciesPageState extends State<MyPoliciesPage> {
  bool _showSearch = false;
  final List<Policy> _policies = [
    Policy(
      id: 'POL123456',
      type: 'Auto',
      provider: 'Kimjib',
      startDate: DateTime.now().subtract(const Duration(days: 30)),
      endDate: DateTime.now().add(const Duration(days: 30)),
      premium: 1200,
      status: 'Active',
      documentUrl: 'https://example.com/policy1.pdf',
      coverage: 'Comprehensive',
      vehicle: 'Toyota Camry 2022',
    ),
    Policy(
      id: 'POL789012',
      type: 'Health',
      provider: 'Kimjib',
      startDate: DateTime.now().subtract(const Duration(days: 400)),
      endDate: DateTime.now().subtract(const Duration(days: 10)),
      premium: 800,
      status: 'Expired',
      documentUrl: 'https://example.com/policy2.pdf',
      coverage: 'Family Plan',
      members: 4,
    ),
    Policy(
      id: 'POL345678',
      type: 'Home',
      provider: 'Kimjib',
      startDate: DateTime.now().subtract(const Duration(days: 15)),
      endDate: DateTime.now().add(const Duration(days: 350)),
      premium: 1500,
      status: 'Active',
      documentUrl: 'https://example.com/policy3.pdf',
      address: 'Manzese Agetina',
      coverage: 'Full Protection',
    ),
    Policy(
      id: 'POL901234',
      type: 'Life',
      provider: 'Kimjib',
      startDate: DateTime.now().subtract(const Duration(days: 100)),
      endDate: DateTime.now().add(const Duration(days: 265)),
      premium: 2000,
      status: 'Active',
      documentUrl: 'https://example.com/policy4.pdf',
      coverage: 'Term Life',
      beneficiary: 'Spouse',
    ),
  ];
  bool _hasUserInteracted = false;  // Add this flag
  String _selectedFilter = 'All';
  String _selectedStatus = 'Active';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        title: _searchQuery.isEmpty
            ? const Text('My Policies',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20))
            : Text('Searching for "$_searchQuery"',
            style: const TextStyle(fontSize: 16)),
        centerTitle: true,
        elevation: 0,

      ),
      body: Column(
        children: [

          // Filter chips
          _buildFilterChips(theme),

          // Policy list
          Expanded(
            child: _buildPolicyList(theme),
          ),
        ],
      ),
    );
  }



  Widget _buildStatCard({
    required String title,
    required int count,
    required double amount,
    required IconData icon,
    required Color color,
    required ThemeData theme,
  }) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 18, color: color),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  count.toString(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onBackground,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Type filter
          const SizedBox(height: 8),
          // Status filter
          SizedBox(
            height: 40,
            child: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Centers the chips
                  children: [
                    _buildStatusChip('Active', Icons.check_circle, Colors.red),
                    const SizedBox(width: 8),
                    _buildStatusChip('Expired', Icons.history, Colors.red),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 8),

          SizedBox(
            width: 300,
            child: _showSearch
                ? TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search your policy',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _searchQuery = '';
                      _searchController.clear();
                      _showSearch = false; // Hide search on clear
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              autofocus: true,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            )
                : GestureDetector(
              onTap: () {
                setState(() {
                  _showSearch = true;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.search, color: Colors.grey),
                    SizedBox(width: 8),
                    Text('Search your policy', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildStatusChip(String status, IconData icon, Color color) {
    final isSelected = _selectedStatus == status;
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: isSelected ? Colors.white : color),
          const SizedBox(width: 6),
          Text(status),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) => setState(() => _selectedStatus = status),
      selectedColor: color,
      backgroundColor: color.withOpacity(0.1),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : null,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      showCheckmark: false,
    );
  }

  Widget _buildTypeChip(String type) {
    final isSelected = _selectedFilter == type;
    return FilterChip(
      label: Text(type),
      selected: isSelected,
      onSelected: (selected) => setState(() => _selectedFilter = selected ? type : 'All'),
      showCheckmark: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : null,
      ),
      selectedColor: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
    );
  }

  Widget _buildPolicyList(ThemeData theme) {
    final filteredPolicies = _policies.where((policy) {
      final typeMatch = _selectedFilter == 'All' || policy.type == _selectedFilter;
      final statusMatch = policy.status == _selectedStatus;
      final searchMatch = _searchQuery.isEmpty ||
          policy.id.toLowerCase().contains(_searchQuery) ||
          policy.provider.toLowerCase().contains(_searchQuery) ||
          policy.type.toLowerCase().contains(_searchQuery) ||
          (_searchQuery.contains('expir') && policy.status == 'Expired') ||
          (_searchQuery.contains('activ') && policy.status == 'Active') ||
          (policy.type == 'Auto' &&
              policy.vehicle?.toLowerCase().contains(_searchQuery) == true) ||
          (policy.type == 'Health' &&
              '${policy.members} people'.toLowerCase().contains(_searchQuery)) ||
          (policy.type == 'Home' &&
              policy.address?.toLowerCase().contains(_searchQuery) == true) ||
          (policy.type == 'Life' &&
              policy.beneficiary?.toLowerCase().contains(_searchQuery) == true);

      return typeMatch && statusMatch && searchMatch;
    }).toList();

    if (filteredPolicies.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment_outlined,
              size: 48,
              color: theme.colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No policies found',
              style: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your filters or search',
              style: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.4),
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      itemCount: filteredPolicies.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return _buildPolicyCard(filteredPolicies[index], theme);
      },
    );
  }

  Widget _buildPolicyCard(Policy policy, ThemeData theme) {
    final daysRemaining = policy.endDate.difference(DateTime.now()).inDays;
    final isActive = policy.status == 'Active';
    final isExpiringSoon = isActive && daysRemaining <= 30;
    final policyColor = _getPolicyTypeColor(policy.type);


    return Padding(
        padding: const EdgeInsets.only(top: 24),
      child: InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => _showPolicyDetails(policy),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.5),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: policyColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Icon(
                      _getPolicyTypeIcon(policy.type),
                      size: 24,
                      color: policyColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          policy.provider,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          policy.type,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isActive
                          ? Colors.green.withOpacity(0.1)
                          : Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      policy.status,
                      style: TextStyle(
                        color: isActive ? Colors.green : Colors.orange,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: theme.dividerColor.withOpacity(0.1),
            ),
            // Details section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Policy details in a grid layout

                  const SizedBox(height: 12),
                  // Expiring soon warning
                  if (isExpiringSoon) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.orange.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.warning_amber_rounded,
                              size: 16, color: Colors.orange),
                          const SizedBox(width: 8),
                          Text(
                            'Expires in $daysRemaining days',
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _viewPolicyDocument(policy.documentUrl),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(
                            color: theme.colorScheme.outline.withOpacity(0.3)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('View Document'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => _renewPolicy(policy),
                      style: FilledButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        policy.status == 'Active' ? 'Renew' : 'Renew Now',
                        style: TextStyle(color: theme.colorScheme.onPrimary),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildPolicyDetail({
    required String label,
    required String value,
    required ThemeData theme,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onBackground,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: valueColor ?? Colors.black,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getPolicyTypeIcon(String type) {
    switch (type) {
      case 'Auto':
        return Icons.directions_car_filled;
      case 'Health':
        return Icons.medical_services;
      case 'Home':
        return Icons.house;
      case 'Life':
        return Icons.favorite;
      default:
        return Icons.description;
    }
  }

  Color _getPolicyTypeColor(String type) {
    switch (type) {
      case 'Auto':
        return Colors.red;
      case 'Health':
        return Colors.red;
      case 'Home':
        return Colors.red;
      case 'Life':
        return Colors.red;
      default:
        return Colors.red;
    }
  }



  void _showPolicyDetails(Policy policy) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Header row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Policy Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Policy details rows
              _buildDetailRow('Policy Number', policy.id),
              _buildDetailRow('Type', policy.type),
              _buildDetailRow('Provider', policy.provider),
              _buildDetailRow(
                'Status',
                policy.status,
                valueColor: policy.status == 'Active' ? Colors.green : Colors.orange,
              ),
              _buildDetailRow(
                'Premium',
                'TZS ${policy.premium.toStringAsFixed(2)}',
              ),
              _buildDetailRow(
                'Start Date',
                DateFormat('MMM dd, yyyy').format(policy.startDate),
              ),
              _buildDetailRow(
                'End Date',
                DateFormat('MMM dd, yyyy').format(policy.endDate),
              ),

              // Type-specific details
              if (policy.type == 'Auto') ...[
                _buildDetailRow('Coverage', policy.coverage),
                _buildDetailRow('Vehicle', policy.vehicle!),
              ],
              if (policy.type == 'Health') ...[
                _buildDetailRow('Coverage', policy.coverage),
                _buildDetailRow('Members', '${policy.members} people'),
              ],
              if (policy.type == 'Home') ...[
                _buildDetailRow('Coverage', policy.coverage),
                _buildDetailRow('Address', policy.address!),
              ],
              if (policy.type == 'Life') ...[
                _buildDetailRow('Coverage', policy.coverage),
                _buildDetailRow('Beneficiary', policy.beneficiary!),
              ],

              const SizedBox(height: 24),

              // Action button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: Icon(Icons.picture_as_pdf, color: Colors.white),
                  label: Text(
                    'View Document',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _viewPolicyDocument(policy.documentUrl);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
  Future<void> _viewPolicyDocument(String url) async {
    try {
      if (!await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      )) {
        throw 'Could not launch URL';
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _renewPolicy(Policy policy) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Renew ${policy.type} Policy',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Text('Policy No: ${policy.id}'),
                const SizedBox(height: 8),
                const Text('Select renewal duration:'),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [1, 2, 3].map((years) {
                    return ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _confirmRenewal(policy, years);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                      child: Text('$years Year${years > 1 ? 's' : ''}'),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmRenewal(Policy policy, int years) {
    final newEndDate = DateTime(
      policy.endDate.year + years,
      policy.endDate.month,
      policy.endDate.day,
    );

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Confirm Renewal',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Text('Policy: ${policy.type} (${policy.id})'),
                const SizedBox(height: 8),
                Text('Provider: ${policy.provider}'),
                const SizedBox(height: 8),
                Text(
                    'New End Date: ${DateFormat('MMM dd, yyyy').format(newEndDate)}'),
                const SizedBox(height: 16),
                const Text('Your payment will be processed automatically.'),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Back'),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                '${policy.type} policy renewed for $years year${years > 1 ? 's' : ''}'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                      child: const Text('Confirm'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class Policy {
  final String id;
  final String type;
  final String provider;
  final DateTime startDate;
  final DateTime endDate;
  final double premium;
  final String status;
  final String documentUrl;
  final String coverage;

  // Auto-specific
  final String? vehicle;

  // Health-specific
  final int? members;

  // Home-specific
  final String? address;

  // Life-specific
  final String? beneficiary;

  Policy({
    required this.id,
    required this.type,
    required this.provider,
    required this.startDate,
    required this.endDate,
    required this.premium,
    required this.status,
    required this.documentUrl,
    required this.coverage,
    this.vehicle,
    this.members,
    this.address,
    this.beneficiary,
  });
}