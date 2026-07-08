import 'package:flutter_application_1/auth/book/book_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

abstract class BookReadState {}
class BookReadInitial extends BookReadState {}
class BookReadLoaded extends BookReadState {
  final double fontSize;
  final bool isDarkMode;

  BookReadLoaded({
    required this.fontSize,
    required this.isDarkMode,
  });
}

class BookReadCubit extends Cubit<BookReadState> {
  BookReadCubit() : super(BookReadInitial());

  void initBook() {
    emit(BookReadLoaded(fontSize: 14.0, isDarkMode: true));
  }

  void increaseFontSize() {
    if (state is BookReadLoaded) {
      final currentState = state as BookReadLoaded;
      double newSize = currentState.fontSize + 2.0;
      if (newSize > 24.0) newSize = 14.0;
      emit(BookReadLoaded(fontSize: newSize, isDarkMode: currentState.isDarkMode));
    }
  }

  void toggleTheme() {
    if (state is BookReadLoaded) {
      final currentState = state as BookReadLoaded;
      emit(BookReadLoaded(fontSize: currentState.fontSize, isDarkMode: !currentState.isDarkMode));
    }
  }
}

class BookReadScreen extends StatelessWidget {
  final BookModel book;

  const BookReadScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookReadCubit()..initBook(),
      child: BlocBuilder<BookReadCubit, BookReadState>(
        builder: (context, state) {
          if (state is BookReadInitial) {
            return const Scaffold(
              backgroundColor: Color(0xFF121212),
              body: Center(child: CircularProgressIndicator(color: Color(0xFFD2E8BE))),
            );
          } else if (state is BookReadLoaded) {
            final isDark = state.isDarkMode;
            final currentBgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5);
            final currentTextColor = isDark ? Colors.white : Colors.black;
            final iconColor = isDark ? Colors.white : Colors.black;

            return Scaffold(
              backgroundColor: currentBgColor,
              body: SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back_ios, color: iconColor, size: 22),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: Icon(Icons.search, color: iconColor, size: 24),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: Icon(Icons.text_fields, color: iconColor, size: 24),
                            onPressed: () => context.read<BookReadCubit>().increaseFontSize(),
                          ),
                          IconButton(
                            icon: Icon(
                              isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                              color: iconColor,
                              size: 24,
                            ),
                            onPressed: () => context.read<BookReadCubit>().toggleTheme(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                                        Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'What is in it for me? Learn how to become an effective unofficial project manager',
                              style: TextStyle(
                                color: currentTextColor,
                                fontSize: state.fontSize + 6,
                                fontWeight: FontWeight.bold,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Far far away, behind the word mountains, far from the countries Vokalia and Consonantia, there live the blind texts. Separated they live in Bookmarksgrove right at the coast of the Semantics, a large language ocean. A small river named Duden flows by their place and supplies it with the necessary regalia. It is a paradisematic country, in which roasted parts of sentences fly into your mouth.\n\n'
                              'The Big Oxmox advised her not to do so, because there were thousands of bad Commas, wild Question Marks and devious Semikoli, but the Little Blind Text didn’t listen.\n\n'
                              'Little Blind Text didn’t listen. She packed her seven versalia, put her initial into the belt and made herself on the way.\n\n'
                              'Bookmarksgrove, the headline of Alphabet Village and the subline of her own road, the Line Lane. Pityful a rethoric question ran over her cheek, then',
                              style: TextStyle(
                                color: isDark ? Colors.grey.shade300 : Colors.grey.shade800,
                                fontSize: state.fontSize,
                                height: 1.6,
                              ),
                            ),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}


  