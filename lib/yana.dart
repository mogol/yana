library yana;

import 'package:flutter/material.dart';

typedef TreeNavCondition<T> = bool Function(T);

typedef TreeNavReducer<T> = TreeNavNode? Function(T state);

class TreeNavNode {
  final List<Page> pages;
  final bool Function(Route<dynamic>, dynamic)? onPopPage;

  TreeNavNode(Page page, this.onPopPage) : pages = [page];

  TreeNavNode.multiple(this.pages, this.onPopPage);

  static TreeNavNode material({
    required String name,
    required Widget child,
    required bool Function() onPopPage,
  }) =>
      TreeNavNode(
        MaterialPage(
          key: ValueKey(name),
          name: name,
          child: child,
        ),
        (_, __) => onPopPage(),
      );
}

TreeNavReducer<T> _validate<T>(
        TreeNavCondition<T> when, TreeNavReducer<T> reducer) =>
    (state) => when(state) ? reducer(state) : null;

TreeNavReducer<T> page<T>({
  required TreeNavCondition<T> when,
  required TreeNavNode Function(T) builder,
}) {
  return _validate(
    when,
    (state) => builder(state),
  );
}

/// Represent a widget wrapped in [MaterialPage]
TreeNavReducer<T> materialPage<T>({
  required TreeNavCondition<T> when,
  required String name,
  required WidgetBuilder builder,
  required bool Function() onPopPage,
}) =>
    page(
      when: when,
      builder: (_) => TreeNavNode.material(
        name: name,
        child: Builder(builder: builder),
        onPopPage: onPopPage,
      ),
    );

/// Represent a widget that is equivalent for [showGeneralDialog]
TreeNavReducer<T> popUpDialog<T>({
  required TreeNavCondition<T> when,
  required String name,
  required WidgetBuilder builder,
  required bool Function() onPopPage,
  Color barrierColor = const Color(0x80000000),
}) =>
    page(
      when: when,
      builder: (_) => TreeNavNode(
        _PopupPage(
          key: ValueKey(name),
          name: name,
          child: Builder(builder: builder),
          barrierColor: barrierColor,
        ),
        (_, __) => onPopPage(),
      ),
    );

class _PopupPage<T> extends Page<T> {
  const _PopupPage({
    required this.child,
    required this.barrierColor,
    this.maintainState = true,
    LocalKey? key,
    String? name,
    Object? arguments,
  }) : super(key: key, name: name, arguments: arguments);

  final Widget child;
  final bool maintainState;
  final Color barrierColor;

  @override
  Route<T> createRoute(BuildContext context) {
    return RawDialogRoute<T>(
      pageBuilder: (_, __, ___) => child,
      settings: this,
      barrierDismissible: false,
      barrierColor: barrierColor,
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset(0.0, 0.0);
        const curve = Curves.easeIn;

        final tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}

/// Returns all page from [pages] until first item that doesn't satisfy its [when] predicate
///
///```dart
///final buildNavigation = flow<int>(
///    when: (state) => state == 0,
///    pages: [
///      page<int>(
///        when: (state) => state == 0,
///        builder: (_) => TreeNavNode(page1, (_, __) => true),
///      ),
///      page<int>(
///        when: (state) => state == 1,
///        builder: (_) => TreeNavNode(page2, (_, __) => false),
///      ),
///      page<int>(
///        when: (state) => state == 0,
///        builder: (_) => TreeNavNode(page3, (_, __) => false),
///      ),
///  ],
///)
///```
///[buildNavigation(0)] returns only the first page
TreeNavReducer<T> flow<T>({
  required TreeNavCondition<T> when,
  required List<TreeNavReducer<T>> pages,
}) {
  return _validate(when, (state) {
    final resolved = <Page<dynamic>>[];
    bool Function(Route<dynamic>, dynamic)? onPagePop;

    for (var page in pages) {
      final node = page(state);
      if (node == null) {
        break;
      }
      onPagePop = node.onPopPage;
      resolved.addAll(node.pages);
    }
    return resolved.isEmpty ? null : TreeNavNode.multiple(resolved, onPagePop);
  });
}

/// Returns item from [pages] which satisfies its own [when] predicate
///
///```dart
///final buildNavigation = firstOf<int>(
///    when: (state) => state == 0,
///    pages: [
///      page<int>(
///        when: (state) => state == 1,
///        builder: (_) => TreeNavNode(page1, (_, __) => true),
///      ),
///      page<int>(
///        when: (state) => state == 0,
///        builder: (_) => TreeNavNode(page2, (_, __) => false),
///      ),
///      page<int>(
///        when: (state) => state == 0,
///        builder: (_) => TreeNavNode(page3, (_, __) => false),
///      ),
///  ],
///)
///```
///[buildNavigation(0)] returns only the second page
TreeNavReducer<T> firstOf<T>({
  required TreeNavCondition<T> when,
  required List<TreeNavReducer<T>> pages,
}) {
  return _validate(when, (state) {
    for (var page in pages) {
      final node = page(state);
      if (node != null) {
        return TreeNavNode.multiple(
          node.pages,
          node.onPopPage,
        );
      }
    }
    return null;
  });
}

/// Returns all items from [pages] which satisfy their own [when] predicate
///
///```dart
///final buildNavigation = anyOf<int>(
///    when: (state) => state == 0,
///    pages: [
///      page<int>(
///        when: (state) => state == 0,
///        builder: (_) => TreeNavNode(page1, (_, __) => true),
///      ),
///      page<int>(
///        when: (state) => state == 1,
///        builder: (_) => TreeNavNode(page2, (_, __) => false),
///      ),
///      page<int>(
///        when: (state) => state == 0,
///        builder: (_) => TreeNavNode(page3, (_, __) => false),
///      ),
///  ],
///)
///```
///[buildNavigation(0)] returns only the first and the third pages
TreeNavReducer<T> anyOf<T>({
  required TreeNavCondition<T> when,
  required List<TreeNavReducer<T>> pages,
}) {
  return _validate(when, (state) {
    final resolved = <Page<dynamic>>[];
    bool Function(Route<dynamic>, dynamic)? onPagePop;

    for (var page in pages) {
      final node = page(state);
      if (node == null) {
        continue;
      }
      onPagePop = node.onPopPage;
      resolved.addAll(node.pages);
    }
    return resolved.isEmpty ? null : TreeNavNode.multiple(resolved, onPagePop);
  });
}

// ignore: prefer_function_declarations_over_variables
final always = (_) => true;
