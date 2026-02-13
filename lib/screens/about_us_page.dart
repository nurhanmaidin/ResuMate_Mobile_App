import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About Us"),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 0, 58, 134),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "About ResuMate",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                "ResuMate is a modern, AI-powered resume builder designed to help job seekers create stunning, personalized resumes with ease. "
                "Whether you're a student, a fresh graduate, or an experienced professional, ResuMate offers all the tools you need to present yourself confidently to employers.\n\n"
                "Our platform offers a collection of professionally designed resume templates, categorized into Most Viewed, Creative, and Professional styles. "
                "Each template is carefully crafted and can be previewed, purchased, and edited directly open Microsoft Word. After editing, users can export resumes in PDF format.\n\n"
                "One of ResuMate’s standout features is the AI Interviewer. After uploading your resume, our AI simulates a realistic interview experience by analyzing your resume and asking personalized interview questions — just like a real hiring manager. "
                "This feature helps users practice confidently, improve their responses, and better prepare for real interviews.\n\n"
                "Core Features:\n\n"
                "• Stunning resume templates with categorized browsing\n\n"
                "• In-app preview and purchase system with Malaysian payment flow\n\n"
                "• Resume editing with text and image support on Microsoft Word\n\n"
                "• Save favorite templates to your personal collection\n\n"
                "• Smart AI Interviewer that mimics real interview sessions\n\n"
                "At ResuMate, our mission is to empower every job seeker with professional tools and AI-Interviewer support to succeed in their career journey.",
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
