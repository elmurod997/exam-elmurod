import 'package:flutter_application_1/auth/book/book_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../auth/book/book_detail_screen.dart';

abstract class LibraryState {}
class LibraryInitial extends LibraryState {}
class LibraryLoading extends LibraryState {}
class LibraryLoaded extends LibraryState {
  final String selectedTab;
  final List<Map<String, String>> books;
  LibraryLoaded({required this.selectedTab, required this.books});
}

class LibraryCubit extends Cubit<LibraryState> {
  LibraryCubit() : super(LibraryInitial());

  final Map<String, List<Map<String, String>>> _mockLibraryData = {
    'Saved Books': [
      {'title': 'The good guy', 'author': 'Mark mcalister', 'image': 'assets/images/rasm1.png', 'audio': '5m', 'read': '8m', 'type': 'saved'},
      {'title': 'Norse mythology', 'author': 'Neil Gaiman', 'image': 'assets/images/rasm4.png', 'audio': '5m', 'read': '8m', 'type': 'saved'},
      {'title': 'Futurama', 'author': 'Michael Douglas Jr', 'image': 'assets/images/rasm2.png', 'audio': '5m', 'read': '8m', 'type': 'saved'},
      {'title': 'Explore your crea...', 'author': 'Royryan Mercado', 'image': 'assets/images/rasm3.png', 'audio': '5m', 'read': '8m', 'type': 'saved'},
    ],
    'In Progress': [
      {'title': 'The good guy', 'author': 'Mark mcalister', 'image': 'assets/images/rasm1.png', 'progress': '65% completed', 'type': 'progress'},
      {'title': 'Norse mythology', 'author': 'Neil Gaiman', 'image': 'assets/images/rasm4.png', 'progress': '45% completed', 'type': 'progress'},
    ],
    'Completed': [
      {'title': 'Futurama', 'author': 'Michael Douglas Jr', 'image': 'assets/images/rasm2.png', 'audio': '5m', 'read': '8m', 'type': 'completed'},
      {'title': 'Explore your crea...', 'author': 'Royryan Mercado', 'image': 'assets/images/rasm3.png', 'audio': '5m', 'read': '8m', 'type': 'completed'},
    ]
  };

  void loadLibrary(String tabName) async {
    emit(LibraryLoading());
    await Future.delayed(const Duration(milliseconds: 150));
    emit(LibraryLoaded(selectedTab: tabName, books: _mockLibraryData[tabName] ?? []));
  }
}


class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LibraryCubit()..loadLibrary('Saved Books'),
      child: Scaffold(
        backgroundColor: const Color(0xFF121212),
        body: BlocBuilder<LibraryCubit, LibraryState>(
          builder: (context, state) {
            return SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'My Library',
                      style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (state is LibraryLoaded)
                    SizedBox(
                      height: 38,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        children: [
                          _buildTabButton(context, 'Saved Books', Icons.bookmark_outline, state.selectedTab),
                          const SizedBox(width: 10),
                          _buildTabButton(context, 'In Progress', Icons.headphones, state.selectedTab),
                          const SizedBox(width: 10),
                          _buildTabButton(context, 'Completed', Icons.check_circle_outline, state.selectedTab),
                        ],
                      ),
                    ),
                  const SizedBox(height: 20),
                  if (state is LibraryLoading)
                    const Expanded(child: Center(child: CircularProgressIndicator(color: Color(0xFFD2E8BE))))
                  else if (state is LibraryLoaded)
                    Expanded(child: _buildBookGrid(context, state.books)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTabButton(BuildContext context, String title, IconData icon, String selectedTab) {
    final isSelected = selectedTab == title;
    return GestureDetector(
      onTap: () => context.read<LibraryCubit>().loadLibrary(title),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFD2E8BE) : const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isSelected ? Colors.black : Colors.white, size: 16),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildBookGrid(BuildContext context, List<Map<String, String>> books) {
    if (books.isEmpty) {
      return const Center(
        child: Text(
          'No books in this section',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.62,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        final isProgress = book['type'] == 'progress';

        return GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => BookDetailScreen(book: book as BookModel))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(book['image']!, width: double.infinity, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                book['title']!,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13, fontStyle: FontStyle.italic),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                book['author']!,
                style: const TextStyle(color: Colors.grey, fontSize: 11),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              if (isProgress)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    book['progress']!,
                    style: const TextStyle(color: Color(0xFFD2E8BE), fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                )
              else
                Row(
                  children: [
                    const Icon(Icons.headphones, color: Colors.grey, size: 12),
                    const SizedBox(width: 2),
                    Text(book['audio']!, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                    const SizedBox(width: 8),
                    const Icon(Icons.menu_book, color: Colors.grey, size: 12),
                    const SizedBox(width: 2),
                    Text(book['read']!, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}
