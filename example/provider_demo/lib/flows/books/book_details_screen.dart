import 'package:example/app_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookDetailsScreen extends StatefulWidget {
  const BookDetailsScreen({Key? key}) : super(key: key);

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  late Book book;

  @override
  void initState() {
    super.initState();

    book = Provider.of<AppModel>(context, listen: false).selectedBook!;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<AppModel>().setSelectedBookId(null);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Book'),
        ),
        body: Center(
          child: Column(
            children: [
              Text(
                book.title,
                style: Theme.of(context).textTheme.headline3,
              ),
              Text(
                book.author,
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
