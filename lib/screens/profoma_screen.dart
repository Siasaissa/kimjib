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
  final List<Policy> _policies = [
    Policy(
      id: 'POL123456',
      type: 'Auto',
      provider: 'Allianz Insurance',
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
      provider: 'BlueCross Shield',
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
      provider: 'StateFarm',
      startDate: DateTime.now().subtract(const Duration(days: 15)),
      endDate: DateTime.now().add(const Duration(days: 350)),
      premium: 1500,
      status: 'Active',
      documentUrl: 'https://example.com/policy3.pdf',
      address: '123 Main St, Boston, MA',
      coverage: 'Full Protection',
    ),
    Policy(
      id: 'POL901234',
      type: 'Life',
      provider: 'Northwestern Mutual',
      startDate: DateTime.now().subtract(const Duration(days: 100)),
      endDate: DateTime.now().add(const Duration(days: 265)),
      premium: 2000,
      status: 'Active',
      documentUrl: 'https://example.com/policy4.pdf',
      coverage: 'Term Life',
      beneficiary: 'Spouse',
    ),
  ];

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


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        title: _searchQuery.isEmpty
            ? const Text('My Policies',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20, color: Colors.white))
            : Text('Searching for "$_searchQuery"',
            style: const TextStyle(fontSize: 16,color: Colors.white)),
        centerTitle: true,
        elevation: 0,
        actions: [
          if (_searchQuery.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.close,color: Colors.white,),
              onPressed: () {
                setState(() {
                  _searchQuery = '';
                  _searchController.clear();
                });
              },
            )
          else
            IconButton(
              icon: const Icon(Icons.search, size: 24,color: Colors.white,),
              onPressed: () => _showSearchDialog(context),
              tooltip: 'Search policies',
            ),
        ],
      ),
      body: Column(
        children: [
          // Stats cards

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
      padding: const EdgeInsets.all(12), // Reduced padding slightly
      margin: const EdgeInsets.only(bottom: 5), // Add bottom margin
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color:Colors.red. withOpacity(0.5),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Better space distribution
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(6), // Smaller padding
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 18, color: color), // Smaller icon
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
                    fontSize: 14, // Smaller font
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13, // Slightly smaller
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface.withOpacity(0.8),
                ),
              ),
              Text(
                '\$${amount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 15, // Adjusted size
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onBackground,
                ),
              ),


            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status filter
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildStatusChip('Active', Icons.check_circle, Colors.green),
                const SizedBox(width: 8),
                _buildStatusChip('Expired', Icons.history, Colors.orange),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Type filter

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
      separatorBuilder: (_, __) => const SizedBox(height: 12),
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
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.2),
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
                // Policy icon
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: policyColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _getPolicyTypeIcon(policy.type),
                    size: 24,
                    color: policyColor,
                  ),
                ),

                const SizedBox(width: 12),

                // Policy info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        policy.provider,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: theme.colorScheme.onBackground,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        policy.type,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                // Status
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

          // Divider
          Divider(
            height: 1,
            thickness: 1,
            color: theme.dividerColor.withOpacity(0.1),
          ),

          // Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Policy details row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildPolicyDetail(
                      label: 'Policy No.',
                      value: policy.id,
                      theme: theme,
                    ),
                    _buildPolicyDetail(
                      label: 'Premium',
                      value: '\$${policy.premium.toStringAsFixed(2)}',
                      theme: theme,
                    ),
                    _buildPolicyDetail(
                      label: 'End Date',
                      value: DateFormat('MMM dd, yyyy').format(policy.endDate),
                      theme: theme,
                    ),
                  ],
                ),

                // Type-specific details
                if (policy.type == 'Auto') ...[
                  const SizedBox(height: 12),
                  _buildPolicyDetail(
                    label: 'Vehicle',
                    value: policy.vehicle!,
                    theme: theme,
                  ),
                ],
                if (policy.type == 'Health') ...[
                  const SizedBox(height: 12),
                  _buildPolicyDetail(
                    label: 'Members',
                    value: '${policy.members} people',
                    theme: theme,
                  ),
                ],
                if (policy.type == 'Home') ...[
                  const SizedBox(height: 12),
                  _buildPolicyDetail(
                    label: 'Address',
                    value: policy.address!,
                    theme: theme,
                  ),
                ],
                if (policy.type == 'Life') ...[
                  const SizedBox(height: 12),
                  _buildPolicyDetail(
                    label: 'Beneficiary',
                    value: policy.beneficiary!,
                    theme: theme,
                  ),
                ],

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
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(policy.status == 'Active' ? 'Renew' : 'Renew Now'),
                  ),
                ),
              ],
            ),
          ),
        ],
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
            fontSize: 11,
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onBackground,
          ),
        ),
      ],
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
        return Colors.blue;
      case 'Health':
        return Colors.pink;
      case 'Home':
        return Colors.green;
      case 'Life':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Search Policies'),
          content: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Search by policy number, provider, or type...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            autofocus: true,
            onChanged: (value) {
              setState(() {
                _searchQuery = value.toLowerCase();
              });
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _searchQuery = '';
                  _searchController.clear();
                });
                Navigator.pop(context);
              },
              child: const Text('Clear'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  void _showPolicyDetails(Policy policy) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).dividerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Policy Details',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildDetailRow('Policy Number', policy.id),
              _buildDetailRow('Type', policy.type),
              _buildDetailRow('Provider', policy.provider),
              _buildDetailRow(
                'Status',
                policy.status,
                valueColor: policy.status == 'Active'
                    ? Colors.green
                    : Colors.orange,
              ),
              _buildDetailRow(
                'Premium',
                '\$${policy.premium.toStringAsFixed(2)}',
              ),
              _buildDetailRow(
                'Start Date',
                DateFormat('MMM dd, yyyy').format(policy.startDate),
              ),
              _buildDetailRow(
                'End Date',
                DateFormat('MMM dd, yyyy').format(policy.endDate),
              ),
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
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      icon: const Icon(Icons.picture_as_pdf),
                      label: const Text('View Document'),
                      onPressed: () {
                        Navigator.pop(context);
                        _viewPolicyDocument(policy.documentUrl);
                      },
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
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

  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: valueColor ?? Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
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
                Text('New End Date: ${DateFormat('MMM dd, yyyy').format(newEndDate)}'),
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
                            content: Text('${policy.type} policy renewed for $years year${years > 1 ? 's' : ''}'),
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