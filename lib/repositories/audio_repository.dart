import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:animationlogin2/utils/db_helper.dart';
import 'package:animationlogin2/models/audio_model.dart';

class AudioRepository {
  static final _table = "audio";

  Future<Database> _database() => DatabaseHelper.instance.database;

  Future<int> insert(AudioModel audio) async {
    final Database db = await _database();
    try {
      return await db.insert(_table, audio.toJson());
    } catch (error) {
      print(error);
    }
    return null;
  }

  Future<List<AudioModel>> queryAllRows() async {
    final Database db = await _database();
    try {
      final category = await db.query(_table);
      return List.generate(category.length, (i) => AudioModel.fromJson(category[i]));
    } catch (error) {
      print('ERROR: $error');
    }
    return null;
  }

  Future<int> delete(id) async {
    final Database db = await _database();
    try {
      AudioModel fileToDelete = await findById(id);
      await File(fileToDelete.path).delete();
      return await db.delete(_table, where: 'id = ?', whereArgs: [id]);
    } catch (error) {
      print(error);
    }
    return null;
  }

  Future<AudioModel> findById(id) async {
    final Database db = await _database();
    try {
      List<Map<String, dynamic>> maps = await db.query("$_table", columns: ['id', 'path'], where: 'id = ?', whereArgs: [id]);
      if (maps.first.length > 0) {
        return AudioModel.fromJson(maps.first);
      }
    } catch (error) {
      print(error);
    }
    return null;
  }

  //dispose will be called automatically
  void dispose() {}
}