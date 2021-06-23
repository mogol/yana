import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart' hide anyOf;
import 'package:yana/yana.dart';

void main() {
  final route = MaterialPageRoute(builder: (_) => Container());

  group('page', () {
    test('returns null if condition fails', () {
      final reducer = page<int>(
        when: (state) => state == 0,
        builder: (_) => TreeNavNode(MockMaterialPage('1'), null),
      );

      expect(reducer(1), isNull);
    });

    test('returns page if condition passes', () {
      final page1 = MockMaterialPage('1');

      final reducer = page<int>(
        when: (state) => state == 0,
        builder: (_) => TreeNavNode(page1, (_, __) => true),
      );

      final node = reducer(0);
      expect(node, isNotNull);
      expect(node!.pages, [page1]);
      expect(node.onPopPage?.call(route, null), equals(true));
    });
  });

  group('flow', () {
    test('returns null if condition fails', () {
      final reducer = flow<int>(when: (state) => state == 0, pages: []);

      expect(reducer(1), isNull);
    });

    test('returns page if condition passes', () {
      final page1 = MockMaterialPage('1');

      final reducer = flow<int>(
        when: (state) => state == 0,
        pages: [
          page<int>(
            when: always,
            builder: (_) => TreeNavNode(page1, (_, __) => true),
          )
        ],
      );

      final node = reducer(0);
      expect(node, isNotNull);
      expect(node!.pages, [page1]);
      expect(node.onPopPage?.call(route, null), isTrue);
    });

    test('returns null if first pages condition fails', () {
      final page1 = MockMaterialPage('1');
      final page2 = MockMaterialPage('2');

      final reducer = flow<int>(
        when: (state) => state == 0,
        pages: [
          page<int>(
            when: (state) => state == 1,
            builder: (_) => TreeNavNode(page1, (_, __) => true),
          ),
          page<int>(
            when: (state) => state == 0,
            builder: (_) => TreeNavNode(page2, (_, __) => true),
          ),
        ],
      );

      expect(reducer(0), isNull);
    });

    test('returns first page if next pages condition fails', () {
      final page1 = MockMaterialPage('1');
      final page2 = MockMaterialPage('2');
      final page3 = MockMaterialPage('3');

      final reducer = flow<int>(
        when: (state) => state == 0,
        pages: [
          page<int>(
            when: (state) => state == 0,
            builder: (_) => TreeNavNode(page1, (_, __) => true),
          ),
          page<int>(
            when: (state) => state == 1,
            builder: (_) => TreeNavNode(page2, (_, __) => false),
          ),
          page<int>(
            when: (state) => state == 0,
            builder: (_) => TreeNavNode(page3, (_, __) => false),
          ),
        ],
      );

      final node = reducer(0);
      expect(node, isNotNull);
      expect(node!.pages, [page1]);
      expect(node.onPopPage?.call(route, null), isTrue);
    });

    test('returns all pages', () {
      final page1 = MockMaterialPage('1');
      final page2 = MockMaterialPage('2');
      final page3 = MockMaterialPage('3');

      final reducer = flow<int>(
        when: (state) => state == 0,
        pages: [
          page<int>(
            when: (state) => state == 0,
            builder: (_) => TreeNavNode(page1, (_, __) => false),
          ),
          page<int>(
            when: (state) => state == 0,
            builder: (_) => TreeNavNode(page2, (_, __) => false),
          ),
          page<int>(
            when: (state) => state == 0,
            builder: (_) => TreeNavNode(page3, (_, __) => true),
          ),
        ],
      );

      final node = reducer(0);
      expect(node, isNotNull);
      expect(node!.pages, [page1, page2, page3]);
      expect(node.onPopPage?.call(route, null), isTrue);
    });
  });

  group('firstOf', () {
    test('returns null if condition fails', () {
      final reducer = firstOf<int>(when: (state) => state == 0, pages: []);

      expect(reducer(1), isNull);
    });

    test('returns page if condition passes', () {
      final page1 = MockMaterialPage('1');

      final reducer = firstOf<int>(
        when: (state) => state == 0,
        pages: [
          page<int>(
            when: always,
            builder: (_) => TreeNavNode(page1, (_, __) => true),
          )
        ],
      );

      final node = reducer(0);
      expect(node, isNotNull);
      expect(node!.pages, [page1]);
      expect(node.onPopPage?.call(route, null), isTrue);
    });

    test('returns null if all pages conditions fail', () {
      final page1 = MockMaterialPage('1');
      final page2 = MockMaterialPage('2');

      final reducer = firstOf<int>(
        when: (state) => state == 0,
        pages: [
          page<int>(
            when: (state) => state == 1,
            builder: (_) => TreeNavNode(page1, (_, __) => true),
          ),
          page<int>(
            when: (state) => state == 1,
            builder: (_) => TreeNavNode(page2, (_, __) => true),
          ),
        ],
      );

      expect(reducer(0), isNull);
    });

    test('returns first page if its condition passes', () {
      final page1 = MockMaterialPage('1');
      final page2 = MockMaterialPage('2');
      final page3 = MockMaterialPage('3');

      final reducer = firstOf<int>(
        when: (state) => state == 0,
        pages: [
          page<int>(
            when: (state) => state == 0,
            builder: (_) => TreeNavNode(page1, (_, __) => true),
          ),
          page<int>(
            when: (state) => state == 0,
            builder: (_) => TreeNavNode(page2, (_, __) => false),
          ),
          page<int>(
            when: (state) => state == 0,
            builder: (_) => TreeNavNode(page3, (_, __) => false),
          ),
        ],
      );

      final node = reducer(0);

      expect(node, isNotNull);
      expect(node!.pages, [page1]);
      expect(node.onPopPage?.call(route, null), isTrue);
    });

    test('returns second page if its condition passes', () {
      final page1 = MockMaterialPage('1');
      final page2 = MockMaterialPage('2');
      final page3 = MockMaterialPage('3');

      final reducer = firstOf<int>(
        when: (state) => state == 0,
        pages: [
          page<int>(
            when: (state) => state == 1,
            builder: (_) => TreeNavNode(page1, (_, __) => false),
          ),
          page<int>(
            when: (state) => state == 0,
            builder: (_) => TreeNavNode(page2, (_, __) => true),
          ),
          page<int>(
            when: (state) => state == 0,
            builder: (_) => TreeNavNode(page3, (_, __) => false),
          ),
        ],
      );

      final node = reducer(0);
      expect(node, isNotNull);
      expect(node!.pages, [page2]);
      expect(node.onPopPage?.call(route, null), isTrue);
    });
  });

  group('anyOf', () {
    test('returns null if condition fails', () {
      final reducer = anyOf<int>(when: (state) => state == 0, pages: []);

      expect(reducer(1), isNull);
    });

    test('returns page if condition passes', () {
      final page1 = MockMaterialPage('1');

      final reducer = anyOf<int>(
        when: (state) => state == 0,
        pages: [
          page<int>(
            when: always,
            builder: (_) => TreeNavNode(page1, (_, __) => true),
          )
        ],
      );

      final node = reducer(0);
      expect(node, isNotNull);
      expect(node!.pages, [page1]);
      expect(node.onPopPage?.call(route, null), isTrue);
    });

    test('returns null if all pages conditions fail', () {
      final page1 = MockMaterialPage('1');
      final page2 = MockMaterialPage('2');

      final reducer = anyOf<int>(
        when: (state) => state == 0,
        pages: [
          page<int>(
            when: (state) => state == 1,
            builder: (_) => TreeNavNode(page1, (_, __) => true),
          ),
          page<int>(
            when: (state) => state == 1,
            builder: (_) => TreeNavNode(page2, (_, __) => true),
          ),
        ],
      );

      expect(reducer(0), isNull);
    });

    test('returns first and last page if its condition passes', () {
      final page1 = MockMaterialPage('1');
      final page2 = MockMaterialPage('2');
      final page3 = MockMaterialPage('3');

      final reducer = anyOf<int>(
        when: (state) => state == 0,
        pages: [
          page<int>(
            when: (state) => state == 0,
            builder: (_) => TreeNavNode(page1, (_, __) => false),
          ),
          page<int>(
            when: (state) => state == 1,
            builder: (_) => TreeNavNode(page2, (_, __) => false),
          ),
          page<int>(
            when: (state) => state == 0,
            builder: (_) => TreeNavNode(page3, (_, __) => true),
          ),
        ],
      );

      final node = reducer(0);
      expect(node, isNotNull);
      expect(node!.pages, [page1, page3]);
      expect(node.onPopPage?.call(route, null), isTrue);
    });

    test('returns all pages if its condition passes', () {
      final page1 = MockMaterialPage('1');
      final page2 = MockMaterialPage('2');
      final page3 = MockMaterialPage('3');

      final reducer = anyOf<int>(
        when: (state) => state == 0,
        pages: [
          page<int>(
            when: (state) => state == 0,
            builder: (_) => TreeNavNode(page1, (_, __) => false),
          ),
          page<int>(
            when: (state) => state == 0,
            builder: (_) => TreeNavNode(page2, (_, __) => false),
          ),
          page<int>(
            when: (state) => state == 0,
            builder: (_) => TreeNavNode(page3, (_, __) => true),
          ),
        ],
      );

      final node = reducer(0);
      expect(node, isNotNull);
      expect(node!.pages, [page1, page2, page3]);
      expect(node.onPopPage?.call(route, null), isTrue);
    });
  });
}

class MockMaterialPage extends MaterialPage {
  final String name;

  MockMaterialPage(this.name) : super(child: Container());

  @override
  String toString() {
    return 'MockMaterialPage{name: $name}';
  }
}
