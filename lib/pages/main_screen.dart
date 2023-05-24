import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:valid_sudoku/backend/database/models.dart';
import 'package:valid_sudoku/backend/game.dart';
import 'package:valid_sudoku/pages/game_screen.dart';
import 'package:valid_sudoku/pages/settings_screen.dart';
import 'package:valid_sudoku/pages/stat_screen.dart';
import 'package:valid_sudoku/themes.dart';
import '../backend/sudoku.dart';
import 'package:valid_sudoku/lang.dart';

import 'info_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  static const availableSizes = [4, 9, 16];
  int? selectedSize = availableSizes[1];
  Difficulty? selectedDifficulty = Difficulty.medium;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(valueListenable: Hive.box<Settings>('settings').listenable(), builder: (context, box, _) {
      final labelFontSize = MediaQuery.of(context).size.width / 20;
      final dividerHeight = MediaQuery.of(context).size.height / 30;

      final buttonFontSize = MediaQuery.of(context).size.width / 17;
      final buttonWidth = MediaQuery.of(context).size.width / 1.7;
      final buttonHeight = dividerHeight * 2.5;


      Settings settings = box.values.first;
      var lang = settings.language;
      var theme = settings.theme;

      return MaterialApp(
          home: Scaffold(
            appBar: AppBar(
                backgroundColor: themes[theme]['appBarBackgroundClr'],
                title: Text(labels['Program name'][lang], style: TextStyle(color: themes[theme]['appBarTextClr'])),
                centerTitle: true,
                actions: [
                  IconButton(
                    icon: Icon(Icons.question_mark, color: themes[theme]['appBarTextClr']),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => InfoScreen(
                        Text(labels['Rules text'][lang],  style: TextStyle(color: themes[theme]['primaryTextClr'], fontSize: buttonFontSize)),
                      )));
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.settings, color: themes[theme]['appBarTextClr']),
                    onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SettingsScreen())),
                  ),
                  IconButton(
                    icon: Icon(Icons.info_outline, color: themes[theme]['appBarTextClr']),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => InfoScreen(
                        Text(labels['About text'][lang], textAlign: TextAlign.center, style: TextStyle(color: themes[theme]['primaryTextClr'], fontSize: buttonFontSize)),
                          )));
                    },
                  ),
                ]),
            body: Container(
              decoration: BoxDecoration(
                color: themes[theme]['appBackgroundClr'],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        labels['Select size'][lang],
                        style: TextStyle(color: themes[theme]['secondaryTextClr'], fontSize: labelFontSize),
                      ),
                      Container(
                          width: buttonWidth,
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(top: labelFontSize / 1.5),
                          child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: themes[theme]['btnBorderClr'], width: 1),
                                  borderRadius: BorderRadius.circular(buttonWidth / 15),
                                ),
                                border: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: themes[theme]['btnBorderClr'], width: 1),
                                  borderRadius: BorderRadius.circular(buttonWidth / 15),
                                ),
                                filled: true,
                                fillColor: themes[theme]['btnClr'],
                              ),
                              dropdownColor: themes[theme]['btnClr'],
                              value: selectedSize,
                              onChanged: (int? newValue) {
                                setState(() => selectedSize = newValue);
                                if (newValue != null && newValue > 9) {
                                  showDialog(
                                      context: context,
                                      barrierColor: Colors.transparent,
                                      builder: (context) => AlertDialog(
                                        elevation: 10,
                                        backgroundColor: themes[theme]['dialogBackgroundClr'],
                                        title: Text(labels['Warning!'][lang], style: TextStyle(color: themes[theme]['primaryTextClr'])),
                                        content: Text(labels['Generating a 16 x 16 Sudoku can take a long time'][lang], style: TextStyle(color: themes[theme]['primaryTextClr'])),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(labels['OK'][lang], style: TextStyle(color: themes[theme]['secondaryTextClr'])))
                                        ],
                                      )
                                  );
                                }
                              },
                              items: availableSizes
                                  .map((dynamic size) => DropdownMenuItem<int>(
                                value: size,
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text("$size x $size",
                                      style: TextStyle(
                                          color: themes[theme]['primaryTextClr'], fontSize: buttonFontSize)),
                                ),
                              ))
                                  .toList())),
                      Divider(height: dividerHeight),
                      Text(
                        labels['Select difficulty'][lang],
                        style: TextStyle(color: themes[theme]['secondaryTextClr'], fontSize: labelFontSize),
                      ),
                      Container(
                          width: buttonWidth,
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(top: labelFontSize / 1.5),
                          child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: themes[theme]['btnBorderClr'], width: 1),
                                  borderRadius: BorderRadius.circular(buttonWidth / 15),
                                ),
                                border: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: themes[theme]['btnBorderClr'], width: 1),
                                  borderRadius: BorderRadius.circular(buttonWidth / 15),
                                ),
                                filled: true,
                                fillColor: themes[theme]['btnClr'],
                              ),
                              dropdownColor: themes[theme]['btnClr'],
                              value: selectedDifficulty,
                              onChanged: (Difficulty? newValue) {
                                setState(() => selectedDifficulty = newValue);
                              },
                              items: Difficulty.values
                                  .map((dynamic diff) => DropdownMenuItem<Difficulty>(
                                value: diff,
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                      labels[difficultyToString(diff)][lang],
                                      style: TextStyle(
                                          color: themes[theme]['primaryTextClr'], fontSize: buttonFontSize)),
                                ),
                              ))
                                  .toList())),
                      Divider(height: buttonHeight),
                      SizedBox(
                          width: buttonWidth,
                          height: buttonHeight,
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => GameScreen(game: SudokuGame.generate(
                                selectedDifficulty!, selectedSize!, countMistakes: settings.realtimeCheck)))),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: themes[theme]['btnClr'],
                              side: BorderSide(
                                color: themes[theme]['btnBorderClr'],
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(buttonWidth / 15),
                                ),
                              ),
                            ),
                            child: Text(
                              labels['Start game'][lang],
                              style: TextStyle(
                                  color: themes[theme]['primaryTextClr'],
                                  fontSize: buttonFontSize,
                                  fontWeight: FontWeight.normal),
                            ),
                          )),
                      Divider(height: dividerHeight),
                      SizedBox(
                          width: buttonWidth,
                          height: buttonHeight,
                          child: ValueListenableBuilder<Box<SudokuGameModel>>(
                            valueListenable: Hive.box<SudokuGameModel>('games').listenable(),
                            builder: (context, box, _) {
                              SudokuGame? game = SudokuGame.getCurrentGame(box: box);

                              return OutlinedButton(
                                onPressed: game != null
                                    ? () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => GameScreen(game: game)))
                                    : null,
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: themes[theme]['btnClr'],
                                  disabledBackgroundColor: themes[theme]['btnClrDisabled'],
                                  side: BorderSide(
                                    color: game != null ? themes[theme]['btnBorderClr'] : themes[theme]['btnBorderClrDisabled'],
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(buttonWidth / 15),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  labels['Continue'][lang],
                                  style: TextStyle(
                                      color:
                                      game != null ? themes[theme]['primaryTextClr'] : themes[theme]['secondaryTextClr'],
                                      fontSize: buttonFontSize,
                                      fontWeight: FontWeight.normal),
                                ),
                              );
                            },
                          )),
                      Divider(height: dividerHeight),
                      SizedBox(
                          width: buttonWidth,
                          height: buttonHeight,
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const StatScreen())),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: themes[theme]['btnClr'],
                              side: BorderSide(
                                color: themes[theme]['btnBorderClr'],
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(buttonWidth / 15),
                                ),
                              ),
                            ),
                            child: Text(
                              labels['Statistics'][lang],
                              style: TextStyle(
                                  color: themes[theme]['primaryTextClr'],
                                  fontSize: buttonFontSize,
                                  fontWeight: FontWeight.normal),
                            ),
                          )),
                    ],
                  )
                ],
              ),
            )
          ));
    });
  }
}
