import 'package:pdf/pdf.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screenshot/screenshot.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class EditResumePage extends StatefulWidget {
  final String imagePath;
  final String title;

  const EditResumePage({
    super.key,
    required this.imagePath,
    required this.title,
  });

  @override
  State<EditResumePage> createState() => _EditResumePageState();
}

class _EditResumePageState extends State<EditResumePage> {
  final ScreenshotController screenshotController = ScreenshotController();

  late TextEditingController _fullNameController;
  late TextEditingController _contactInfoController;
  late TextEditingController _aboutMeController;
  late TextEditingController _experienceController;
  late TextEditingController _educationController;

  String _fullName = 'Your Name';
  String _contactInfo = 'Email | Phone | LinkedIn';
  String _aboutMe =
      'A passionate and driven individual with a strong foundation in mobile app development using Flutter. Eager to contribute to innovative projects and continuously learn new technologies.';
  String _experience =
      'Software Developer Intern - Tech Solutions Inc. (Jan 2023 - May 2023)\n- Developed cross-platform mobile applications using Flutter.\n- Collaborated with a team of 5 to deliver project milestones on time.\n\nFlutter Developer - Mobile Innovations (Jun 2024 - Present)\n- Led front-end development for a new e-commerce app.\n- Implemented responsive UIs and integrated RESTful APIs.';
  String _education =
      'Bachelor of Computer Science - Universiti Malaya (2020-2024)\n- Dean\'s List (All Semesters)';

  double _skillFlutter = 0.8;
  double _skillFirebase = 0.6;
  double _skillUIDesign = 0.9;

  final TextStyle _nameStyle = GoogleFonts.playfairDisplay(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  final TextStyle _contactStyle = GoogleFonts.poppins(
    fontSize: 13,
    color: Colors.black87,
  );

  final TextStyle _sectionTitleStyle = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  final TextStyle _bodyTextStyle = GoogleFonts.poppins(
    fontSize: 13,
    color: Colors.black87,
    height: 1.5,
  );

  final TextStyle _skillLabelStyle = GoogleFonts.poppins(
    fontSize: 13,
    color: Colors.black87,
  );

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: _fullName);
    _contactInfoController = TextEditingController(text: _contactInfo);
    _aboutMeController = TextEditingController(text: _aboutMe);
    _experienceController = TextEditingController(text: _experience);
    _educationController = TextEditingController(text: _education);

    _fullNameController.addListener(
      () => setState(() => _fullName = _fullNameController.text),
    );
    _contactInfoController.addListener(
      () => setState(() => _contactInfo = _contactInfoController.text),
    );
    _aboutMeController.addListener(
      () => setState(() => _aboutMe = _aboutMeController.text),
    );
    _experienceController.addListener(
      () => setState(() => _experience = _experienceController.text),
    );
    _educationController.addListener(
      () => setState(() => _education = _educationController.text),
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _contactInfoController.dispose();
    _aboutMeController.dispose();
    _experienceController.dispose();
    _educationController.dispose();
    super.dispose();
  }

  /* -------------------- PDF Export -------------------- */
  Future<void> _exportToPDF() async {
    final image = await screenshotController.capture();
    if (image == null) return;

    final doc = pw.Document();
    final img = pw.MemoryImage(image);

    doc.addPage(pw.Page(build: (context) => pw.Center(child: pw.Image(img))));

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
    );
  }

  /* --------------------- UI Builder -------------------- */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Resume"),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: _exportToPDF,
            tooltip: "Export to PDF",
          ),
        ],
      ),
      body: Screenshot(
        controller: screenshotController,
        child: Stack(
          children: [
            Image.asset(
              widget.imagePath,
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),

            SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 80),
                  TextField(
                    controller: _fullNameController,
                    style: _nameStyle,
                    decoration: InputDecoration(
                      hintText: "Your Name",
                      labelText: "Full Name",
                      labelStyle: _nameStyle.copyWith(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    maxLines: 1,
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: _contactInfoController,
                    style: _contactStyle,
                    decoration: InputDecoration(
                      hintText: "Email | Phone | LinkedIn",
                      labelText: "Contact Info",
                      labelStyle: _contactStyle.copyWith(color: Colors.grey),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    maxLines: 1,
                  ),

                  const Divider(height: 32),

                  Text("ABOUT ME", style: _sectionTitleStyle),
                  TextField(
                    controller: _aboutMeController,
                    style: _bodyTextStyle,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: "Brief summary about yourself...",
                      labelText: "About Me",
                      labelStyle: _sectionTitleStyle.copyWith(
                        color: Colors.grey,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),

                  const Divider(height: 32),

                  Text("SKILLS", style: _sectionTitleStyle),
                  Row(
                    children: [
                      Expanded(child: Text("Flutter", style: _skillLabelStyle)),
                      Expanded(
                        flex: 3,
                        child: Slider(
                          value: _skillFlutter,
                          onChanged: (val) =>
                              setState(() => _skillFlutter = val),
                          activeColor: Colors.amber,
                          min: 0.0,
                          max: 1.0,
                          divisions: 10,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text("Firebase", style: _skillLabelStyle),
                      ),
                      Expanded(
                        flex: 3,
                        child: Slider(
                          value: _skillFirebase,
                          onChanged: (val) =>
                              setState(() => _skillFirebase = val),
                          activeColor: Colors.amber,
                          min: 0.0,
                          max: 1.0,
                          divisions: 10,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text("UI Design", style: _skillLabelStyle),
                      ),
                      Expanded(
                        flex: 3,
                        child: Slider(
                          value: _skillUIDesign,
                          onChanged: (val) =>
                              setState(() => _skillUIDesign = val),
                          activeColor: Colors.amber,
                          min: 0.0,
                          max: 1.0,
                          divisions: 10,
                        ),
                      ),
                    ],
                  ),

                  const Divider(height: 32),

                  Text("EXPERIENCE", style: _sectionTitleStyle),
                  TextField(
                    controller: _experienceController,
                    style: _bodyTextStyle,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText:
                          "List your experience details (company, role, responsibilities)...",
                      labelText: "Experience",
                      labelStyle: _sectionTitleStyle.copyWith(
                        color: Colors.grey,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),

                  const Divider(height: 32),

                  Text("EDUCATION", style: _sectionTitleStyle),
                  TextField(
                    controller: _educationController,
                    style: _bodyTextStyle,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText:
                          "Your education details (degree, university, year)...",
                      labelText: "Education",
                      labelStyle: _sectionTitleStyle.copyWith(
                        color: Colors.grey,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),

                  const SizedBox(height: 50),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
