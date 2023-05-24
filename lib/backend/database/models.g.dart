// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SudokuGameModelAdapter extends TypeAdapter<SudokuGameModel> {
  @override
  final int typeId = 0;

  @override
  SudokuGameModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SudokuGameModel(
      fields[0] as int,
      (fields[1] as Map).cast<dynamic, dynamic>(),
    )
      ..time = fields[2] as int
      ..mistakes = fields[3] as int?
      ..hintsUsed = fields[4] as int
      ..inProcess = fields[5] as bool
      ..isSolved = fields[6] as bool;
  }

  @override
  void write(BinaryWriter writer, SudokuGameModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.difficulty)
      ..writeByte(1)
      ..write(obj.sudoku)
      ..writeByte(2)
      ..write(obj.time)
      ..writeByte(3)
      ..write(obj.mistakes)
      ..writeByte(4)
      ..write(obj.hintsUsed)
      ..writeByte(5)
      ..write(obj.inProcess)
      ..writeByte(6)
      ..write(obj.isSolved);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SudokuGameModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SettingsAdapter extends TypeAdapter<Settings> {
  @override
  final int typeId = 1;

  @override
  Settings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Settings()
      ..language = fields[0] as String
      ..realtimeCheck = fields[1] as bool
      ..theme = fields[2] as int;
  }

  @override
  void write(BinaryWriter writer, Settings obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.language)
      ..writeByte(1)
      ..write(obj.realtimeCheck)
      ..writeByte(2)
      ..write(obj.theme);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
