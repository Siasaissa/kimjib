import 'package:flutter/material.dart';

class InsurancePage extends StatefulWidget {
  const InsurancePage({super.key});

  @override
  State<InsurancePage> createState() => _InsurancePageState();
}

class _InsurancePageState extends State<InsurancePage> {
  List<Map<String, String>> fullData = [
    {"Name": "Ahmed Siasa", "Policy": "Life", "Amount": "Tzs 150"},
    {"Name": "Siasa Issa", "Policy": "Health", "Amount": "Tzs 200"},
    {"Name": "Dope Master", "Policy": "Car", "Amount": "Tzs 180"},
    {"Name": "Dope Master", "Policy": "Car", "Amount": "Tzs 180"},
    {"Name": "Dope Master", "Policy": "Car", "Amount": "Tzs 180"},

  ];

  List<Map<String, String>> filteredData = [];
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredData = List.from(fullData);
  }

  void filterTable(String query) {
    setState(() {
      filteredData = fullData
          .where((item) => item.values.any(
              (value) => value.toLowerCase().contains(query.toLowerCase())))
          .toList();
    });
  }

  void deleteRow(int index) {
    setState(() {
      fullData.removeAt(index);
      filterTable(searchController.text);
    });
  }

  void showAddDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Add Insurance",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
              ),
              const SizedBox(height: 20),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Policy',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.save, color: Colors.white,),
                label: const Text("Save Record", style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Color getPolicyColor(String policy) {
    switch (policy.toLowerCase()) {
      case "life":
        return Colors.red;
      case "health":
        return Colors.green;
      case "car":
        return Colors.blue;
      case "home":
        return Colors.orange;
      case "travel":
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  Widget buildInsuranceCard(Map<String, String> item, int index) {
    final policyColor = getPolicyColor(item['Policy']!);
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? Colors.white10
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.brightness == Brightness.dark
                ? Colors.black26
                : Colors.grey.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 0),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: Name & amount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  item["Name"]!,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              Text(
                item["Amount"]!,
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Policy badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: policyColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Text(
              item["Policy"]!,
              style: TextStyle(
                color: policyColor,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                color: Colors.blue,
                tooltip: 'Edit',
                onPressed: () => print("Edit ${item['Name']}"),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                color: Colors.red,
                tooltip: 'Delete',
                onPressed: () => deleteRow(index),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Insurance', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.red,
        elevation: 0.5,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: showAddDialog,
        label: const Text("Add"),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          children: [
            // Search
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search name, policy or amount...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: theme.cardColor,
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none),
              ),
              onChanged: filterTable,
            ),
            const SizedBox(height: 10),

            // List
            Expanded(
              child: filteredData.isEmpty
                  ? Center(
                child: Text(
                  'No insurance records found.',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 16,
                  ),
                ),
              )
                  : ListView.builder(
                itemCount: filteredData.length,
                itemBuilder: (context, index) {
                  return buildInsuranceCard(filteredData[index], index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
