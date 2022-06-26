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

final always = (_) => true;
