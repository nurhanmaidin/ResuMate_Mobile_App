import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:resumate/screens/ai_interviewer_page.dart';
import 'package:resumate/screens/welcome_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'ResuMate',
          theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Poppins'),
          home: const WelcomePage(),
          routes: {'/resume-generator': (context) => const AIInterviewerPage()},
        );
      },
    );
  }
}
