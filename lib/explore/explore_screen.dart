import 'package:flutter_application_1/auth/book/book_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../auth/book/book_detail_screen.dart';

abstract class ExploreState {}
class ExploreInitial extends ExploreState {}
class ExploreLoading extends ExploreState {}
class ExploreMainLoaded extends ExploreState {
  final List<String> topics;
  final Map<String, List<Map<String, String>>> genreBooks;
  ExploreMainLoaded({required this.topics, required this.genreBooks});
}
class ExploreGenreLoaded extends ExploreState {
  final String genreName;
  final List<Map<String, String>> books;
  ExploreGenreLoaded({required this.genreName, required this.books});
}
class ExploreResultsLoaded extends ExploreState {
  final String query;
  final List<Map<String, String>> results;
  ExploreResultsLoaded({required this.query, required this.results});
}

class ExploreCubit extends Cubit<ExploreState> {
  ExploreCubit() : super(ExploreInitial());

  final List<String> _mockTopics = ['Personal growth', 'Culture & Society', 'Fiction', 'Mind & Philosophy', 'Life style'];
  
  final Map<String, List<Map<String, String>>> _mockData = {
    'Fiction': [
      {'title': 'The good guy', 'author': 'Mark mcalister', 'image': 'assets/images/rasm1.png'},
      {'title': 'Norse mythology', 'author': 'Neil Gaiman', 'image': 'assets/images/rasm4.png'},
      {'title': 'Futurama', 'author': 'Michael Douglas Jr', 'image': 'assets/images/rasm2.png'},
      {'title': 'Explore your crea...', 'author': 'Royryan Mercado', 'image': 'assets/images/rasm3.png'},
    ],
    'Culture & Society': [
      {'title': 'Explore your crea...', 'author': 'Royryan Mercado', 'image': 'assets/images/rasm3.png'},
      {'title': 'Futurama', 'author': 'Michael Douglas Jr', 'image': 'assets/images/rasm2.png'},
    ],
    'Life style': [
      {'title': 'Futurama', 'author': 'Michael Douglas Jr', 'image': 'assets/images/rasm2.png'},
      {'title': 'The good guy', 'author': 'Mark mcalister', 'image': 'assets/images/rasm1.png'},
    ]
  };

  void loadExploreMain() async {
    emit(ExploreLoading());
    await Future.delayed(const Duration(milliseconds: 200));
    emit(ExploreMainLoaded(topics: _mockTopics, genreBooks: _mockData));
  }

  void selectGenre(String genreName) async {
    emit(ExploreLoading());
    await Future.delayed(const Duration(milliseconds: 200));
    emit(ExploreGenreLoaded(genreName: genreName, books: _mockData[genreName] ?? []));
  }

  void searchBooks(String query) async {
    if (query.isEmpty) {
      loadExploreMain();
      return;
    }
    emit(ExploreLoading());
    await Future.delayed(const Duration(milliseconds: 200));
    
    List<Map<String, String>> allBooks = [];
    _mockData.values.forEach((list) => allBooks.addAll(list));
    
    final results = allBooks.where((book) => 
      book['title']!.toLowerCase().contains(query.toLowerCase()) || 
      book['author']!.toLowerCase().contains(query.toLowerCase())
    ).toList();
    
    emit(ExploreResultsLoaded(query: query, results: results));
  }
}


class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();

    return BlocProvider(
      create: (context) => ExploreCubit()..loadExploreMain(),
      child: Scaffold(
        backgroundColor: const Color(0xFF121212),
        body: BlocBuilder<ExploreCubit, ExploreState>(
          builder: (context, state) {
            return SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (state is ExploreGenreLoaded)
                          GestureDetector(
                            onTap: () => context.read<ExploreCubit>().loadExploreMain(),
                            child: const Row(
                              children: [
                                Icon(Icons.arrow_back_ios, color: Colors.white, size: 16),
                                SizedBox(width: 4),
                                Text('Explore', style: TextStyle(color: Colors.white, fontSize: 14)),
                              ],
                            ),
                          )
                        else
                          const Text(
                            'Explore',
                            style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                        const SizedBox(height: 16),
                        Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A1A1A),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            controller: searchController,
                            style: const TextStyle(color: Colors.white),
                            onChanged: (value) => context.read<ExploreCubit>().searchBooks(value),
                            decoration: InputDecoration(
                              hintText: 'Search books, authors, genres...',
                              hintStyle: const TextStyle(color: Color(0xFF666666), fontSize: 14),
                              prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),
                              suffixIcon: searchController.text.isNotEmpty 
                                ? IconButton(
                                    icon: const Icon(Icons.clear, color: Colors.grey, size: 18),
                                    onPressed: () {
                                      searchController.clear();
                                      context.read<ExploreCubit>().loadExploreMain();
                                    },
                                  )
                                : null,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (state is ExploreLoading)
                    const Expanded(child: Center(child: CircularProgressIndicator(color: Color(0xFFD2E8BE))))
                  else if (state is ExploreMainLoaded)
                    Expanded(child: _buildMainExplore(context, state))
                  else if (state is ExploreGenreLoaded)
                    Expanded(child: _buildGenreListing(context, state))
                  else if (state is ExploreResultsLoaded)
                    Expanded(child: _buildSearchResults(context, state)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMainExplore(BuildContext context, ExploreMainLoaded state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Topics', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 10,
            children: state.topics.map((topic) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade800),
                ),
                child: Text(topic, style: const TextStyle(color: Colors.grey, fontSize: 13)),
              );
            }).toList(),
          ),
          const SizedBox(height: 28),
          ...state.genreBooks.keys.map((genre) {
            final books = state.genreBooks[genre]!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(genre, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    GestureDetector(
                      onTap: () => context.read<ExploreCubit>().selectGenre(genre),
                      child: const Row(
                        children: [
                          Text('Show all', style: TextStyle(color: Colors.grey, fontSize: 13)),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 12),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                SizedBox(
                  height: 170,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      final book = books[index];
                      return GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => BookDetailScreen(book: book as BookModel))),
                        child: Container(
                          margin: const EdgeInsets.only(right: 14),
                          width: 100,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(book['image']!, width: 100, height: 130, fit: BoxFit.cover),
                              ),
                              const SizedBox(height: 6),
                              Text(book['title']!, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
              ],
            );
          }),
        ],
      ),
    );
  }
  Widget _buildGenreListing(BuildContext context, ExploreGenreLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Text(
            state.genreName,
            style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.62,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: state.books.length,
            itemBuilder: (context, index) {
              final book = state.books[index];
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
                    const Row(
                      children: [
                        Icon(Icons.headphones, color: Colors.grey, size: 12),
                        SizedBox(width: 2),
                        Text('5m', style: TextStyle(color: Colors.grey, fontSize: 11)),
                        SizedBox(width: 8),
                        Icon(Icons.menu_book, color: Colors.grey, size: 12),
                        SizedBox(width: 2),
                        Text('8m', style: TextStyle(color: Colors.grey, fontSize: 11)),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResults(BuildContext context, ExploreResultsLoaded state) {
    if (state.results.isEmpty) {
      return const Center(
        child: Text(
          'No books found',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      itemCount: state.results.length,
      itemBuilder: (context, index) {
        final book = state.results[index];
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>  BookDetailScreen(book: book as BookModel))),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(book['image']!, width: 45, height: 60, fit: BoxFit.cover),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book['title']!,
                        style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        book['author']!,
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 14),
              ],
            ),
          ),
        );
      },
    );
  }
}
