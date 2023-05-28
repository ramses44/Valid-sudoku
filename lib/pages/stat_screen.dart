import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../backend/database/models.dart';
import '../backend/sudoku.dart';
import '../lang.dart';
import '../themes.dart';

class StatScreen extends StatefulWidget {
  static const lastGamesCountForStat = 1000;

  const StatScreen({super.key});

  @override
  State<StatScreen> createState() => _StatScreenState();
}

class _StatScreenState extends State<StatScreen> {
  static const availableSizes = [4, 9, 16];
  int? selectedSize;
  Difficulty? selectedDifficulty;

  @override
  Widget build(BuildContext context) {
    Settings settings = Hive.box<Settings>('settings').values.first;
    var lang = settings.language;
    var theme = settings.theme;
    var games = Hive.box<SudokuGameModel>('games').values.take(1000).toList();

    final labelFontSize = MediaQuery.of(context).size.height / 41;
    final dividerHeight = MediaQuery.of(context).size.height / 30;

    final buttonFontSize = MediaQuery.of(context).size.height / 32;
    final buttonWidth = MediaQuery.of(context).size.width / 1.7;
    final buttonHeight = dividerHeight * 2;

    final statLabelWidth = MediaQuery.of(context).size.width / 1.2;
    final statLabelHeight = MediaQuery.of(context).size.height / 3;
    final statLabelFontSize = MediaQuery.of(context).size.width / 17;

    return MaterialApp(
              home: Scaffold(
                  appBar: AppBar(
                    backgroundColor: themes[theme]['appBarBackgroundClr'],
                    title: Text(labels['Statistics'][lang]),
                    centerTitle: true,
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back, color: themes[theme]['appBarTextClr']),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  body: Container(
                    decoration: BoxDecoration(
                      color: themes[theme]['appBackgroundClr'],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Divider(height: 25),
                            Text(
                              labels['Select size'][lang],
                              style: TextStyle(color: themes[theme]['secondaryTextClr'], fontSize: labelFontSize),
                            ),
                            Container(
                                width: buttonWidth,
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(top: labelFontSize / 1.5),
                                child: DropdownButtonFormField(
                                    isDense: false,
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
                                      enabledBorder: OutlineInputBorder(
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
                                    },
                                    items: [DropdownMenuItem<int>(value: null, child: Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(labels['All'][lang],
                                          style: TextStyle(
                                              color: themes[theme]['primaryTextClr'], fontSize: buttonFontSize)),
                                    ))] + availableSizes
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
                                    isDense: false,
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
                                      enabledBorder: OutlineInputBorder(
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
                                    items: [DropdownMenuItem<Difficulty>(value: null, child: Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(labels['All'][lang],
                                          style: TextStyle(
                                              color: themes[theme]['primaryTextClr'], fontSize: buttonFontSize)),
                                    ))] + Difficulty.values
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
                            Divider(height: dividerHeight * 2),
                            Container(
                              width: statLabelWidth,
                              height: statLabelHeight,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(buttonWidth / 15),
                                border: Border.all(color: themes[theme]['btnBorderClr'], width: 1),
                                color: themes[theme]['statLabelClr']
                              ),
                              child: Builder(
                                builder: (context) {
                                  var selectedGames = games.where((game) => (selectedSize != null ? game.sudoku['size'] == selectedSize : true) && (selectedDifficulty != null ? difficultyFromInt(game.difficulty) == selectedDifficulty : true)).toList();
                                  var withMistakesCount = selectedGames.where((game) => game.mistakes != null).toList();

                                  var totalTime = 0;
                                  var totalHints = 0;
                                  var mistakes = 0;
                                  selectedGames.forEach((game) {
                                    totalTime += game.time;
                                    totalHints += game.hintsUsed;
                                    mistakes += game.mistakes ?? 0;
                                  });

                                  timeBuilder(double time) {
                                    int sec = time.toInt() % 60;
                                    int min = time.toInt() ~/ 60;
                                    String minute = min.toString().length <= 1 ? "0$min" : "$min";
                                    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
                                    return "$minute : $second";
                                  }

                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        "${labels['Total games'][lang]}: ${selectedGames.length}", style: TextStyle(
                                          color: themes[theme]['primaryTextClr'], fontSize: statLabelFontSize, fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "${labels['Sudoku solved'][lang]}: ${selectedGames.where((game) => game.isSolved).length}", style: TextStyle(
                                          color: themes[theme]['primaryTextClr'], fontSize: statLabelFontSize, fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "${labels['Average time'][lang]}: ${selectedGames.isEmpty ? '--' : timeBuilder(totalTime / selectedGames.length)}", style: TextStyle(
                                          color: themes[theme]['primaryTextClr'], fontSize: statLabelFontSize, fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "${labels['Total hints taken'][lang]}: ${totalHints}", style: TextStyle(
                                          color: themes[theme]['primaryTextClr'], fontSize: statLabelFontSize, fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "${labels['Average mistakes count'][lang]}: ${withMistakesCount.isEmpty ? '--' : mistakes ~/ withMistakesCount.length}", style: TextStyle(
                                          color: themes[theme]['primaryTextClr'], fontSize: statLabelFontSize, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  );
                                },
                              )

                            )
                          ],
                        )
                      ],
                    ),
                  )
              )
          );



  }
}