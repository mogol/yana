import 'dart:collection';

import 'package:example/app_model.dart';
import 'package:example/navigation.dart';
import 'package:test/test.dart';

import 'mocks/app_model.dart';

void main() {
  group('Non-Authed', () {
    test('shows login screen', () {
      final appModel = MockAppModel(
        loggedIn: false,
        books: UnmodifiableListView([]),
      );

      final pages = buildNavigation(appModel).pages;

      expect(pages, hasLength(1));
      expect(pages[0].name, equals(ScreenKeys.authorization));
    });
  });
  group('Authed', () {
    test('shows books screen', () {
      final appModel = MockAppModel(
        loggedIn: true,
        books: UnmodifiableListView([]),
      );

      final pages = buildNavigation(appModel).pages;

      expect(pages, hasLength(1));
      expect(pages[0].name, equals(ScreenKeys.books));
    });
    test('shows details if selected books', () {
      final books = [
        Book(
          id: '1',
          title: 'Title 1',
          author: 'Author 1',
        ),
      ];
      final appModel = MockAppModel(
        loggedIn: true,
        books: UnmodifiableListView(books),
        selectedBook: books.first,
      );

      final pages = buildNavigation(appModel).pages;

      expect(pages, hasLength(2));
      expect(pages[0].name, equals(ScreenKeys.books));
      expect(pages[1].name, equals(ScreenKeys.bookDetails));
    });
  });
}
