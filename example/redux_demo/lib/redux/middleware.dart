import 'package:built_collection/built_collection.dart';
import 'package:example/redux/actions.dart';
import 'package:example/redux/app_state.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> appMiddlewares() => [
      _onSignInAction(),
      _onSignOutAction(),
      _onLoadBooksAction(),
    ];

Middleware<AppState> _onSignInAction() {
  return TypedMiddleware<AppState, SignInAction>((
    store,
    action,
    next,
  ) async {
    next(action);
    store.dispatch(SetLoggedInAction(true));
    store.dispatch(LoadBooksAction());
  });
}

Middleware<AppState> _onSignOutAction() {
  return TypedMiddleware<AppState, SignOutAction>((
    store,
    action,
    next,
  ) async {
    next(action);
    store.dispatch(SetLoggedInAction(false));
  });
}

Middleware<AppState> _onLoadBooksAction() {
  return TypedMiddleware<AppState, LoadBooksAction>((
    store,
    action,
    next,
  ) async {
    next(action);
    await Future.delayed(const Duration(seconds: 1));

    final books = List.generate(
      10,
      (index) => Book(
        id: '$index',
        title: 'Title $index',
        author: 'Author $index',
      ),
    ).build();

    store.dispatch(SetBooksAction(books));
  });
}
