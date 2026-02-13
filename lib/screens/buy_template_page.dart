import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:resumate/screens/template_info_page.dart';
import 'package:resumate/screens/template_preview_page.dart';
import 'package:resumate/screens/models/saved_templates_model.dart';

class BuyTemplatePage extends StatefulWidget {
  final String title;
  final String author;
  final double price;
  final String imagePath;

  const BuyTemplatePage({
    super.key,
    required this.title,
    required this.author,
    required this.price,
    required this.imagePath,
  });

  @override
  State<BuyTemplatePage> createState() => _BuyTemplatePageState();
}

class _BuyTemplatePageState extends State<BuyTemplatePage> {
  bool isSaved = false;

  final List<Map<String, String>> templates = [
    {
      'title': 'Artistic Resume',
      'author': 'Nurhan Marshall',
      'price': 'RM 15',
      'image': 'assets/images/resume1.png',
      'category': 'Creative',
      'docx': 'assets/docs/resume1.docx',
      'description':
          'A timeless layout perfect for traditional corporate roles and formal industries.',
    },
    {
      'title': 'Stylish Resume',
      'author': 'Nurhan Marshall',
      'price': 'RM 10',
      'image': 'assets/images/resume2.png',
      'category': 'Most Viewed',
      'docx': 'assets/docs/resume2.docx',
      'description':
          'A clean and structured format ideal for modern professionals and tech-savvy candidates.',
    },
    {
      'title': 'Professional Resume',
      'author': 'Nurhan Marshall',
      'price': 'RM 8',
      'image': 'assets/images/resume3.png',
      'category': 'Professional',
      'docx': 'assets/docs/resume3.docx',
      'description':
          'A refined and stylish design tailored for premium positions in creative industries.',
    },
    {
      'title': 'Creative Resume',
      'author': 'Nurhan Marshall',
      'price': 'RM 15',
      'image': 'assets/images/resume4.png',
      'category': 'Creative',
      'docx': 'assets/docs/resume4.docx',
      'description':
          'A simple, distraction-free template that focuses purely on skills and experience.',
    },
    {
      'title': 'Modern Resume',
      'author': 'Nurhan Marshall',
      'price': 'RM 9',
      'image': 'assets/images/resume5.png',
      'category': 'Professional',
      'docx': 'assets/docs/resume5.docx',
      'description':
          'A visually striking layout designed for designers, artists, and creative thinkers.',
    },
    {
      'title': 'Simple Resume',
      'author': 'Nurhan Marshall',
      'price': 'RM 10',
      'image': 'assets/images/resume6.png',
      'category': 'Most Viewed',
      'docx': 'assets/docs/resume6.docx',
      'description':
          'A balanced design with formal elements suitable for all job levels and industries.',
    },
  ];

  String getTemplateField(String title, String field) {
    return templates.firstWhere((t) => t['title'] == title)[field]!;
  }

  Future<void> _saveTemplateToLocal() async {
    final description = getTemplateField(widget.title, 'description');
    final date = DateFormat('dd MMM yyyy').format(DateTime.now());

    final templateData = {
      'title': widget.title,
      'author': widget.author,
      'price': widget.price.toString(),
      'image': widget.imagePath,
      'description': description,
      'date': date,
    };

    final success = await SavedTemplatesModel.addTemplate(templateData);

    if (success) {
      setState(() => isSaved = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Template saved to your list!')),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Template already saved.')));
    }
  }

  void _showQRPaymentPopup() {
    _showReceiptPopup();
  }

  void _showReceiptPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: const Text("Payment Receipt"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.receipt_long, size: 50, color: Colors.green),
              const SizedBox(height: 12),
              const Text(
                "Payment Successful!",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(widget.title, style: const TextStyle(fontSize: 16)),
              Text("Amount Paid: RM ${widget.price.toStringAsFixed(2)}"),
              const SizedBox(height: 16),
              const Divider(),
              const Text("You can now edit your resume."),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TemplateInfoPage(
                      title: widget.title,
                      description: getTemplateField(
                        widget.title,
                        'description',
                      ),
                      imagePath: widget.imagePath,
                      docxAssetPath: getTemplateField(widget.title, 'docx'),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              child: const Text(
                "Edit Resume",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Buy Resume Template"),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 0, 58, 134),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(
              isSaved ? Icons.favorite : Icons.favorite_border,
              color: isSaved ? Colors.red : Colors.white,
            ),
            onPressed: _saveTemplateToLocal,
            tooltip: 'Save Template',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TemplatePreviewPage(
                        imagePath: widget.imagePath,
                        title: widget.title,
                      ),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    widget.imagePath,
                    height: 280,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              "by ${widget.author}",
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Text(
              "Price: RM ${widget.price.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(
                  (Icons.shopping_cart_checkout),
                  color: Colors.white,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 14,
                  ),
                ),
                onPressed: _showQRPaymentPopup,
                label: const Text(
                  "Buy Template",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
