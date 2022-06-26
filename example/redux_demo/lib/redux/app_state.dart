import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';

part 'app_state.g.dart';

abstract class AppState implements Built<AppState, AppStateBuilder> {
  bool get loggedIn;
  BuiltList<Book> get books;
  String? get selectedBookId;

  BuiltList<String> get dialogs;

  AppState._();

  factory AppState([void Function(AppStateBuilder) updates]) = _$AppState;

  static AppState initial() => AppState(
        (b) => b..loggedIn = false,
      );
}

class Book {
  final String id;
  final String title;
  final String author;

  Book({required this.id, required this.title, required this.author});
}
