import 'package:flutter/material.dart';
import 'package:git_trends/pages/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GitTrends',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}