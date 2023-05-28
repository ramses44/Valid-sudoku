import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:valid_sudoku/backend/game.dart';
import 'package:valid_sudoku/backend/sudoku.dart';
import 'package:valid_sudoku/backend/database/models.dart';
import 'package:valid_sudoku/lang.dart';
import 'package:yandex_mobileads/mobile_ads.dart';

import '../themes.dart';

const kMaxButtonsInRow = 9;

class GameScreen extends StatefulWidget {
  final SudokuGame game;

  const GameScreen({super.key, required this.game});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with WidgetsBindingObserver {
  int? xSelected, ySelected;
  int? numberSelected;
  bool notesMode = false;
  bool eraseMode = false;
  bool paused = false;

  late final Timer _timer;

  @override
  void initState() {
    MobileAds.initialize();
    WidgetsBinding.instance.addObserver(this);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!paused) {
        widget.game.incTime();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Sudoku get sudoku {
    return widget.game.sudoku.value;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      _pause();
    }
  }

  void _pause() {
    setState(() => paused = true);

    Settings settings = Hive.box<Settings>('settings').values.first;
    var lang = settings.language;
    var theme = settings.theme;

    showDialog(
        context: context,
        barrierColor: Colors.transparent,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: AlertDialog(
              elevation: 10,
              backgroundColor: themes[theme]['dialogBackgroundClr'],
              title: Text(labels['Program name'][lang], style: TextStyle(color: themes[theme]['primaryTextClr'])),
              content: Text(labels['Game on pause!'][lang], style: TextStyle(color: themes[theme]['primaryTextClr'])),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() {
                        paused = false;
                      });
                    },
                    child: Text(labels['Continue'][lang], style: TextStyle(color: themes[theme]['secondaryTextClr'])))
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Settings settings = Hive.box<Settings>('settings').values.first;
    var lang = settings.language;
    var theme = settings.theme;

    final timerFieldHeight = MediaQuery.of(context).size.height / 10;

    final cellSize = min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height) / (sudoku.size() + 2);
    final tableFontSize = MediaQuery.of(context).size.height / 13 / sudoku.subSize();
    final noteInCellWidth = cellSize / sudoku.subSize(), noteInCellHeight = cellSize / (sudoku.subSize() + 0.5);
    final noteFontSize = tableFontSize * 1.2 / sudoku.subSize();

    final numberButtonFontSize = MediaQuery.of(context).size.height / 30;
    final numberButtonSize = MediaQuery.of(context).size.width / (min(kMaxButtonsInRow, sudoku.size()) + 2);

    final actionButtonSize = MediaQuery.of(context).size.width / 3.5;
    final actionButtonFontSize = MediaQuery.of(context).size.width / 30;

    final dividerHeight = cellSize;

    final bannerHeight = MediaQuery.of(context).size.height * 0.9 - timerFieldHeight * 1.4 - cellSize * sudoku.size() - numberButtonSize * (sudoku.size() ~/ kMaxButtonsInRow) - actionButtonSize - dividerHeight * 2;

    print(bannerHeight);
    final banner = BannerAd(
      adUnitId: 'demo-interstitial-yandex',
      // Flex-size
      adSize: AdSize.flexible(width: MediaQuery.of(context).size.width.toInt(), height: bannerHeight.toInt()),
      // Sticky-size
      //adSize: AdSize.sticky(width: MediaQuery.of(context).size.width.toInt()),
      adRequest: const AdRequest(),
      onAdLoaded: () {
        /* Do something */
      },
      onAdFailedToLoad: (error) {
        /* Do something */
      },
    );

    return ValueListenableBuilder(
        valueListenable: widget.game.isSolved,
        builder: (context, isSolved, _) {
          if (isSolved) {
            paused = true;
            xSelected = ySelected = numberSelected = null;
            notesMode = eraseMode = false;
            _timer.cancel();

            return MaterialApp(
                home: Scaffold(
                    appBar: AppBar(
                      backgroundColor: themes[theme]['appBarBackgroundClr'],
                      title: Text(
                        "${widget.game.sudoku.value.size()} x "
                        "${widget.game.sudoku.value.size()}, "
                        "${labels[difficultyToString(difficultyFromInt(widget.game.model.difficulty))][lang]}",
                        style: TextStyle(color: themes[theme]['appBarTextClr']),
                      ),
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: timerFieldHeight / 5,
                                    ),
                                    width: timerFieldHeight * 2,
                                    height: timerFieldHeight,
                                    child: ElevatedButton.icon(
                                      icon: Icon(Icons.timer_outlined, color: themes[theme]['timerLabelTextClr']),
                                      onPressed: null,
                                      label: Text(
                                        widget.game.timeStr,
                                        style: TextStyle(color: themes[theme]['timerLabelTextClr'], fontSize: numberButtonFontSize),
                                      ),
                                    ),
                                  ),
                                  const Divider(height: 10),
                                  Table(
                                      border: TableBorder.all(color: themes[theme]['tableBorderClr'], width: 1.75),
                                      defaultColumnWidth: FixedColumnWidth(cellSize * sudoku.subSize()),
                                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                      children: List<TableRow>.generate(
                                          sudoku.subSize(),
                                          (i) => TableRow(
                                                children: List<Widget>.generate(
                                                    sudoku.subSize(),
                                                    (j) => Table(
                                                          border: TableBorder.all(color: themes[theme]['tableBorderClr'], width: 1),
                                                          defaultColumnWidth: FixedColumnWidth(cellSize),
                                                          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                                          children: List<TableRow>.generate(
                                                              sudoku.subSize(),
                                                              (ii) => TableRow(
                                                                      children: List<Widget>.generate(sudoku.subSize(), (jj) {
                                                                    int x = i * sudoku.subSize() + ii;
                                                                    int y = j * sudoku.subSize() + jj;

                                                                    var number = sudoku[x][y].number;
                                                                    var color = Colors.transparent;

                                                                    return Container(
                                                                        height: cellSize,
                                                                        width: cellSize,
                                                                        alignment: Alignment.center,
                                                                        color: color,
                                                                        child: TextButton(
                                                                            style: ButtonStyle(
                                                                                overlayColor: MaterialStateProperty.all(Colors.transparent),
                                                                                enableFeedback: false,
                                                                                padding: const MaterialStatePropertyAll(EdgeInsets.all(1))),
                                                                            onPressed: null,
                                                                            child: Text(
                                                                              sudoku[x][y].toString(),
                                                                              textAlign: TextAlign.center,
                                                                              style: TextStyle(fontSize: tableFontSize, color: themes[theme]['primaryTextClr']),
                                                                            )));
                                                                  }))),
                                                        )),
                                              ))),
                                  Divider(height: dividerHeight),
                                  Text(
                                    labels['Congratulations!'][lang],
                                    style: TextStyle(color: themes[theme]['congratulationsTextClr'], fontSize: numberButtonFontSize, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    labels['You have solved this sudoku'][lang],
                                    style: TextStyle(color: themes[theme]['congratulationsTextClr'], fontSize: numberButtonFontSize, fontWeight: FontWeight.bold),
                                  ),
                                  Divider(height: dividerHeight),
                                  widget.game.model.mistakes != null
                                      ? Text(
                                          "${labels['Mistakes'][lang]}: ${widget.game.model.mistakes}",
                                          style: TextStyle(
                                            color: themes[theme]['primaryTextClr'],
                                            fontSize: numberButtonFontSize,
                                          ),
                                        )
                                      : const Divider(height: 0),
                                  Text(
                                    "${labels['Hints used'][lang]}: ${widget.game.model.hintsUsed}",
                                    style: TextStyle(
                                      color: themes[theme]['primaryTextClr'],
                                      fontSize: numberButtonFontSize,
                                    ),
                                  ),
                                ],
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: AdWidget(bannerAd: banner),
                              ),
                            ])
                          ],
                        ))));
          } else {
            return MaterialApp(
                home: Scaffold(
                    appBar: AppBar(
                      backgroundColor: themes[theme]['appBarBackgroundClr'],
                      title: Text(
                        "${widget.game.sudoku.value.size()} x "
                        "${widget.game.sudoku.value.size()}, "
                        "${labels[difficultyToString(difficultyFromInt(widget.game.model.difficulty))][lang]}",
                        style: TextStyle(color: themes[theme]['appBarTextClr']),
                      ),
                      centerTitle: true,
                      leading: IconButton(
                        icon: Icon(Icons.arrow_back, color: themes[theme]['appBarTextClr']),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      actions: [
                        IconButton(
                            icon: Icon(Icons.pause, color: themes[theme]['appBarTextClr']),
                            onPressed: _pause),
                      ],
                    ),
                    body: Container(
                        decoration: BoxDecoration(
                          color: themes[theme]['appBackgroundClr'],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: timerFieldHeight / 5,
                                    ),
                                    width: timerFieldHeight * 2,
                                    height: timerFieldHeight,
                                    child: ElevatedButton.icon(
                                        icon: Icon(Icons.timer_outlined, color: themes[theme]['timerLabelTextClr']),
                                        onPressed: null,
                                        label: ValueListenableBuilder(
                                          valueListenable: Hive.box<SudokuGameModel>('games').listenable(),
                                          builder: (___, __, _) => Text(
                                            widget.game.timeStr,
                                            style: TextStyle(color: themes[theme]['timerLabelTextClr'], fontSize: numberButtonFontSize),
                                          ),
                                        )),
                                  ),
                                  Divider(height: dividerHeight / 3),
                                  ValueListenableBuilder(
                                      valueListenable: widget.game.sudoku,
                                      builder: (context, sudoku, _) => Table(
                                          border: TableBorder.all(color: themes[theme]['tableBorderClr'], width: 1.75),
                                          defaultColumnWidth: FixedColumnWidth(cellSize * sudoku.subSize()),
                                          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                          children: List<TableRow>.generate(
                                              sudoku.subSize(),
                                              (i) => TableRow(
                                                    children: List<Widget>.generate(
                                                        sudoku.subSize(),
                                                        (j) => Table(
                                                              border: TableBorder.all(color: themes[theme]['tableBorderClr'], width: 1),
                                                              defaultColumnWidth: FixedColumnWidth(cellSize),
                                                              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                                              children: List<TableRow>.generate(
                                                                  sudoku.subSize(),
                                                                  (ii) => TableRow(
                                                                          children: List<Widget>.generate(sudoku.subSize(), (jj) {
                                                                        int x = i * sudoku.subSize() + ii;
                                                                        int y = j * sudoku.subSize() + jj;

                                                                        var number = sudoku[x][y].number;
                                                                        var color = Colors.transparent;
                                                                        if (sudoku[x][y].number == numberSelected || x == xSelected && y == ySelected) {
                                                                          color = themes[theme]['tablePrimarySelectedClr'];
                                                                        } else if (x == xSelected || y == ySelected) {
                                                                          color = themes[theme]['tableSecondarySelectedClr'];
                                                                        }

                                                                        return Container(
                                                                            height: cellSize,
                                                                            width: cellSize,
                                                                            alignment: Alignment.center,
                                                                            color: color,
                                                                            child: TextButton(
                                                                                style: ButtonStyle(
                                                                                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                                                                                    enableFeedback: false,
                                                                                    padding: const MaterialStatePropertyAll(EdgeInsets.all(1))),
                                                                                onPressed: () => setState(() {
                                                                                      if (eraseMode) {
                                                                                        widget.game.setNumber(0, x, y);
                                                                                        return;
                                                                                      }

                                                                                      if (xSelected == x && ySelected == y) {
                                                                                        xSelected = ySelected = null;
                                                                                        numberSelected = null;
                                                                                      } else {
                                                                                        xSelected = x;
                                                                                        ySelected = y;
                                                                                        numberSelected = sudoku[x][y].number != 0 ? sudoku[x][y].number : null;
                                                                                      }
                                                                                    }),
                                                                                child: number != 0
                                                                                    ? Text(
                                                                                        sudoku[x][y].toString(),
                                                                                        textAlign: TextAlign.center,
                                                                                        style: TextStyle(
                                                                                            fontSize: tableFontSize,
                                                                                            color: sudoku[x][y].initial
                                                                                                ? themes[theme]['tableInitialTextClr']
                                                                                                : (sudoku[x][y].number == sudoku[x][y].expectedNumber
                                                                                                    ? themes[theme]['tableGuessedTextClr']
                                                                                                    : themes[theme]['tableWrongTextClr'])),
                                                                                      )
                                                                                    : Table(
                                                                                        defaultColumnWidth: FixedColumnWidth(noteInCellWidth),
                                                                                        children: List<TableRow>.generate(
                                                                                            sudoku.subSize(),
                                                                                            (i) => TableRow(
                                                                                                children: List<Widget>.generate(
                                                                                                    sudoku.subSize(),
                                                                                                    (j) => Container(
                                                                                                          height: noteInCellHeight,
                                                                                                          decoration: sudoku[x][y].noted.contains(i * sudoku.subSize() + j + 1) &&
                                                                                                                  i * sudoku.subSize() + j + 1 == numberSelected
                                                                                                              ? BoxDecoration(
                                                                                                                  shape: BoxShape.circle,
                                                                                                                  color: themes[theme]['tablePrimarySelectedClr'])
                                                                                                              : null,
                                                                                                          child: Text(
                                                                                                            sudoku[x][y].noted.contains(i * sudoku.subSize() + j + 1)
                                                                                                                ? Cell(i * sudoku.subSize() + j + 1).toString()
                                                                                                                : " ",
                                                                                                            textAlign: TextAlign.center,
                                                                                                            style: TextStyle(
                                                                                                                color: themes[theme]['tableNoteTextClr'], fontSize: noteFontSize),
                                                                                                          ),
                                                                                                        )))),
                                                                                      )));
                                                                      }))),
                                                            )),
                                                  )))),
                                  Divider(height: dividerHeight),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(
                                      sudoku.size() ~/ kMaxButtonsInRow + 1,
                                      (part) => Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: List<Widget>.generate(min(kMaxButtonsInRow, sudoku.size() - part * kMaxButtonsInRow), (num) {
                                          num += part * kMaxButtonsInRow + 1;
                                          return Container(
                                            width: numberButtonSize + 4,
                                            padding: const EdgeInsets.symmetric(horizontal: 2),
                                            child: OutlinedButton(
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStatePropertyAll(num == numberSelected ? themes[theme]['numberBtnClrSelected'] : themes[theme]['numberBtnClr']),
                                                  padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 10))),
                                              onPressed: () {
                                                setState(() {
                                                  eraseMode = false;
                                                  numberSelected = numberSelected == num ? null : num;
                                                  if (xSelected != null && ySelected != null) {
                                                    if (notesMode) {
                                                      widget.game.changeNote(num, xSelected!, ySelected!);
                                                    } else {
                                                      widget.game.setNumber(num, xSelected!, ySelected!);
                                                    }
                                                  }
                                                });
                                              },
                                              child: Text(
                                                Cell.symbols[num],
                                                style: TextStyle(color: themes[theme]['numberBtnTextClr'], fontSize: numberButtonFontSize),
                                              ),
                                            ),
                                          );
                                        }),
                                      ),
                                    ),
                                  ),
                                  Divider(height: dividerHeight / 2),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: actionButtonSize + 16,
                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                        child: OutlinedButton.icon(
                                          style: ButtonStyle(
                                              padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 2, vertical: 10)),
                                              backgroundColor: MaterialStatePropertyAll(eraseMode ? themes[theme]['actionBtnClrSelected'] : themes[theme]['actionBtnClr'])),
                                          onPressed: () => setState(() {
                                            eraseMode = !eraseMode;
                                            numberSelected = null;
                                          }),
                                          icon: Icon(eraseMode ? Icons.circle : Icons.circle_outlined, color: themes[theme]['actionBtnTextClr']),
                                          label: Text(
                                            labels['Erase'][lang],
                                            style: TextStyle(color: themes[theme]['actionBtnTextClr'], fontSize: actionButtonFontSize),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: actionButtonSize + 16,
                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                        child: OutlinedButton.icon(
                                          style: ButtonStyle(
                                              padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 2, vertical: 10)),
                                              backgroundColor: MaterialStatePropertyAll(notesMode ? themes[theme]['actionBtnClrSelected'] : themes[theme]['actionBtnClr'])),
                                          onPressed: () => setState(() {
                                            notesMode = !notesMode;
                                          }),
                                          icon: Icon(
                                            notesMode ? Icons.note_alt : Icons.note_alt_outlined,
                                            color: themes[theme]['actionBtnTextClr'],
                                          ),
                                          label: Text(
                                            labels['Notes'][lang],
                                            style: TextStyle(color: themes[theme]['actionBtnTextClr'], fontSize: actionButtonFontSize),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: actionButtonSize + 16,
                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                        child: OutlinedButton.icon(
                                          style: ButtonStyle(
                                              padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 2, vertical: 10)),
                                              backgroundColor: MaterialStatePropertyAll(themes[theme]['actionBtnClr'])),
                                          onPressed: xSelected == null || sudoku[xSelected!][ySelected!].initial
                                              ? null
                                              : () {
                                                  widget.game.takeHint(xSelected!, ySelected!);
                                                },
                                          icon: Icon(
                                            Icons.help_center_outlined,
                                            color: themes[theme]['actionBtnTextClr'],
                                          ),
                                          label: Text(
                                            labels['Hint'][lang],
                                            style: TextStyle(color: themes[theme]['actionBtnTextClr'], fontSize: actionButtonFontSize),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child:  AdWidget(bannerAd: banner),
                              ),
                            ])
                          ],
                        ))));
          }
        });
  }
}
