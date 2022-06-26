import 'package:built_collection/built_collection.dart';
import 'package:example/redux/app_state.dart';

class SignInAction {
  final String username;
  final String password;

  SignInAction({
    required this.username,
    required this.password,
  });
}

class SignOutAction {}

class LoadBooksAction {}

class SetBooksAction {
  final BuiltList<Book> books;

  SetBooksAction(this.books);
}

class SetSelectedBookIdAction {
  final String? id;

  SetSelectedBookIdAction([this.id]);
}

class SetLoggedInAction {
  final bool loggedIn;

  SetLoggedInAction(this.loggedIn);
}
