import 'package:built_collection/built_collection.dart';
import 'package:example/redux/app_state.dart';

Book? selectedBookSel(AppState state) => hasSelectedBook(state)
    ? state.books.firstWhere((book) => book.id == state.selectedBookId)
    : null;
BuiltList<Book> booksSel(AppState state) => state.books;

bool hasSelectedBook(AppState state) => state.selectedBookId != null;

bool hasDialogToShow(AppState state) => state.dialogs.isNotEmpty;
String dialogToShowSel(AppState state) => state.dialogs.first;
