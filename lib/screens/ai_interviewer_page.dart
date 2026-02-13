import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'resume_prompt_page.dart';

class AIInterviewerPage extends StatefulWidget {
  final bool showCompletionMessage;

  const AIInterviewerPage({Key? key, this.showCompletionMessage = false})
    : super(key: key);

  @override
  State<AIInterviewerPage> createState() => _AIInterviewerPageState();
}

class _AIInterviewerPageState extends State<AIInterviewerPage> {
  File? resumeFile;
  String aiQuestion = '';
  String currentAnswer = '';
  bool isLoading = false;
  bool awaitingAnswer = false;
  int questionCount = 0;
  final int maxQuestions = 3;
  final List<Map<String, String>> qaHistory = [];

  /* ---------------- Extract Resume Text ---------------- */
  Future<String> _extractTextFromPDF(File file) async {
    final bytes = await file.readAsBytes();
    final doc = PdfDocument(inputBytes: bytes);
    String text = '';
    for (var i = 0; i < doc.pages.count; i++) {
      text +=
          PdfTextExtractor(
            doc,
          ).extractText(startPageIndex: i, endPageIndex: i) ??
          '';
    }
    doc.dispose();
    return text;
  }

  /* ----------------- Mock AI ------------------ */
  Future<String> _mockAIQuestion({bool followUp = false}) async {
    await Future.delayed(const Duration(seconds: 2));

    final starter = [
      "Can you explain one project from your resume?",
      "What is your strongest technical skill?",
      "Describe a challenge you solved.",
      "Why are you a good fit for this role?",
    ];

    final follow = [
      "Interesting. Can you go deeper?",
      "What tools did you use?",
      "What would you improve next time?",
      "How did your team react?",
    ];

    final list = followUp ? follow : starter;
    list.shuffle();
    return list.first;
  }

  /* ---------------- Resume Picker -------------------- */
  Future<void> _pickResume() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        resumeFile = File(result.files.single.path!);
        aiQuestion = '';
        qaHistory.clear();
        questionCount = 0;
      });
    }
  }

  /* ---------------- Start Interview ------------------ */
  Future<void> _startInterview() async {
    if (resumeFile == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Upload a resume first')));
      return;
    }

    setState(() {
      isLoading = true;
      aiQuestion = '';
      qaHistory.clear();
      questionCount = 0;
    });

    try {
      final firstQ = await _mockAIQuestion();

      qaHistory.add({'q': firstQ, 'a': ''});
      aiQuestion = firstQ;
      awaitingAnswer = true;
      currentAnswer = '';
      questionCount = 1;
      isLoading = false;
      setState(() {});
    } catch (e) {
      setState(() {
        aiQuestion = '❌ Error: $e';
        isLoading = false;
      });
    }
  }

  /* ------------- Submit User Answer ------------------ */
  Future<void> _submitAnswer() async {
    if (currentAnswer.trim().isEmpty) return;

    qaHistory.last['a'] = currentAnswer.trim();
    awaitingAnswer = false;
    isLoading = true;
    setState(() {});

    try {
      final transcript = qaHistory
          .map((e) => 'Q: ${e['q']}\nA: ${e['a']}')
          .join('\n');
      final prompt =
          'Continue this interview. Based on the conversation, ask ONE short follow-up question:\n$transcript';
      final nextQ = await _mockAIQuestion(followUp: true);

      questionCount++;
      if (questionCount <= maxQuestions) {
        qaHistory.add({'q': nextQ, 'a': ''});
        aiQuestion = nextQ;
        awaitingAnswer = true;
        currentAnswer = '';
        isLoading = false;
        setState(() {});
      } else {
        aiQuestion = '✅ Interview complete. Thank you!';
        isLoading = false;
        setState(() {});
      }
    } catch (e) {
      setState(() {
        aiQuestion = '❌ Error: $e';
        isLoading = false;
      });
    }
  }

  /* ---------------- UI Builder ------------------------ */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: const Text('AI Interviewer'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 0, 58, 134),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Upload your resume and step into a live interview with an AI hiring boss.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: _pickResume,
              icon: const Icon((Icons.upload_file), color: Colors.white),
              label: const Text(
                ('Upload Resume (PDF)'),
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
            ),

            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ResumePromptPage()),
                );
              },
              icon: const Icon((Icons.auto_fix_high), color: Colors.white),
              label: const Text(
                'Generate Resume with AI',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
              ),
            ),

            if (resumeFile != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Selected: ${resumeFile!.path.split('/').last}',
                  style: const TextStyle(color: Colors.green),
                ),
              ),
            const SizedBox(height: 20),

            if (!awaitingAnswer)
              ElevatedButton(
                onPressed: isLoading ? null : _startInterview,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Start Interview',
                        style: TextStyle(color: Colors.white),
                      ),
              ),

            if (aiQuestion.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(top: 30),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 80,
                      backgroundImage: AssetImage('assets/images/boss.png'),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(aiQuestion),
                    ),
                  ],
                ),
              ),

            if (isLoading) liveTypingIndicator(),

            if (awaitingAnswer) ...[
              const SizedBox(height: 20),
              TextField(
                minLines: 1,
                maxLines: 3,
                onChanged: (v) => currentAnswer = v,
                decoration: InputDecoration(
                  hintText: 'Type your answer...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _submitAnswer,
                  child: isLoading
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Send Answer'),
                ),
              ),
            ],

            if (!awaitingAnswer && qaHistory.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: ElevatedButton.icon(
                  icon: const Icon((Icons.check_circle), color: Colors.white),
                  label: const Text(
                    'Finish Interview',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AIInterviewerPage(),
                      ),
                    );

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Thank You, The Interview Completed'),
                          duration: Duration(seconds: 3),
                        ),
                      );
                    });
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/* ---------------- ChatGPT-style Typing Dots ---------------- */
Widget liveTypingIndicator() {
  return Row(
    children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        margin: const EdgeInsets.only(top: 16),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Dot(),
            SizedBox(width: 4),
            Dot(delay: Duration(milliseconds: 200)),
            SizedBox(width: 4),
            Dot(delay: Duration(milliseconds: 400)),
          ],
        ),
      ),
    ],
  );
}

class Dot extends StatefulWidget {
  final Duration delay;
  const Dot({this.delay = Duration.zero, super.key});

  @override
  State<Dot> createState() => _DotState();
}

class _DotState extends State<Dot> with SingleTickerProviderStateMixin {
  late final AnimationController _ctl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);
  late final Animation<double> _anim = Tween(begin: 0.2, end: 1.0).animate(
    CurvedAnimation(
      parent: _ctl,
      curve: Interval(
        widget.delay.inMilliseconds / 900,
        1.0,
        curve: Curves.easeIn,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _anim,
      child: const CircleAvatar(radius: 5, backgroundColor: Colors.grey),
    );
  }

  @override
  void dispose() {
    _ctl.dispose();
    super.dispose();
  }
}
