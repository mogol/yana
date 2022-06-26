import 'dart:async';

import 'package:example/flows/flows.dart';
import 'package:example/redux/app_state.dart';
import 'package:example/redux/selectors.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
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

  late StreamSubscription<AppState> _storeSubscription;

  AppRouterDelegate(
    this.navigatorKey,
    Store<AppState> store,
  ) : _navNode = buildNavigation(store) {
    _storeSubscription = store.onChange.listen((event) {
      _navNode = buildNavigation(store);
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _storeSubscription.cancel();

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

_loginFlow() => anyOf<AppState>(when: (s) => !s.loggedIn, pages: [
      materialPage(
        when: always,
        name: ScreenKeys.authorization,
        builder: (_) => const LoginScreen(),
        onPopPage: () => false,
      )
    ]);

_authedFlow() => anyOf<AppState>(
      when: (s) => s.loggedIn,
      pages: [
        materialPage(
          when: always,
          name: ScreenKeys.books,
          builder: (_) => const BooksScreen(),
          onPopPage: () => false,
        ),
        materialPage(
          when: hasSelectedBook,
          name: ScreenKeys.bookDetails,
          builder: (_) => const BookDetailsScreen(),
          onPopPage: () => false,
        ),
      ],
    );

@visibleForTesting
TreeNavNode buildNavigation(Store<AppState> store) => firstOf<AppState>(
      when: always,
      pages: [
        _loginFlow(),
        _authedFlow(),
      ],
    )(store.state)!;

abstract class ScreenKeys {
  static const authorization = 'Authorization';
  static const bookDetails = 'BookDetails';
  static const books = 'Books';
}
