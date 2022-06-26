import 'package:example/redux/actions.dart';
import 'package:example/redux/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

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
  final Function() onLogin;
  _ViewModel({required this.onLogin});

  static _ViewModel fromStore(Store<AppState> store, BuildContext context) {
    return _ViewModel(
      onLogin: () => store.dispatch(
        SignInAction(
          username: 'user_good',
          password: 'pass_good',
        ),
      ),
    );
  }
}

class _View extends StatelessWidget {
  const _View({Key? key, required this.viewModel}) : super(key: key);

  final _ViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Authorization')),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: 150,
            child: Column(
              children: [
                const TextField(
                  decoration: InputDecoration(
                    label: Text('Username'),
                  ),
                ),
                const TextField(
                  decoration: InputDecoration(
                    label: Text('Password'),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                OutlinedButton(
                  onPressed: viewModel.onLogin,
                  child: const Text('Sign In'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
