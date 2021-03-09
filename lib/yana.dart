library yana;


import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef TreeNavCondition<T> = bool Function(T);

typedef TreeNavReducer<T> = TreeNavNode Function(T state);

class TreeNavNode {
  final List<Page> pages;
  final bool Function(Route<dynamic>, dynamic) onPopPage;

  TreeNavNode(Page page, this.onPopPage) : pages = [page];

  TreeNavNode.multiple(this.pages, this.onPopPage);
}

TreeNavReducer<T> _validate<T>(
    TreeNavCondition<T> when, TreeNavReducer<T> reducer) =>
        (state) => when(state) ? reducer(state) : null;

TreeNavReducer<T> page<T>({
  @required TreeNavCondition<T> when,
  @required TreeNavNode Function(T) builder,
}) {
  return _validate(
    when,
        (state) => builder(state),
  );
}

TreeNavReducer<T> flow<T>({
  @required TreeNavCondition<T> when,
  @required List<TreeNavReducer<T>> pages,
}) {
  return _validate(when, (state) {
    final resolved = <Page<dynamic>>[];
    bool Function(Route<dynamic>, dynamic) onPagePop;

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
  @required TreeNavCondition<T> when,
  @required List<TreeNavReducer<T>> pages,
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
  @required TreeNavCondition<T> when,
  @required List<TreeNavReducer<T>> pages,
}) {
  return _validate(when, (state) {
    final resolved = <Page<dynamic>>[];
    bool Function(Route<dynamic>, dynamic) onPagePop;

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

class _DialogPage<T> extends Page<T> {
  const _DialogPage({
    @required this.child,
    this.maintainState = true,
    LocalKey key,
    String name,
    Object arguments,
  })  : assert(child != null),
        assert(maintainState != null),
        super(key: key, name: name, arguments: arguments);

  final Widget child;
  final bool maintainState;

  @override
  Route<T> createRoute(BuildContext context) {
    return _DialogPageRoute<T>(page: this);
  }
}

class _DialogPageRoute<T> extends PageRoute<T>
    with MaterialRouteTransitionMixin<T> {
  _DialogPageRoute({
    @required _DialogPage<T> page,
  })  : assert(page != null),
        super(settings: page);

  _DialogPage<T> get _page => settings as _DialogPage<T>;

  @override
  Widget buildContent(BuildContext context) {
    return _page.child;
  }

  @override
  bool get opaque => false;

  @override
  bool get maintainState => _page.maintainState;

  @override
  bool get fullscreenDialog => true;

  @override
  String get debugLabel => '${super.debugLabel}(${_page.name})';
}

