import 'package:sqflite/sqflite.dart';
import 'package:animationlogin2/utils/db_helper.dart';
import 'package:animationlogin2/models/Usuario_model.dart';

class UsuarioRepository {
  static final _table = "usuario";

  Future<Database> _database() => DatabaseHelper.instance.database;

  Future<int> insert(UsuarioModel usuario) async {
    final Database db = await _database();
    try {
      return await db.insert(_table, usuario.toJson());
    } catch (error) {
      print(error);
    }
    return null;
  }

  Future<UsuarioModel> checkLogin(String email, String password) async {
    final Database db = await _database();
    try {
      List<Map<String, dynamic>> maps = await db.query("$_table", columns: ['id', 'email', 'dataLogin'], where: "email = ? AND password = ?", whereArgs: [email, password]);
      if (maps.first.length > 0) {
        return UsuarioModel.fromJson(maps.first);
      }
    } catch (error) {
      print(error);
    }
    return null;
  }

  //dispose will be called automatically
  void dispose() {}
}