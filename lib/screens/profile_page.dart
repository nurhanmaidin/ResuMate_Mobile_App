import 'dart:io';
import 'package:flutter/material.dart';
import 'package:resumate/screens/about_us_page.dart';
import 'package:resumate/screens/legal_and_support_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_selector/file_selector.dart';
import 'welcome_page.dart';
import 'edit_profile_page.dart';
import 'package:resumate/mock_auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String uid = "";
  String name = '';
  String title = '';
  String email = '';
  String phone = '';
  String location = '';
  bool notificationsEnabled = true;
  File? profileImage;

  @override
  void initState() {
    super.initState();
    uid = MockAuthService.currentUserEmail();
    loadUserData();
    loadProfileImage();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name_$uid') ?? 'Your Name';
      title = prefs.getString('title_$uid') ?? 'Your Title';
      email = prefs.getString('email_$uid') ?? 'example@email.com';
      phone = prefs.getString('phone_$uid') ?? '0123456789';
      location = prefs.getString('location_$uid') ?? 'City, Country';
    });
  }

  Future<void> loadProfileImage() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/profile_pic_$uid.png');
    if (await file.exists()) {
      setState(() => profileImage = file);
    }
  }

  Future<void> pickProfileImage() async {
    final typeGroup = XTypeGroup(
      label: 'images',
      extensions: ['jpg', 'png', 'jpeg'],
    );
    final file = await openFile(acceptedTypeGroups: [typeGroup]);

    if (file != null) {
      final directory = await getApplicationDocumentsDirectory();
      final imageFile = File('${directory.path}/profile_pic_$uid.png');
      await File(file.path).copy(imageFile.path);
      setState(() => profileImage = imageFile);
    }
  }

  void logout() async {
    await MockAuthService.logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const WelcomePage()),
      (route) => false,
    );
  }

  void openEditProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfilePage(onImageUpload: pickProfileImage),
      ),
    );
    if (result == true) {
      loadUserData();
      loadProfileImage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 0, 58, 134),
                Color.fromARGB(255, 0, 99, 192),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 0, 58, 134),
                    Color.fromARGB(255, 0, 99, 192),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: pickProfileImage,
                    child: CircleAvatar(
                      radius: 42,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 38,
                        backgroundImage: profileImage != null
                            ? FileImage(profileImage!)
                            : const AssetImage('assets/profile_pic.jpg')
                                  as ImageProvider,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(title, style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            buildCard(
              title: 'Personal Information',
              children: [
                buildInfoRow('Email', email),
                buildInfoRow('Phone', phone),
                buildInfoRow('Location', location),
              ],
            ),
            const SizedBox(height: 20),
            buildCard(
              title: 'Account Settings',
              children: [
                ListTile(
                  leading: const Icon(Icons.edit, color: Colors.deepPurple),
                  title: const Text('Edit Profile'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: openEditProfile,
                ),
                ListTile(
                  leading: const Icon(Icons.upload_file, color: Colors.teal),
                  title: const Text('Upload Resume'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Resume upload coming soon...'),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.info, color: Colors.blue),
                  title: const Text("About Us"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AboutUsPage()),
                  ),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.article,
                    color: Color.fromARGB(255, 234, 36, 10),
                  ),
                  title: const Text("Legal & Support"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LegalAndSupportPage(),
                    ),
                  ),
                ),
                SwitchListTile(
                  secondary: const Icon(
                    Icons.notifications_active,
                    color: Colors.orange,
                  ),
                  title: const Text('Notifications'),
                  value: notificationsEnabled,
                  onChanged: (val) =>
                      setState(() => notificationsEnabled = val),
                ),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 12,
                ),
              ),
              onPressed: logout,
              child: const Text('Logout'),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget buildCard({required String title, required List<Widget> children}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              ...children,
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.w600)),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.black87)),
          ),
        ],
      ),
    );
  }
}
