import 'package:flutter/material.dart';

class LegalAndSupportPage extends StatelessWidget {
  const LegalAndSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> sections = [
      {
        'title': 'Privacy Policy',
        'content':
            'We collect only necessary information to provide a better experience. '
            'All data is stored securely and not shared with third parties.',
      },
      {
        'title': 'Terms of Service',
        'content':
            'By using ResuMate, you agree not to misuse our services. All templates are for personal use only.',
      },
      {
        'title': 'Refund Policy',
        'content':
            'All template purchases are final. However, if you encounter technical issues, please contact our support team.',
      },
      {
        'title': 'Help / FAQ',
        'content':
            'Need help? Contact our support. FAQs include common issues related to saving, editing, and downloading resumes.',
      },
      {
        'title': 'Contact Us',
        'content':
            'Email: nurhanmaidin@gmail.com\nPhone: +60 14 227 6786\n\nWe typically respond within 24 hours.',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Legal & Support"),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 0, 58, 134),
        foregroundColor: Colors.white,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: sections.length,
        separatorBuilder: (_, __) => const Divider(height: 32),
        itemBuilder: (context, index) {
          final section = sections[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                section['title']!,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF004AAD),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                section['content']!,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
            ],
          );
        },
      ),
    );
  }
}
