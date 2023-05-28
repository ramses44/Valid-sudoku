import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:valid_sudoku/backend/database/models.dart';
import 'package:valid_sudoku/lang.dart';

import '../themes.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final labelFontSize = MediaQuery.of(context).size.height / 41;
    final dividerHeight = MediaQuery.of(context).size.height / 30;

    final buttonFontSize = MediaQuery.of(context).size.height / 32;
    final buttonWidth = MediaQuery.of(context).size.width / 1.7;
    final buttonHeight = dividerHeight * 2.5;

    return ValueListenableBuilder(
        valueListenable: Hive.box<Settings>('settings').listenable(),
        builder: (context, box, _) {
          Settings settings = box.values.first;
          var lang = settings.language;
          var theme = settings.theme;

          return MaterialApp(
              home: Scaffold(
                  appBar: AppBar(
                    backgroundColor: themes[theme]['appBarBackgroundClr'],
                    title: Text(labels['Settings'][lang]),
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
                            labels['Language'][lang],
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
                                  value: settings.language,
                                  onChanged: (newValue) {
                                    if (newValue != null) {
                                      settings.language = newValue;
                                      settings.save();
                                    }
                                  },
                                  items: languages.map((e) => DropdownMenuItem<String>(
                                    value: e,
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(labels['Language name'][e],
                                          style: TextStyle(
                                              color: themes[theme]['primaryTextClr'], fontSize: buttonFontSize)),
                                    ),
                                  )).toList())),
                          Divider(height: dividerHeight),
                          Text(
                            labels['Realtime mistakes check'][lang],
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
                                  value: settings.realtimeCheck,
                                  onChanged: (newValue) {
                                    if (newValue != null) {
                                      settings.realtimeCheck = newValue;
                                      settings.save();
                                    }
                                  },
                                  items: [
                                    DropdownMenuItem<bool>(
                                      value: true,
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(labels['Yes'][lang],
                                            style: TextStyle(
                                                color: themes[theme]['primaryTextClr'], fontSize: buttonFontSize)),
                                      ),
                                    ),
                                    DropdownMenuItem<bool>(
                                      value: false,
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(labels['No'][lang],
                                            style: TextStyle(
                                                color: themes[theme]['primaryTextClr'], fontSize: buttonFontSize)),
                                      ),
                                    )
                                  ]
                              )),
                          Divider(height: dividerHeight),
                          Text(
                            labels['Theme'][lang],
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
                                  value: theme,
                                  onChanged: (newValue) {
                                    if (newValue != null) {
                                      settings.theme = newValue;
                                      settings.save();
                                    }
                                  },
                                  items: List.generate(themes.length, (index) => DropdownMenuItem<int>(
                                    value: index,
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(labels[themes[index]['themeName']][lang],
                                          style: TextStyle(
                                              color: themes[theme]['primaryTextClr'], fontSize: buttonFontSize)),
                                    ),
                                  ))
                              )),
                          // ElevatedButton(onPressed: () => Hive.box<SudokuGameModel>('games').clear(), child: Text("qq"))
                        ],
                      )
                    ],
                  ),
                )
              )
          );
        }
    );
  }

}
