import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:valid_sudoku/backend/sudoku.dart';
import 'package:flutter/src/foundation/change_notifier.dart';

import 'database/models.dart';

class SudokuGame {
  late SudokuGameModel model;
  late ValueNotifier<Sudoku> sudoku;
  late ValueNotifier<bool> isSolved = ValueNotifier(false);

  SudokuGame(this.model) : sudoku = ValueNotifier(sudokuFromJson(model.sudoku)) {
    sudoku.addListener(syncModelWithSudoku);
  }

  SudokuGame.generate(Difficulty difficulty, int size,
      {bool countMistakes = true})
      : sudoku = ValueNotifier(SudokuBuilder(size).build(difficulty)) {
    model = SudokuGameModel(difficultyToInt(difficulty), sudokuToJson(sudoku.value),
        countMistakes: countMistakes);
    Hive.box<SudokuGameModel>('games').add(model);
    sudoku.addListener(syncModelWithSudoku);
  }

  SudokuGame.fromId(int id) {
    SudokuGameModel? got = Hive.box<SudokuGameModel>('games').get(id);

    if (got == null) {
      throw ArgumentError("Game with id $id not found!");
    }

    model = got;
    sudoku = ValueNotifier(sudokuFromJson(model.sudoku));
  }

  static SudokuGame? getCurrentGame({Box? box}) {
    box = box ?? Hive.box<SudokuGameModel>('games');
    SudokuGame? res;
    for (var model in box.values) {
      if (model.inProcess) {
        if (res != null) {
          res.model.inProcess = false;
          res.model.save();
        }
        res = SudokuGame(model);
      }
    }

    return res;
  }

  void incTime() {
    model.time++;
    updateDB();
  }

  void _checkCorrect(int number, int x, int y) {
    if (sudoku.value[x][y].initial ||
        x < 0 ||
        y < 0 ||
        x >= sudoku.value.size() ||
        y >= sudoku.value.size()) {
      throw ArgumentError("Bad coordinates of cell");
    }

    if (number < 0 || number > sudoku.value.size()) {
      throw ArgumentError("Bad number");
    }
  }

  bool setNumber(int number, int x, int y) {
    _checkCorrect(number, x, y);
    var mistake = sudoku.value.setNumber(number, x, y);

    if (number != 0 && !mistake && model.mistakes != null) {
      model.mistakes = model.mistakes! + 1;
    } else if (sudoku.value.isSolved()) {
      model.inProcess = false;
      isSolved.value = model.isSolved = true;
      isSolved.notifyListeners();
    }

    model.sudoku['field'][x][y]['number'] = number;
    model.sudoku['field'][x][y]['noted'].clear();
    
    sudoku.notifyListeners();
    updateDB();

    return !mistake;
  }

  void changeNote(int number, int x, int y) {
    _checkCorrect(number, x, y);

    if (sudoku.value[x][y].noted.contains(number)) {
      sudoku.value[x][y].noted.remove(number);
    } else {
      sudoku.value[x][y].noted.add(number);
    }

    sudoku.notifyListeners();
    updateDB();
  }

  void takeHint(int x, int y) {
    _checkCorrect(0, x, y);

    sudoku.value[x][y].number = sudoku.value[x][y].expectedNumber;
    sudoku.value[x][y].initial = true;
    sudoku.value[x][y].noted.clear();

    model.hintsUsed++;

    if (sudoku.value.isSolved()) {
      model.inProcess = false;
      isSolved.value = model.isSolved = true;
      isSolved.notifyListeners();
    }

    sudoku.notifyListeners();
    updateDB();
  }

  void updateDB() {
    model.save();
  }

  void syncModelWithSudoku() {
    model.sudoku = sudokuToJson(sudoku.value);
  }

  String get timeStr {
      int sec = model.time % 60;
      int min = model.time ~/ 60;
      String minute = min.toString().length <= 1 ? "0$min" : "$min";
      String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
      return "$minute : $second";
  }

  int get id {
    return model.key as int;
  }
}
