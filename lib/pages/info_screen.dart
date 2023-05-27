import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:valid_sudoku/backend/database/models.dart';
import 'package:valid_sudoku/lang.dart';

import '../themes.dart';

class InfoScreen extends StatelessWidget {
  final Widget _widget;

  const InfoScreen(this._widget, {super.key});

  @override
  Widget build(BuildContext context) {
    final buttonWidth = MediaQuery.of(context).size.width / 1.7;
    final infoLabelWidth = MediaQuery.of(context).size.width / 1.2;

    Settings settings = Hive.box<Settings>('settings').values.first;
    var lang = settings.language;
    var theme = settings.theme;

    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              backgroundColor: themes[theme]['appBarBackgroundClr'],
              title: Text(labels['Info'][lang]),
              centerTitle: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: themes[theme]['appBarTextClr']),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: themes[theme]['appBackgroundClr'],
              ),
              child: Align(
                alignment: Alignment.center,
                child: Container(
                    padding: const EdgeInsets.all(10),
                    width: infoLabelWidth,
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(buttonWidth / 15),
                        border: Border.all(color: themes[theme]['btnBorderClr'], width: 1),
                        color: themes[theme]['statLabelClr']
                    ),
                      child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: _widget
                      ),
                ),
              )
            )
        )
    );
  }

}
