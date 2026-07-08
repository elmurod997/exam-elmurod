import 'package:flutter/material.dart';
import 'package:flutter_application_1/background/auth_background.dart';
import 'package:flutter_application_1/home/screens/home_screen.dart';

class GenrePreferencesScreen extends StatefulWidget {
  const GenrePreferencesScreen({super.key});

  @override
  State<GenrePreferencesScreen> createState() => _GenrePreferencesScreenState();
}

class _GenrePreferencesScreenState extends State<GenrePreferencesScreen> {
  final List<Map<String, dynamic>> _genres = [
    {'name': 'Fiction', 'selected': true},
    {'name': 'Novel', 'selected': false},
    {'name': 'Narrative', 'selected': false},
    {'name': 'Historical Fiction', 'selected': false},
    {'name': 'Non-fiction', 'selected': false},
    {'name': 'Mystery', 'selected': false},
    {'name': 'Horror', 'selected': false},
    {'name': 'Children\'s Literature', 'selected': false},
    {'name': 'Thriller', 'selected': true},
    {'name': 'Sci-Fi', 'selected': true},
    {'name': 'Romantic', 'selected': false},
    {'name': 'History', 'selected': false},
    {'name': 'Poetry', 'selected': false},
    {'name': 'Biography', 'selected': false},
    {'name': 'Crime', 'selected': false},
    {'name': 'Autobiography', 'selected': false},
    {'name': 'Cookbook', 'selected': false},
  ];

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            const Text('Select Genres', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Select the type of book you enjoy reading.', style: TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 10,
                  runSpacing: 12,
                  children: _genres.map((genre) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          genre['selected'] = !genre['selected'];
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: genre['selected'] ? const Color(0xFFD2E8BE) : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: genre['selected'] ? const Color(0xFFD2E8BE) : Colors.grey.shade800),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              genre['name'],
                              style: TextStyle(color: genre['selected'] ? Colors.black : Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(width: 6),
                            Icon(
                              genre['selected'] ? Icons.check_circle : Icons.add_circle_outline,
                              color: genre['selected'] ? Colors.black : Colors.grey,
                              size: 16,
                            )
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
           const Center(
              child: Text('Show more', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 14)),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD2E8BE),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
                child: const Text('Continue', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 12),
            const Center(
              child: Text('Select 3 or more genres to continue', style: TextStyle(color: Colors.grey, fontSize: 12)),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
