import 'package:built_collection/built_collection.dart';
import 'package:example/redux/actions.dart';
import 'package:example/redux/app_state.dart';
import 'package:example/redux/selectors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class BooksScreen extends StatelessWidget {
  const BooksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      distinct: true,
      converter: (store) => _ViewModel.fromStore(store, context),
      builder: (context, viewModel) => _View(viewModel: viewModel),
    );
  }
}

class _ViewModel {
  final BuiltList<Book> books;
  final Function(String bookId) onSelectBook;
  final Function() onLogout;

  _ViewModel({
    required this.books,
    required this.onSelectBook,
    required this.onLogout,
  });

  static _ViewModel fromStore(Store<AppState> store, BuildContext context) {
    return _ViewModel(
      books: booksSel(store.state),
      onSelectBook: (bookId) => store.dispatch(
        SetSelectedBookIdAction(bookId),
      ),
      onLogout: () => store.dispatch(SignOutAction()),
    );
  }
}

class _View extends StatelessWidget {
  const _View({Key? key, required this.viewModel}) : super(key: key);

  final _ViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Books'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              accountEmail: Text('some@email.com'),
              accountName: Text('YANA User'),
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: viewModel.onLogout,
            ),
          ],
        ),
      ),
      body: viewModel.books.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.separated(
              itemBuilder: (_, i) => ListTile(
                title: Text(viewModel.books[i].title),
                onTap: () => viewModel.onSelectBook(viewModel.books[i].id),
              ),
              separatorBuilder: (_, __) => const Divider(),
              itemCount: viewModel.books.length,
            ),
    );
  }
}
