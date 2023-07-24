import 'constants.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  // torna esta classe singleton
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // tem somente uma referência ao banco de dados
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // instancia o db na primeira vez que for acessado
    _database = await _initDatabase();
    return _database;
  }

  // abre o banco de dados e o cria se ele não existir
  static _initDatabase() async {
    try {
      String path = join(await getDatabasesPath(), DB_NAME);
      // DANGER: a linha a seguir deleta o banco de dados toda vez que ele é inciado
      //await deleteDatabase(path);
      return await openDatabase(path, version: DB_VERSION, onCreate: _onCreate, onConfigure: _onConfigure);
    } catch (error) {
      print(error);
    }
  }

  static Future _onConfigure(Database db) async => await db.execute('PRAGMA foreign_keys = ON');

  // Código SQL para criar o banco de dados e a tabela
  static Future _onCreate(Database db, int version) async {
    var sql = [
      //'''DROP TABLE IF EXISTS usuario;''',
      '''CREATE TABLE IF NOT EXISTS usuario(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT,
            password TEXT,
            dataLogin TEXT
      );''',
      '''CREATE TABLE IF NOT EXISTS audio(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            path TEXT
      );''',
    ];
    for (var i = 0; i < sql.length; i++) {
      await db.execute(sql[i]).catchError((onError) => print(onError));
    }
  }
}