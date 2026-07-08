import 'package:flutter/material.dart';

class BookDetailChapters extends StatelessWidget {
  final Map<String, dynamic> book;

  const BookDetailChapters({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '56 Chapters',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: (book['chapters'] as List).length,
          itemBuilder: (context, index) {
            final chapter = book['chapters'][index];
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Text(
                    chapter['id'],
                    style: const TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          chapter['title'],
                          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          chapter['subtitle'],
                          style: const TextStyle(color: Colors.grey, fontSize: 11),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  chapter['isLocked']
                      ? Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Color(0xFF1E1E1E),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.lock_outline, color: Colors.grey, size: 16),
                        )
                      : Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Color(0xFFD2E8BE),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.play_arrow, color: Colors.black, size: 16),
                        ),
                ],
              ),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Final Summary',
                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFF1E1E1E),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.lock_outline, color: Colors.grey, size: 16),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1D26),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundImage: AssetImage('assets/images/rasm5.png'),
                backgroundColor: Color(0xFF1E1E1E),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('James wood', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                    SizedBox(height: 2),
                    Text('A FranklinConvey Title', style: TextStyle(color: Colors.grey, fontSize: 11)),
                    SizedBox(height: 8),
                    Text(
                      'Managers who want to create positive work enviroments',
                      style: TextStyle(color: Colors.grey, fontSize: 12, height: 1.3),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Similar Books',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Text('Show all', style: TextStyle(color: Colors.grey.shade400, fontSize: 13)),
                const SizedBox(width: 4),
                Icon(Icons.arrow_circle_right_outlined, color: const Color(0xFFD2E8BE), size: 18),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 225,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _similarBookItem('assets/images/rasm3.png', 'Explore your create..', 'Royryan Mercado'),
              _similarBookItem('assets/images/rasm2.png', 'Futurama', 'Michael Douglas jr.'),
              _similarBookItem('assets/images/rasm1.png', 'The good guy', 'Mark mcalister'),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _similarBookItem(String image, String title, String author) {
    return Container(
      width: 125,
      margin: const EdgeInsets.only(right: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(image, width: 125, height: 160, fit: BoxFit.cover),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12, fontStyle: FontStyle.italic),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            author,
            style: const TextStyle(color: Colors.grey, fontSize: 10),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          const Row(
            children: [
              Icon(Icons.headphones, color: Colors.grey, size: 11),
              SizedBox(width: 2),
              Text('5m', style: TextStyle(color: Colors.grey, fontSize: 10)),
              SizedBox(width: 8),
              Icon(Icons.menu_book, color: Colors.grey, size: 11),
              SizedBox(width: 2),
              Text('5m', style: TextStyle(color: Colors.grey, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }
}
