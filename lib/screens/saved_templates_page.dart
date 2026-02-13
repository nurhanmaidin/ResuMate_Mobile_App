import 'package:flutter/material.dart';
import 'package:resumate/screens/models/saved_templates_model.dart';
import 'buy_template_page.dart';

class SavedTemplatesPage extends StatefulWidget {
  const SavedTemplatesPage({super.key});

  @override
  State<SavedTemplatesPage> createState() => _SavedTemplatesPageState();
}

class _SavedTemplatesPageState extends State<SavedTemplatesPage> {
  @override
  void initState() {
    super.initState();
    _loadTemplates();
  }

  Future<void> _loadTemplates() async {
    await SavedTemplatesModel.loadFromPrefs();
    setState(() {});
  }

  void removeTemplate(int index) async {
    SavedTemplatesModel.removeTemplate(index);
    await SavedTemplatesModel.saveToPrefs();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final savedTemplates = SavedTemplatesModel.all;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 0, 58, 134),
        elevation: 0,
        title: const Text(
          ('Saved Templates'),
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            color: Color.fromARGB(255, 0, 58, 134),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: const Text(
              'Your collection of resume designs saved here',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: savedTemplates.isEmpty
                ? const Center(
                    child: Text(
                      "No templates saved yet.",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: savedTemplates.length,
                    itemBuilder: (context, index) {
                      final template = savedTemplates[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BuyTemplatePage(
                                imagePath: template['image'] ?? '',
                                title: template['title'] ?? '',
                                author: template['author'] ?? 'Unknown',
                                price:
                                    double.tryParse(template['price'] ?? '0') ??
                                    0.0,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.asset(
                                    template['image'] ?? '',
                                    width: 80,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        template['title'] ?? '',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(
                                            255,
                                            0,
                                            58,
                                            134,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        template['description'] ?? '',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Last edited: ${template['date'] ?? ''}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.redAccent,
                                  ),
                                  onPressed: () => removeTemplate(index),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
