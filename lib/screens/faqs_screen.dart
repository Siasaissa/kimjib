import 'package:flutter/material.dart';

class FAQsPage extends StatelessWidget {
  final List<Map<String, String>> faqs = [
    {
      'question': 'How can I claim my insurance?',
      'answer': 'You can claim your insurance by filling out the claim form under the Downloads page, then submitting it through your profile or at our nearest office.',
    },
    {
      'question': 'How do I track my commission?',
      'answer': 'Go to the Commission page to view your total earned, pending, and paid commissions. You can also see bar charts and detailed reports.',
    },
    {
      'question': 'What is the payout schedule?',
      'answer': 'Payouts are scheduled on the last working day of each month. You can request early payouts through the Payout section.',
    },
    {
      'question': 'How can I change my bank details?',
      'answer': 'Navigate to the Profile page and update your bank information securely. Changes may require verification.',
    },
    {
      'question': 'Is my data secure?',
      'answer': 'Yes, your data is protected with end-to-end encryption and secure authentication protocols.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('FAQs', style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(16),
        itemCount: faqs.length,
        separatorBuilder: (_, __) => SizedBox(height: 10),
        itemBuilder: (context, index) {
          final faq = faqs[index];
          return ExpansionTile(
            collapsedIconColor: Colors.red,
            iconColor: Colors.red,
            tilePadding: EdgeInsets.symmetric(horizontal: 16),
            title: Text(faq['question']!, style: TextStyle(fontWeight: FontWeight.bold)),
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Text(faq['answer']!, style: TextStyle(color: Colors.grey[700], height: 1.4)),
              ),
            ],
          );
        },
      ),
    );
  }
}
