# YANA - Yet Another Navigation Approach

YANA provides a convenient way to use declarative state-driven testable navigation. It is Navigator 2.0 without rough edges.

## Declarative

The declarative approach separates navigation from UI and business logic. No more `Navigator.push` and `Navigator.pop` in surprising places.

```dart
TreeNavNode buildNavigation(state) => firstOf<AppState>(
      when: always,
      pages: [
        _loginFlow(),
        _authedFlow(),
      ],
    )(state);

_loginFlow() => anyOf<AppState>(
      when: hasNoUser,
      pages: [
        materialPage(
          when: always,
          name: ScreenKeys.authorization,
          builder: (_) => const LoginScreen(),
          onPopPage: () => false,
        )
      ],
    );

_authedFlow() => anyOf<AppState>(
      when: hasUser,
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
```

## State-driven

Always predictable screens based on your state. Thanks to Navigator 2.0!

```dart
class AppRouterDelegate {
  TreeNavNode _navNode;
  StreamSubscription<AppState> _storeSubscription;

  AppRouterDelegate(store) {
    _storeSubscription = store.onChange.listen((event) {
      _navNode = buildNavigation(store);
      notifyListeners();
    });
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
}
```

## Testable

Simple unit tests guarantee that each state is translated to the expected navigation configuration. Check tests in demos for details.

```dart
var pages = buildNavigation(state).pages;

expect(pages, hasLength(1));
expect(pages[0].name, equals(ScreenKeys.authorization));

state.loggedIn = true;
pages = buildNavigation(state).pages;

expect(pages, hasLength(1));
expect(pages[0].name, equals(ScreenKeys.books));
```

## Getting Started

- Add `yana` package to your `pubspec.yaml`
- Define `buildNavigation` function
- Create your `AppRouterDelegate` that triggers `buildNavigation` for required state changes
- Done!

Check examples with redux and provider state management.

## Advanced

### How to customize a presentation of a page?

Check implementation `popUpDialog` for inspiration.

## Status

- Production-ready. The library has been used in multiple applications since 2019.
- You can expect breaking changes before the package reaches 1.0.0 based on community feedback.
