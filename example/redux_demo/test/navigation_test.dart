import 'package:example/navigation.dart';
import 'package:example/redux/app_state.dart';
import 'package:redux/redux.dart';
import 'package:test/test.dart';

void main() {
  late AppStateBuilder state;
  Store<AppState> store() => Store(
        (state, _) => state,
        initialState: state.build(),
      );

  setUp(() {
    state = AppState.initial().toBuilder();
  });

  group('Non-Authed', () {
    test('shows login screen', () {
      final pages = buildNavigation(store()).pages;

      expect(pages, hasLength(1));
      expect(pages[0].name, equals(ScreenKeys.authorization));
    });
  });
  group('Authed', () {
    setUp(() => state.loggedIn = true);

    test('shows books screen', () {
      final pages = buildNavigation(store()).pages;

      expect(pages, hasLength(1));
      expect(pages[0].name, equals(ScreenKeys.books));
    });

    group('with books', () {
      setUp(
        () => state.books.addAll([
          Book(
            id: '1',
            title: 'Title 1',
            author: 'Author 1',
          ),
        ]),
      );

      test('shows book details if selected books', () {
        state.selectedBookId = '1';

        final pages = buildNavigation(store()).pages;

        expect(pages, hasLength(2));
        expect(pages[0].name, equals(ScreenKeys.books));
        expect(pages[1].name, equals(ScreenKeys.bookDetails));
      });
    });
  });
}
