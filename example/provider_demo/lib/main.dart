import 'package:example/app_model.dart';
import 'package:example/navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final appModel = AppModel();
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: appModel,
      child: MaterialApp.router(
        routeInformationParser: AppRouteInformationParser(),
        routerDelegate: AppRouterDelegate(navigatorKey, appModel),
      ),
    );
  }
}
