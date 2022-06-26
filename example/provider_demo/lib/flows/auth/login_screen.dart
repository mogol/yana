import 'package:example/app_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

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
                  onPressed: () => context.read<AppModel>().signIn(),
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
