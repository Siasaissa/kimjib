import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatelessWidget {
  final List<Map<String, String>> terms = [
    {
      'title': '1. Agreement',
      'content':
      'By using this app, you agree to comply with the terms and conditions set forth herein. These terms govern your use of all services provided.'
    },
    {
      'title': '2. User Responsibilities',
      'content':
      'You are responsible for maintaining the confidentiality of your account information and for all activities that occur under your account.'
    },
    {
      'title': '3. Commission & Payouts',
      'content':
      'Commissions are subject to verification and approval. Payouts are processed monthly or upon request, depending on eligibility.'
    },
    {
      'title': '4. Data Privacy',
      'content':
      'We ensure your personal data is stored securely and used in accordance with our privacy policy. We do not sell or share your data.'
    },
    {
      'title': '5. Termination',
      'content':
      'We reserve the right to suspend or terminate your access to the app if any terms are violated or misuse is detected.'
    },
    {
      'title': '6. Modifications',
      'content':
      'We may update these terms periodically. Continued use of the app after changes indicates your acceptance of the revised terms.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Terms & Conditions', style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: terms.length,
        itemBuilder: (context, index) {
          final term = terms[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(term['title']!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red)),
                SizedBox(height: 6),
                Text(term['content']!, style: TextStyle(fontSize: 14, color: Colors.grey[800], height: 1.6)),
              ],
            ),
          );
        },
      ),
    );
  }
}
