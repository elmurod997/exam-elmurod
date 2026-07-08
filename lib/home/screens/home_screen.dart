import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth/book/book_detail_screen.dart';
import 'package:flutter_application_1/auth/book/book_model.dart';
import 'package:flutter_application_1/auth/cubit/home_cubit.dart';
import 'package:flutter_application_1/auth/state/home_state.dart';
import 'package:flutter_application_1/explore/explore_screen.dart';
import 'package:flutter_application_1/screens/library_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String _selectedFilter = 'Trending';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..loadHomeData(),
      child: Scaffold(
        backgroundColor: const Color(0xFF121212),
        body: IndexedStack(
          index: _currentIndex,
          children: [
            BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                if (state is HomeLoading) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFFD2E8BE)));
                } else if (state is HomeLoaded) {
                  return SafeArea(
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 140),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),
                              HomeHeader(authors: state.authors),
                              const SizedBox(height: 16),
                              SizedBox(
                                height: 38,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    _filterChip('Trending', Icons.local_fire_department),
                                    const SizedBox(width: 10),
                                    _filterChip('5-Minutes Read', Icons.menu_book),
                                    const SizedBox(width: 10),
                                    _filterChip('Quick Listen', Icons.headphones),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),
                              const HomeBanner(),
                              const SizedBox(height: 28),
                              _sectionHeader('Trending'),
                              const SizedBox(height: 16),
                              _bookHorizontalList(state.trendingBooks),
                              const SizedBox(height: 28),
                              _sectionHeader('Trending'),
                              const SizedBox(height: 16),
                              _bookHorizontalList(state.secondTrendingBooks),
                              const SizedBox(height: 28),
                              _sectionHeader('5-Minutes read'),
                              const SizedBox(height: 16),
                              _bookHorizontalList(state.trendingBooks),
                            ],
                          ),
                        ),
                                                Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                            color: const Color(0xFF1A1A1A),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Image.asset(
                                    'assets/images/rasm2.png',
                                    width: 36,
                                    height: 36,
                                    fit: BoxFit.cover,
                                    errorBuilder: (c, e, s) => const Icon(Icons.book, color: Colors.white),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Continue Listening',
                                        style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        'Managers who want to create positive work enviroments...',
                                        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.play_circle, color: Color(0xFFD2E8BE), size: 32),
                                const SizedBox(width: 12),
                                const Icon(Icons.skip_next, color: Color(0xFFD2E8BE), size: 28),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
            const ExploreScreen(),
            const LibraryScreen(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color(0xFF0A0A0A),
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFFD2E8BE),
          unselectedItemColor: Colors.grey,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Explore'),
            BottomNavigationBarItem(icon: Icon(Icons.bookmark_outline), label: 'Library'),
          ],
        ),
      ),
    );
  }
  Widget _filterChip(String title, IconData icon) {
    final isSelected = _selectedFilter == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = title;
        });
      },
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

  Widget _sectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const Row(
          children: [
            Text('Show all', style: TextStyle(color: Colors.grey, fontSize: 13)),
            SizedBox(width: 4),
            Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 12),
          ],
        ),
      ],
    );
  }

  Widget _bookHorizontalList(List<BookModel> books) {
    return SizedBox(
      height: 225,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookDetailScreen(book: book),
                ),
              );
            },
            child: Container(
              width: 125,
              margin: const EdgeInsets.only(right: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      book.image,
                      width: 125,
                      height: 160,
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => Container(
                        width: 125,
                        height: 160,
                        color: Colors.grey.shade900,
                        child: const Icon(Icons.book, color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    book.title,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12, fontStyle: FontStyle.italic),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    book.author,
                    style: const TextStyle(color: Colors.grey, fontSize: 10),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.headphones, color: Colors.grey, size: 11),
                      const SizedBox(width: 2),
                      Text(book.duration, style: const TextStyle(color: Colors.grey, fontSize: 10)),
                      const SizedBox(width: 8),
                      const Icon(Icons.menu_book, color: Colors.grey, size: 11),
                      const SizedBox(width: 2),
                      Text(book.ideas, style: const TextStyle(color: Colors.grey, fontSize: 10)),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class HomeHeader extends StatelessWidget {
  final List<Map<String, String>> authors;
  const HomeHeader({super.key, required this.authors});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.white, width: 1.5)),
                  ),
                  padding: const EdgeInsets.all(2),
                  child: const Text(
                    'Good Afternoon',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: -0.5),
                  ),
                ),
              ],
            ),
            CircleAvatar(
              radius: 18,
              backgroundImage: const AssetImage('assets/images/rasm5.png'),
              backgroundColor: Colors.grey.shade800,
            ),
          ],
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 85,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: authors.length,
            itemBuilder: (context, index) {
              final author = authors[index];
              return Container(
                margin: const EdgeInsets.only(right: 16),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2.5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFD2E8BE), width: 1.5),
                      ),
                      child: CircleAvatar(
                        radius: 23,
                        backgroundImage: AssetImage(author['image']!),
                        backgroundColor: Colors.grey.shade900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      author['name']!,
                      style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.w400),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
}

class HomeBanner extends StatelessWidget {
  const HomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF262938),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Get unlimited access to\nbooks in just',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, height: 1.3),
                ),
                const SizedBox(height: 12),
                const Text(
                  '\$9.99',
                  style: TextStyle(color: Color(0xFFD2E8BE), fontSize: 32, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 16),
                Text(
                  '*Terms & conditions apply',
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 9),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 120,
            height: 100,
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                Positioned(
                  right: 40,
                  child: Transform.scale(
                    scale: 0.85,
                    child: Image.asset('assets/images/rasm1.png', width: 65, height: 95, fit: BoxFit.cover, errorBuilder: (c, e, s) => const SizedBox()),
                  ),
                ),
                Positioned(
                  right: 20,
                  child: Transform.scale(
                    scale: 0.92,
                    child: Image.asset('assets/images/rasm2.png', width: 65, height: 95, fit: BoxFit.cover, errorBuilder: (c, e, s) => const SizedBox()),
                  ),
                ),
                Positioned(
                  right: 0,
                  child: Image.asset('assets/images/rasm3.png', width: 65, height: 95, fit: BoxFit.cover, errorBuilder: (c, e, s) => const SizedBox()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

