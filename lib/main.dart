import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:valid_sudoku/backend/game.dart';
import 'package:valid_sudoku/pages/game_screen.dart';
import 'backend/database/models.dart';
import 'pages/main_screen.dart';
import 'backend/game.dart';

Future main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(SudokuGameModelAdapter());
  Hive.registerAdapter(SettingsAdapter());
  await Hive.openBox<SudokuGameModel>('games');
  await Hive.openBox<Settings>('settings');

  if (Hive.box<Settings>('settings').isEmpty) {
    Hive.box<Settings>('settings').add(Settings());
  }

  return runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => const MainScreen(),
    },
  ));
}
