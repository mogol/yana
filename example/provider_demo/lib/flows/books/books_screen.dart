import 'package:example/app_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BooksScreen extends StatelessWidget {
  const BooksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppModel>(context);

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
              onTap: () => context.read<AppModel>().logout(),
            ),
          ],
        ),
      ),
      body: state.books.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.separated(
              itemBuilder: (_, i) => ListTile(
                title: Text(state.books[i].title),
                onTap: () => state.setSelectedBookId(state.books[i].id),
              ),
              separatorBuilder: (_, __) => const Divider(),
              itemCount: state.books.length,
            ),
    );
  }
}
