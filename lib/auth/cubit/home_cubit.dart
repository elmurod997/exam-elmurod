import 'package:flutter_application_1/auth/book/book_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../auth/state/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  final List<BookModel> _allBooks = [
    BookModel(
      id: '1',
      title: 'The good guy',
      author: 'Mark mcalister',
      subtitle: 'A FranklinConvey Title',
      image: 'assets/images/rasm1.png',
      duration: '15m listen',
      ideas: '8 ideas',
      description: 'Far far away, behind the word mountains, far from the countries Vokalia and Consonantia.',
      tags: ['Personal Growth', 'Creativity'],
      audioUrl: 'audio1.mp3', // 1-lokal musiqa fayli nomi
      chapters: [
        {'id': '01', 'title': 'Introduction to Goodness', 'subtitle': 'What makes a person truly good?', 'isLocked': false},
      ],
    ),
    BookModel(
      id: '2',
      title: 'Futurama',
      author: 'Michael Douglas Jr',
      subtitle: 'Sci-Fi & Innovation Legends',
      image: 'assets/images/rasm2.png',
      duration: '12m listen',
      ideas: '9 ideas',
      description: 'Managers who want to create positive work environments will find invaluable lessons.',
      tags: ['Sci-Fi', 'Management'],
      audioUrl: 'audio2.mp3', // 2-lokal musiqa fayli nomi
      chapters: [
        {'id': '01', 'title': 'Welcome to the Tomorrow', 'subtitle': 'A look into future tech.', 'isLocked': false},
      ],
    ),
    BookModel(
      id: '3',
      title: 'Explore your creativity',
      author: 'Royryan Mercado',
      subtitle: 'Art & Design Excellence',
      image: 'assets/images/rasm3.png',
      duration: '16m listen',
      ideas: '15 ideas',
      description: 'Unleash your inner artist and break through creative blocks.',
      tags: ['Art', 'Design'],
      audioUrl: 'audio3.mp3', // 3-lokal musiqa fayli nomi
      chapters: [
        {'id': '01', 'title': 'Breaking the Ice', 'subtitle': 'First steps to creative freedom.', 'isLocked': false},
      ],
    ),
    BookModel(
      id: '4',
      title: 'Norse mythology',
      author: 'Neil Gaiman',
      subtitle: 'Gods and Giants of the North',
      image: 'assets/images/rasm4.png',
      duration: '20m listen',
      ideas: '12 ideas',
      description: 'Gaiman fashions primeval stories into a novelistic arc.',
      tags: ['History', 'Mythology'],
      audioUrl: 'audio4.mp3', // 4-lokal musiqa fayli nomi
      chapters: [
        {'id': '01', 'title': 'The Nine Realms', 'subtitle': 'Understanding the cosmic ash tree.', 'isLocked': false},
      ],
    ),
  ];

  void loadHomeData() async {
    emit(HomeLoading());
    await Future.delayed(const Duration(milliseconds: 200));

    final List<Map<String, String>> mockAuthors = [
      {'name': 'Royryan Mercado', 'image': 'assets/images/rasm3.png'},
      {'name': 'Neil Gaiman', 'image': 'assets/images/rasm4.png'},
      {'name': 'Mark mcalister', 'image': 'assets/images/rasm1.png'},
      {'name': 'Michael Douglas Jr', 'image': 'assets/images/rasm2.png'},
    ];

    emit(HomeLoaded(
      authors: mockAuthors,
      trendingBooks: _allBooks,
      secondTrendingBooks: _allBooks.reversed.toList(),
    ));
  }
}
