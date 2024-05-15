import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  DatabaseHelper._internal();
  static DatabaseHelper get instance =>
      _databaseHelper ??= DatabaseHelper._internal();

  Database? _db;
  Database get db => _db!;

// funcion de inicializacion

  Future<void> init() async {
    _db = await openDatabase(
      'database.db',
      version: 1,
      onCreate: (db, version) async {
        //Tabla productos
        db.execute(
            'Create table productos (id	INTEGER PRIMARY KEY AUTOINCREMENT ,name	varchar(255), price	INTEGER DEFAULT 1,image varchar(255),desc varchar(255))');

        // Tabla de carrito
        db.execute(
            'Create table carrito (id INTEGER PRIMARY KEY AUTOINCREMENT, name varchar(255), cantidad INTEGER DEFAULT 1)');

        // Tabla de usuarios
        db.execute(
            'Create table usuarios (id INTEGER PRIMARY KEY AUTOINCREMENT, username varchar(255), password varchar(255),email varchar(255),phoneNumber varchar(255),)');
      },
    );
  }
}
