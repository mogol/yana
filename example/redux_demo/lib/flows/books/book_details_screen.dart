import 'package:example/redux/actions.dart';
import 'package:example/redux/app_state.dart';
import 'package:example/redux/selectors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class BookDetailsScreen extends StatelessWidget {
  const BookDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      distinct: true,
      ignoreChange: (s) => !hasSelectedBook(s),
      converter: (store) => _ViewModel.fromStore(store, context),
      builder: (context, viewModel) => _View(viewModel: viewModel),
    );
  }
}

class _ViewModel {
  final Function() onLike;
  final Function() onBack;
  final String title;
  final String author;

  _ViewModel({
    required this.onLike,
    required this.onBack,
    required this.title,
    required this.author,
  });

  static _ViewModel fromStore(Store<AppState> store, BuildContext context) {
    final book = selectedBookSel(store.state)!;
    return _ViewModel(
      title: book.title,
      author: book.author,
      onBack: () => store.dispatch(SetSelectedBookIdAction()),
      onLike: () => store.dispatch(ShowDialogAction('You liked the book!')),
    );
  }
}

class _View extends StatelessWidget {
  const _View({Key? key, required this.viewModel}) : super(key: key);

  final _ViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        viewModel.onBack();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Book'),
        ),
        body: Center(
          child: Column(
            children: [
              Text(
                viewModel.title,
                style: Theme.of(context).textTheme.headline3,
              ),
              Text(
                viewModel.author,
                style: Theme.of(context).textTheme.headline4,
              ),
              IconButton(
                onPressed: viewModel.onLike,
                icon: const Icon(Icons.thumb_up),
              )
            ],
          ),
        ),
      ),
    );
  }
}
