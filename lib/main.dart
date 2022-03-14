import 'package:flutter/material.dart';
import 'package:very_good_slide_puzzle/app.dart';
import 'package:very_good_slide_puzzle/injector.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  runApp(const App());
}
