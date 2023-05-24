import 'dart:math';

const int intMaxValue = 9223372036854775807;

class Cell {
  static const symbols = " 123456789abcdefghijklmnopqrstuvwxyz#";
  int number = 0; // Number on the field in the process of solving
  int expectedNumber = 0; // The number that must be in the correct solution
  bool initial = true; // Is the number in this cell was set by computer
  Set<int> noted = {}; // Just a list of user notes in this cell

  Cell([int numb = 0]) {
    number = expectedNumber = numb;
  }

  Cell.from(Cell rhs)
      : number = rhs.number,
        expectedNumber = rhs.expectedNumber,
        initial = rhs.initial,
        noted = Set.from(rhs.noted);

  void swapNumbers(Cell rhs) {
    int num = number, expNum = expectedNumber;
    number = rhs.number;
    expectedNumber = rhs.expectedNumber;
    rhs.number = num;
    rhs.expectedNumber = expNum;
  }

  @override
  String toString() {
    return symbols[number];
  }

  @override
  bool operator ==(Object rhs) {
    rhs = rhs as Cell;
    return number == rhs.number &&
        expectedNumber == rhs.expectedNumber &&
        noted == rhs.noted &&
        initial == rhs.initial;
  }
}

class Sudoku {
  // Check is number a square
  static bool isValidSize(int size) {
    return sqrt(size) * sqrt(size) == size;
  }

  final int _size;
  List<List<Cell>> _field = [];

  Sudoku(this._size) {
    if (!isValidSize(_size)) {
      throw ArgumentError("Invalid size!");
    }

    _field = List.filled(_size, List.filled(_size, Cell()));
  }

  // Build solved sudoku from a 2-dimension list of numbers (1-9)
  Sudoku.fromMatrix(List<List<Cell>> matrix) : _size = matrix.length {
    if (!isValidSize(_size)) {
      throw ArgumentError("Invalid size!");
    }
    _field =
        List.generate(_size, (i) => List.generate(_size, (j) => matrix[i][j]));
  }

  Sudoku.from(Sudoku rhs) : _size = rhs._size {
    _field = List.generate(
        _size, (i) => List.generate(_size, (j) => Cell.from(rhs._field[i][j])));
  }

  // Returns a size of field
  int size() {
    return _size;
  }

  // Returns a size of field section
  int subSize() {
    return sqrt(_size).toInt();
  }

  int cellsCount() {
    return _size * _size;
  }

  @override
  String toString() {
    List<String> res = ['┌'];
    for (int i = 0; i < _size; ++i) {
      res += ['─', '┬'];
    }
    res.last = '┐';
    res += ['\n'];

    for (int i = 0; i < _size; ++i) {
      res += ['│'];
      for (int j = 0; j < _size; ++j) {
        res += [_field[i][j].toString(), '│'];
      }
      res += ['\n'];

      res += ['├'];
      for (int j = 0; j < _size; ++j) {
        res += ['─', '┼'];
      }
      res.last = '┤';
      res += ['\n'];
    }

    res[res.length - _size * 2 - 2] = '└';
    res[res.length - 2] = '┘';

    for (int i = 1; i < _size; ++i) {
      res[res.length - i * 2 - 2] = '┴';
    }
    res += ['\n'];

    return res.join('');
  }

  @override
  int get hashCode {
    int res = 0;
    int rad = 1;

    _field.forEach((line) {
      res += line.map((e) => e.number).fold(0, (prev, el) => prev + el) * rad;
      rad *= _size * _size;
    });

    return res;
  }

  @override
  bool operator ==(Object rhs) {
    rhs = rhs as Sudoku;
    if (rhs.runtimeType != Sudoku || _size != rhs._size) {
      return false;
    }

    for (int i = 0; i < _size; ++i) {
      for (int j = 0; j < _size; ++j) {
        if (_field[i][j] != rhs._field[i][j]) {
          return false;
        }
      }
    }

    return true;
  }

  // Check are there no collisions in the solving
  bool isValid() {
    var counter = [];

    // Checking lines
    for (int i = 0; i < _size; ++i) {
      counter = List.filled(_size + 1, 0);

      for (int j = 0; j < _size; ++j) {
        if (_field[i][j].number != 0 && ++counter[_field[i][j].number] > 1) {
          return false;
        }
      }
    }

    // Checking columns
    for (int i = 0; i < _size; ++i) {
      counter = List.filled(_size + 1, 0);

      for (int j = 0; j < _size; ++j) {
        if (_field[j][i].number != 0 && ++counter[_field[j][i].number] > 1) {
          return false;
        }
      }
    }

    // Checking squares
    var subSize = sqrt(_size).toInt();

    for (int i = 0; i < subSize; ++i) {
      for (int j = 0; j < subSize; ++j) {
        counter = List.filled(_size + 1, 0);

        for (int ii = 0; ii < subSize; ++ii) {
          for (int jj = 0; jj < subSize; ++jj) {
            if (_field[i * subSize + ii][j * subSize + jj].number != 0 &&
                ++counter[_field[i * subSize + ii][j * subSize + jj].number] >
                    1) {
              return false;
            }
          }
        }
      }
    }

    return true;
  }

  operator [](int i) => _field[i];

  // Set number in the cell.
  // If there is an incorrect field in the result, return false
  bool setNumber(int number, int row, int col) {
    _field[row][col].noted.clear();
    _field[row][col].number = number;

    int secRow = row ~/ subSize();
    int secCol = col ~/ subSize();

    for (int i = 0; i < _size; ++i) {
      _field[row][i].noted.remove(number);
    }
    for (int i = 0; i < _size; ++i) {
      _field[i][col].noted.remove(number);
    }
    for (int i = 0; i < subSize(); ++i) {
      for (int j = 0; j < subSize(); ++j) {
        _field[secRow * subSize() + i][secCol * subSize() + j]
            .noted
            .remove(number);
      }
    }

    return number == _field[row][col].expectedNumber;
  }

  // Check no empty cells (zeros) on the field
  bool isFilled() {
    return !_field.any((line) => line.any((cell) => cell.number == 0));
  }

  bool isSolved() {
    for (var row in _field) {
      for (var cell in row) {
        if (cell.number != cell.expectedNumber) {
          return false;
        }
      }
    }
    return true;
  }
}

enum Difficulty { easy, medium, hard }

enum Dimension { vertical, horizontal }

class SudokuBuilder {
  static const shuffleStepsInGenerating = 20;
  static const simpleFilledPercentHighBorder = 0.57;
  static const mediumFilledPercentHighBorder = 0.63;
  static const hardFilledPercentHighBorder = 0.70;
  static const hardFilledPercentLowBorder = 0.79;

  // Returns the correct "base" sudoku field (as matrix [size x size])
  static List<List<Cell>> getBaseField(int size) {
    if (!Sudoku.isValidSize(size)) {
      throw ArgumentError("Invalid size!");
    }

    int n = sqrt(size).toInt();
    return List.generate(
        size,
        (i) => List.generate(
            size, (j) => Cell(((i * n + i / n + j) % (n * n) + 1).toInt())));
  }

  Sudoku sudoku;

  SudokuBuilder(int size) : sudoku = Sudoku(size);

  // Generate random solved sudoku field
  void _generateField() {
    sudoku = Sudoku.fromMatrix(getBaseField(sudoku._size));
    var rand = Random();

    for (int i = 0; i < shuffleStepsInGenerating; ++i) {
      switch (rand.nextInt(5)) {
        case 0:
          _transpose();
          break;
        case 1:
          _reverse(rand.nextBool() ? Dimension.horizontal : Dimension.vertical);
          break;
        case 2:
          var section = rand.nextInt(sudoku.subSize());
          _swapLines(
              rand.nextBool() ? Dimension.horizontal : Dimension.vertical,
              section * sudoku.subSize() + rand.nextInt(sudoku.subSize()),
              section * sudoku.subSize() + rand.nextInt(sudoku.subSize()));
          break;
        case 3:
          _swapSections(
              rand.nextBool() ? Dimension.horizontal : Dimension.vertical,
              rand.nextInt(sudoku.subSize()),
              rand.nextInt(sudoku.subSize()));
          break;
        case 4:
          _swapNumbers(
              rand.nextInt(sudoku._size) + 1, rand.nextInt(sudoku._size) + 1);
      }
    }
  }

  // Try to erase number in random cell (if it will be possible to solve sudoku)
  bool _tryThrowCell(Difficulty difficulty) {
    var rand = Random();
    int x, y;
    do {
      x = rand.nextInt(sudoku._size);
      y = rand.nextInt(sudoku._size);
    } while (sudoku._field[x][y].number == 0);

    sudoku._field[x][y].number = 0;
    var solver = SudokuSolver(sudoku);
    Sudoku? res;

    switch (difficulty) {
      case Difficulty.easy:
        res = solver.easySolve();
        break;
      case Difficulty.medium:
        res = solver.mediumSolve();
        break;
      case Difficulty.hard:
        res = solver.hardSolve();
        break;
    }

    if (res == null) {
      sudoku._field[x][y].number = sudoku._field[x][y].expectedNumber;
    }

    return res != null;
  }

  // Return the unsolved valid sudoku
  Sudoku build(Difficulty difficulty) {
    _generateField();
    int minimumThrow = 0, maximumThrow = 0;

    switch (difficulty) {
      case Difficulty.easy:
        minimumThrow =
            (simpleFilledPercentHighBorder * sudoku.cellsCount()).toInt();
        maximumThrow =
            (mediumFilledPercentHighBorder * sudoku.cellsCount()).toInt();
        break;
      case Difficulty.medium:
        minimumThrow =
            (mediumFilledPercentHighBorder * sudoku.cellsCount()).toInt();
        maximumThrow =
            (hardFilledPercentHighBorder * sudoku.cellsCount()).toInt();
        break;
      case Difficulty.hard:
        minimumThrow =
            (hardFilledPercentHighBorder * sudoku.cellsCount()).toInt();
        maximumThrow =
            (hardFilledPercentLowBorder * sudoku.cellsCount()).toInt();
        break;
    }

    maximumThrow -= minimumThrow;

    while (minimumThrow > 0) {
      int tries = 5;

      while (tries > 0) {
        if (_tryThrowCell(difficulty)) {
          break;
        } else {
          --tries;
        }
      }

      if (tries == 0) {
        return build(difficulty);
      }

      --minimumThrow;
    }

    while (maximumThrow > 0) {
      if (!_tryThrowCell(difficulty)) {
        break;
      }

      --maximumThrow;
    }

    sudoku._field.forEach(
        (row) => row.forEach((cell) => cell.initial = cell.number != 0));

    return sudoku;
  }

  // Just transpose a field
  void _transpose() {
    for (int i = 0; i < sudoku._size; ++i) {
      for (int j = 0; j < i; ++j) {
        sudoku._field[i][j].swapNumbers(sudoku._field[j][i]);
      }
    }
  }

  // Reflects the field about the axis of the given dimension
  void _reverse(Dimension dim) {
    for (int i = 0; i < sudoku._size; ++i) {
      for (int j = 0; j < sudoku._size / 2; ++j) {
        if (dim == Dimension.vertical) {
          sudoku._field[i][j]
              .swapNumbers(sudoku._field[sudoku._size - i - 1][j]);
        } else {
          sudoku._field[j][i]
              .swapNumbers(sudoku._field[sudoku._size - j - 1][i]);
        }
      }
    }
  }

  // Swap two lines (columns or rows)
  // It gives correct result only if LINES FROM THE SAME SECTION were provided
  void _swapLines(Dimension dim, int first, int second) {
    for (int i = 0; i < sudoku._size; ++i) {
      if (dim == Dimension.vertical) {
        sudoku._field[i][first].swapNumbers(sudoku._field[i][second]);
      } else {
        sudoku._field[first][i].swapNumbers(sudoku._field[second][i]);
      }
    }
  }

  // Swap two lines of sections
  void _swapSections(Dimension dim, int first, int second) {
    for (int i = 0; i < sudoku.subSize(); ++i) {
      _swapLines(
          dim, first * sudoku.subSize() + i, second * sudoku.subSize() + i);
    }
  }

  // Replace all numbers first <-> second
  void _swapNumbers(int first, int second) {
    sudoku._field.forEach((line) {
      line.forEach((element) {
        if (element.number == first) {
          element.number = second;
          element.expectedNumber = second;
        } else if (element.number == second) {
          element.number = first;
          element.expectedNumber = first;
        }
      });
    });
  }
}

class SudokuSolver {
  int normalRecDepth;
  int enoughRecDepth;

  Sudoku sudoku;
  Sudoku? solved;

  SudokuSolver(Sudoku sudokuObj)
      : sudoku = Sudoku.from(sudokuObj),
        normalRecDepth = sudokuObj.subSize(),
        enoughRecDepth = sudokuObj.size() * sudokuObj.size();

  Sudoku? easySolve([bool save = true]) {
    bool changed = true;
    Sudoku? saved = save ? Sudoku.from(sudoku) : null;

    while (!sudoku.isFilled() && changed) {
      changed = false;

      for (int i = 0; i < sudoku._size; ++i) {
        for (int j = 0; j < sudoku._size; ++j) {
          if (sudoku._field[i][j].number == 0) {
            var nums = _getAvailableNumbersForCell(i, j);
            if (nums.length == 1) {
              sudoku._field[i][j].number = nums.first;
              changed = true;
            }
          }
        }
      }
    }

    if (save && !sudoku.isFilled()) {
      sudoku = saved!;
    }

    return sudoku.isFilled() ? sudoku : null;
  }

  Sudoku? mediumSolve() {
    if (easySolve(false) != null) {
      return sudoku;
    }

    solved = null;
    _trySolve(normalRecDepth);

    if (solved == null) {
      return null;
    }

    Sudoku saved = Sudoku.from(solved!);

    _trySolve(normalRecDepth, true);

    return saved == solved! ? saved : null;
  }

  Sudoku? hardSolve() {
    if (easySolve(false) != null) {
      return sudoku;
    }

    solved = null;
    _trySolve(enoughRecDepth);

    if (solved == null) {
      return null;
    }

    Sudoku saved = Sudoku.from(solved!);

    _trySolve(enoughRecDepth, true);

    return saved == solved! ? saved : null;
  }

  // Check what numbers can be set in the cell
  Set<int> _getAvailableNumbersForCell(int i, int j) {
    Set<int> res = List.generate(sudoku._size, (n) => n + 1).toSet();

    // Sift for row and cols
    for (int p = 0; p < sudoku._size; ++p) {
      res.remove(sudoku._field[i][p].number);
      res.remove(sudoku._field[p][j].number);
    }

    // Sift for section
    int si = i ~/ sudoku.subSize();
    int sj = j ~/ sudoku.subSize();

    for (int ii = si * sudoku.subSize();
        ii < (si + 1) * sudoku.subSize();
        ++ii) {
      for (int jj = sj * sudoku.subSize();
          jj < (sj + 1) * sudoku.subSize();
          ++jj) {
        res.remove(sudoku._field[ii][jj].number);
      }
    }

    return res;
  }

  // Try to solve sudoku using recursive full enumeration of numbers
  // and add solutions to solvedVariants list (but not more than two)
  void _trySolve(int maxRecDepth, [bool reverse = false]) {
    if (maxRecDepth < 0) {
      return;
    }

    Sudoku saved = Sudoku.from(sudoku);

    // find cell with minimum available numbers
    var mi = 0, mj = 0, variants = intMaxValue;

    for (int i = 0; i < sudoku._size; ++i) {
      for (int j = 0; j < sudoku._size; ++j) {
        if (sudoku._field[i][j].number != 0) {
          continue;
        }

        var avail = _getAvailableNumbersForCell(i, j);
        if (avail.isEmpty) {
          return;
        }

        if (avail.length < variants) {
          variants = avail.length;
          mi = i;
          mj = j;
        }
      }
    }

    var avail = _getAvailableNumbersForCell(mi, mj).toList();
    for (int num in (reverse ? avail.reversed : avail)) {
      sudoku._field[mi][mj].number = num;

      if (easySolve(false) != null) {
        solved = Sudoku.from(sudoku);
      } else {
        _trySolve(maxRecDepth - 1);
      }

      sudoku = Sudoku.from(saved);

      if (solved != null) {
        return;
      }
    }
  }
}

String difficultyToString(Difficulty difficulty) {
  switch (difficulty) {
    case Difficulty.easy:
      return "Easy";
    case Difficulty.medium:
      return "Medium";
    case Difficulty.hard:
      return "Hard";
  }
}
