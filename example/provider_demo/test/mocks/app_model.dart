import 'dart:collection';

import 'package:example/app_model.dart';
import 'package:flutter/material.dart';

class MockAppModel extends ChangeNotifier implements AppModel {
  @override
  final UnmodifiableListView<Book> books;

  @override
  final bool loggedIn;

  MockAppModel({
    required this.loggedIn,
    required this.books,
    this.selectedBook,
  });

  @override
  void logout() {}

  @override
  final Book? selectedBook;

  @override
  void setBooks(List<Book> value) {}

  @override
  void setSelectedBookId(String? value) {}

  @override
  void signIn() {}
}
