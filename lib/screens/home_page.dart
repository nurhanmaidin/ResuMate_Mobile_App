import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'buy_template_page.dart';
import 'profile_page.dart';
import 'saved_templates_page.dart';
import 'ai_interviewer_page.dart';
import 'package:resumate/mock_auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedCategory = 'Most Viewed';
  String searchQuery = '';
  FocusNode searchFocus = FocusNode();
  String userName = 'User';

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

  List<Map<String, String>> get filteredTemplates {
    if (searchQuery.isNotEmpty) {
      return templates
          .where(
            (template) => template['title']!.toLowerCase().contains(
              searchQuery.toLowerCase(),
            ),
          )
          .toList();
    }
    return templates
        .where((template) => template['category'] == selectedCategory)
        .toList();
  }

  @override
  void initState() {
    super.initState();
    fetchUserName();
  }

  Future<void> fetchUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = MockAuthService.currentUserEmail();

    setState(() {
      userName = prefs.getString('name_$uid') ?? 'User';
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Hi, $userName 👋",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ProfilePage(),
                          ),
                        ).then(
                          (_) => fetchUserName(),
                        ); // reload name after profile edit
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.grey[300],
                        child: const Icon(Icons.person, color: Colors.black),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  "Build Your Perfect Resume",
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                const SizedBox(height: 20),

                // Search Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Colors.grey),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          focusNode: searchFocus,
                          onChanged: (value) {
                            setState(() {
                              searchQuery = value;
                            });
                          },
                          decoration: const InputDecoration(
                            hintText: "Search Templates",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const Icon(Icons.filter_list, color: Colors.grey),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                const Text(
                  "Resume Templates",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),

                // Category Tabs
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: ['Most Viewed', 'Professional', 'Creative'].map((
                    category,
                  ) {
                    final isSelected = category == selectedCategory;
                    return GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        setState(() {
                          selectedCategory = category;
                          searchQuery = '';
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.black : Colors.grey[200],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          category,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : Colors.grey.shade800,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 20),

                // Resume List
                Expanded(
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: filteredTemplates.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 16),
                    itemBuilder: (context, index) {
                      final template = filteredTemplates[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BuyTemplatePage(
                                title: template['title']!,
                                author: template['author']!,
                                price: double.parse(
                                  template['price']!.replaceAll('RM ', ''),
                                ),
                                imagePath: template['image']!,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: 220,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(166, 255, 255, 255),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                ),
                                child: Image.asset(
                                  template['image']!,
                                  height: 320,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                child: Text(
                                  template['title']!,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: Text(
                                  "By ${template['author']} • ${template['price']}",
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),

        // Bottom Navigation
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          onTap: (index) {
            if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SavedTemplatesPage()),
              );
            } else if (index == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AIInterviewerPage()),
              );
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_border),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.smart_toy_outlined),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
