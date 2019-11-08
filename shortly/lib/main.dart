import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';

import 'app/view/bloc/bloc_delegate.dart';
import 'app/view/page/home_page.dart';
import 'di/injection_container.dart' as di;

void main() async {
  Logger.level = Level.verbose;
  await di.init();
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'ProductSans',
        primaryColor: Color(0xFF433D82),
        accentColor: Color(0xFFFF4954),
      ),
      home: HomePage(),
    );
  }

  @override
  void dispose() {
    // Dispose Hive
    Hive.close();
    super.dispose();
  }
}
