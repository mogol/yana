import 'package:example/app_model.dart';
import 'package:example/flows/auth/login_screen.dart';
import 'package:example/flows/books/book_details_screen.dart';
import 'package:example/flows/books/books_screen.dart';
import 'package:flutter/material.dart';
import 'package:yana/yana.dart';

class AppRoutePath {}

class AppRouteInformationParser extends RouteInformationParser<AppRoutePath> {
  @override
  Future<AppRoutePath> parseRouteInformation(
    RouteInformation routeInformation,
  ) async =>
      AppRoutePath();

  @override
  RouteInformation? restoreRouteInformation(AppRoutePath configuration) => null;
}

class AppRouterDelegate extends RouterDelegate<AppRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoutePath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  TreeNavNode _navNode;

  final AppModel state;

  AppRouterDelegate(
    this.navigatorKey,
    this.state,
  ) : _navNode = buildNavigation(state) {
    state.addListener(_onChange);
  }

  void _onChange() {
    _navNode = buildNavigation(state);

    notifyListeners();
  }

  @override
  void dispose() {
    state.removeListener(_onChange);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final node = _navNode;
    final pages = [...node.pages];

    return Navigator(
      key: navigatorKey,
      pages: pages,
      onPopPage: (route, result) {
        if (node.onPopPage!(route, result)) {
          return route.didPop(result);
        }
        return false;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(AppRoutePath configuration) =>
      Future.value(null);
}

_loginFlow() => anyOf<AppModel>(when: (s) => !s.loggedIn, pages: [
      materialPage(
        when: always,
        name: ScreenKeys.authorization,
        builder: (_) => const LoginScreen(),
        onPopPage: () => false,
      )
    ]);

_authedFlow() => anyOf<AppModel>(
      when: (s) => s.loggedIn,
      pages: [
        materialPage(
          when: always,
          name: ScreenKeys.books,
          builder: (_) => const BooksScreen(),
          onPopPage: () => false,
        ),
        materialPage(
          when: (s) => s.selectedBook != null,
          name: ScreenKeys.bookDetails,
          builder: (_) => const BookDetailsScreen(),
          onPopPage: () => false,
        ),
      ],
    );

@visibleForTesting
TreeNavNode buildNavigation(AppModel model) => firstOf<AppModel>(
      when: always,
      pages: [
        _loginFlow(),
        _authedFlow(),
      ],
    )(model)!;

abstract class ScreenKeys {
  static const authorization = 'Authorization';
  static const bookDetails = 'BookDetails';
  static const books = 'Books';
}
