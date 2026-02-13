import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:resumate/mock_auth_service.dart';

class EditProfilePage extends StatefulWidget {
  final void Function() onImageUpload;

  const EditProfilePage({super.key, required this.onImageUpload});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController nameController;
  late TextEditingController titleController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController locationController;

  String uid = "";

  @override
  void initState() {
    super.initState();
    uid = MockAuthService.currentUserEmail();
    _loadUserData();

    nameController = TextEditingController();
    titleController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    locationController = TextEditingController();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nameController.text = prefs.getString('name_$uid') ?? '';
      titleController.text = prefs.getString('title_$uid') ?? '';
      emailController.text = prefs.getString('email_$uid') ?? '';
      phoneController.text = prefs.getString('phone_$uid') ?? '';
      locationController.text = prefs.getString('location_$uid') ?? '';
    });
  }

  Future<void> saveChanges() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name_$uid', nameController.text);
    await prefs.setString('title_$uid', titleController.text);
    await prefs.setString('email_$uid', emailController.text);
    await prefs.setString('phone_$uid', phoneController.text);
    await prefs.setString('location_$uid', locationController.text);

    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  Widget buildField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 0, 58, 134),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Center(
              child: TextButton.icon(
                onPressed: widget.onImageUpload,
                icon: const Icon(Icons.image),
                label: const Text("Change Profile Picture"),
              ),
            ),
            const SizedBox(height: 10),
            buildField('Name', nameController),
            buildField('Title', titleController),
            buildField('Email', emailController),
            buildField('Phone', phoneController),
            buildField('Location', locationController),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveChanges,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 0, 58, 134),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Save Changes',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
