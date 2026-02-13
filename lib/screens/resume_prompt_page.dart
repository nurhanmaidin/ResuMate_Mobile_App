import 'package:flutter/material.dart';

class ResumePromptPage extends StatefulWidget {
  const ResumePromptPage({super.key});

  @override
  State<ResumePromptPage> createState() => _ResumePromptPageState();
}

class _ResumePromptPageState extends State<ResumePromptPage> {
  final TextEditingController jobTitleController = TextEditingController();
  final TextEditingController skillsController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();

  bool isLoading = false;
  Map<String, dynamic>? generatedResume;

  Future<void> generateResume() async {
    final job = jobTitleController.text.trim();
    final skills = skillsController.text.trim();
    final exp = experienceController.text.trim();

    if (job.isEmpty || skills.isEmpty || exp.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    setState(() {
      isLoading = true;
      generatedResume = null;
    });

    await Future.delayed(const Duration(seconds: 2));

    final fakeResume = {"name": "AI_Generated_Resume.docx", "url": "demo"};

    setState(() {
      generatedResume = fakeResume;
      isLoading = false;
    });
  }

  Future<void> downloadAndOpen(String fileName, String url) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Demo mode: file download simulated.")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Resume Generator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Job Title'),
            TextField(
              controller: jobTitleController,
              decoration: const InputDecoration(
                hintText: 'e.g., Software Developer',
              ),
            ),
            const SizedBox(height: 20),
            const Text('Skills'),
            TextField(
              controller: skillsController,
              decoration: const InputDecoration(
                hintText: 'e.g., Python, Java, Flutter',
              ),
            ),
            const SizedBox(height: 20),
            const Text('Experience Summary'),
            TextField(
              controller: experienceController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Brief summary of your experience',
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                onPressed: isLoading ? null : generateResume,
                icon: const Icon(Icons.auto_awesome),
                label: Text(isLoading ? 'Generating...' : 'Generate Resume'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            if (generatedResume != null)
              const Text(
                'Generated Resume',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            if (generatedResume != null)
              Card(
                child: ListTile(
                  title: Text(generatedResume!['name']),
                  trailing: IconButton(
                    icon: const Icon(Icons.download),
                    onPressed: () => downloadAndOpen(
                      generatedResume!['name'],
                      generatedResume!['url'],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
