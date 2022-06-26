import 'dart:collection';

import 'package:flutter/material.dart';

class AppModel extends ChangeNotifier {
  bool _loggedIn = false;
  String? _selectedBookId;
  final List<Book> _books = [];

  bool get loggedIn => _loggedIn;

  void logout() {
    _loggedIn = false;
    _selectedBookId = null;
    _books.clear();

    notifyListeners();
  }

  void signIn() {
    _loggedIn = true;
    notifyListeners();
    _loadBooks();
  }

  Book? get selectedBook => _selectedBookId == null
      ? null
      : _books.firstWhere((element) => element.id == _selectedBookId);

  void setSelectedBookId(String? value) {
    _selectedBookId = value;
    notifyListeners();
  }

  UnmodifiableListView<Book> get books => UnmodifiableListView(_books);

  void setBooks(List<Book> value) {
    _books.clear();
    _books.addAll(value);

    notifyListeners();
  }

  void _loadBooks() async {
    await Future.delayed(const Duration(seconds: 2));

    setBooks(
      List.generate(
        10,
        (i) => Book(
          id: i.toString(),
          author: 'Author $i',
          title: 'Title $i',
        ),
      ),
    );
  }
}

class Book {
  final String id;
  final String title;
  final String author;

  Book({required this.id, required this.title, required this.author});
}
