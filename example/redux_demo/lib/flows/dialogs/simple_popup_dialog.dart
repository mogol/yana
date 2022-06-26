import 'package:example/redux/actions.dart';
import 'package:example/redux/app_state.dart';
import 'package:example/redux/selectors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class SimplePopUpDialog extends StatelessWidget {
  const SimplePopUpDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      distinct: true,
      ignoreChange: (state) => !hasDialogToShow(state),
      converter: (store) => _ViewModel.fromStore(store, context),
      builder: (context, viewModel) => _View(viewModel: viewModel),
    );
  }
}

class _ViewModel {
  final String text;
  final Function() onClose;

  _ViewModel({required this.text, required this.onClose});

  static _ViewModel fromStore(Store<AppState> store, BuildContext context) {
    return _ViewModel(
      text: dialogToShowSel(store.state),
      onClose: () => store.dispatch(HideDialogAction()),
    );
  }
}

class _View extends StatelessWidget {
  const _View({Key? key, required this.viewModel}) : super(key: key);

  final _ViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: SimpleDialog(
          title: Text(viewModel.text),
          children: [
            SimpleDialogOption(
              onPressed: viewModel.onClose,
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}
