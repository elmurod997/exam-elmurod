import 'package:flutter_application_1/auth/book/book_model.dart';


abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Map<String, String>> authors;
  final List<BookModel> trendingBooks;
  final List<BookModel> secondTrendingBooks;

  HomeLoaded({
    required this.authors,
    required this.trendingBooks,
    required this.secondTrendingBooks,
  });
}
