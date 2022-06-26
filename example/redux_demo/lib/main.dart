import 'package:example/navigation.dart';
import 'package:example/redux/app_state.dart';
import 'package:example/redux/middleware.dart';
import 'package:example/redux/reducers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Store<AppState> store;
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();

    store = Store(
      appReducers(),
      initialState: AppState.initial(),
      middleware: appMiddlewares(),
      distinct: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp.router(
        routeInformationParser: AppRouteInformationParser(),
        routerDelegate: AppRouterDelegate(navigatorKey, store),
      ),
    );
  }
}
