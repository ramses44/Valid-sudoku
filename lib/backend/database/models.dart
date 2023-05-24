import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:valid_sudoku/backend/sudoku.dart';

part 'models.g.dart';

Map cellToJson(Cell cell) {
  return {
    'number': cell.number,
    'expectedNumber': cell.expectedNumber,
    'initial': cell.initial ? 1 : 0,
    'noted': cell.noted.toList()
  };
}

Cell cellFromJson(Map json) {
  return Cell()
    ..number = json['number']
    ..expectedNumber = json['expectedNumber']
    ..initial = json['initial'] == 1
    ..noted = json['noted'].toSet();
}

Map sudokuToJson(Sudoku sudoku) {
  return {
    'size': sudoku.size(),
    'field': List.generate(sudoku.size(),
        (i) => List.generate(sudoku.size(), (j) => cellToJson(sudoku[i][j])))
  };
}

Sudoku sudokuFromJson(Map json) {
  return Sudoku.fromMatrix(List.generate(
      json['size'],
      (i) => List.generate(
          json['size'], (j) => cellFromJson(json['field'][i][j]))));
}

int difficultyToInt(Difficulty difficulty) {
  switch (difficulty) {
    case Difficulty.easy:
      return 1;
    case Difficulty.medium:
      return 2;
    case Difficulty.hard:
      return 3;
  }

  throw TypeError();
}

Difficulty difficultyFromInt(int diff) {
  switch (diff) {
    case 1:
      return Difficulty.easy;
    case 2:
      return Difficulty.medium;
    case 3:
      return Difficulty.hard;
  }

  throw TypeError();
}

@HiveType(typeId: 0)
class SudokuGameModel extends HiveObject {
  @HiveField(0)
  int difficulty;

  @HiveField(1)
  Map sudoku;

  @HiveField(2)
  int time = 0;

  @HiveField(3)
  int? mistakes;

  @HiveField(4)
  int hintsUsed = 0;

  @HiveField(5)
  bool inProcess = true;

  @HiveField(6)
  bool isSolved = false;

  SudokuGameModel(this.difficulty, this.sudoku, {bool countMistakes = true})
      : mistakes = countMistakes ? 0 : null;
}

@HiveType(typeId: 1)
class Settings extends HiveObject {
  @HiveField(0)
  String language = 'EN';

  @HiveField(1)
  bool realtimeCheck = true;

  @HiveField(2)
  int theme = 0;
}
