import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'usuarioModel.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  DatabaseHelper._internal();
  static DatabaseHelper get instance =>
      _databaseHelper ??= DatabaseHelper._internal();

  Database? _db;
  Database get db => _db!;

  // Función de inicialización
  Future<void> init() async {
    if (_db != null)
      return; // Previene la reinicialización si la DB ya está inicializada

    _db = await openDatabase(
      join(await getDatabasesPath(),
          'database.db'), // Asegura el uso de la ruta correcta
      version: 1,
      onCreate: (db, version) async {
        print("Creating database..."); // Log de creación de base de datos

        // Tabla productos
        await db.execute(
            'Create table productos (id	INTEGER PRIMARY KEY AUTOINCREMENT ,name	varchar(255), price	INTEGER DEFAULT 1,image varchar(255),desc varchar(255))');
        print("Table 'productos' created."); // Log de creación de tabla

        // Tabla de carrito
        await db.execute(
          'CREATE TABLE carrito (id INTEGER PRIMARY KEY AUTOINCREMENT, userId INTEGER, name TEXT, cantidad INTEGER DEFAULT 1,price INTEGER, FOREIGN KEY(userId) REFERENCES usuarios(id))',
        );
        print("Table 'carrito' created."); // Log de creación de tabla

        // Tabla de usuarios
        await db.execute(
          'CREATE TABLE usuarios (id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT, password TEXT, email TEXT, phoneNumber TEXT, birthDate TEXT)',
        );
        print("Table 'usuarios' created."); // Log de creación de tabla

        // Tabla de favoritos
        await db.execute(
          'CREATE TABLE favoritos (id INTEGER PRIMARY KEY AUTOINCREMENT, userId INTEGER, image TEXT, name TEXT, price INTEGER DEFAULT 1, FOREIGN KEY(userId) REFERENCES usuarios(id))',
        );
        print("Table 'favoritos' created."); // Log de creación de tabla
      },
      onOpen: (db) async {
        print("Database opened"); // Log de apertura de base de datos
      },
    );
  }

  Future<int> insertUsuario(Usuario usuario) async {
    final db = await instance.db;
    // Excluye el campo 'id' del mapa para que SQLite lo asigne automáticamente
    final usuarioMap = usuario.toMap()..remove('id');
    return await db.insert('usuarios', usuarioMap);
  }

  Future<Usuario?> getUsuario(String username, String password) async {
    final db = await instance.db;
    final List<Map<String, dynamic>> maps = await db.query(
      'usuarios',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (maps.isNotEmpty) {
      return Usuario.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<bool> checkUsuarioExistente(String username) async {
    final db = await instance.db;
    final List<Map<String, dynamic>> maps = await db.query(
      'usuarios',
      where: 'username = ?',
      whereArgs: [username],
    );

    return maps.isNotEmpty;
  }

  // Métodos para gestionar el carrito
  Future<int> insertCarrito(
      int userId, String name, int cantidad, int price) async {
    final db = await instance.db;
    return await db.insert('carrito',
        {'userId': userId, 'name': name, 'cantidad': cantidad, 'price': price});
  }

  Future<List<Map<String, dynamic>>> getCarrito(int userId) async {
    final db = await instance.db;
    return await db.query('carrito', where: 'userId = ?', whereArgs: [userId]);
  }

  // Métodos para gestionar los favoritos
  Future<int> insertFavorito(
      int userId, String image, String name, int price) async {
    final db = await instance.db;
    return await db.insert('favoritos',
        {'userId': userId, 'image': image, 'name': name, 'price': price});
  }

  Future<List<Map<String, dynamic>>> getFavoritos(int userId) async {
    final db = await instance.db;
    return await db
        .query('favoritos', where: 'userId = ?', whereArgs: [userId]);
  }

  Future<void> deleteFav(int id) async {
    final db = await instance.db;
    await db.delete('favoritos', where: 'id = ?', whereArgs: [id]);
  }

  // Función de eliminar la base de datos
/* 
  Future<void> deleteDatabase() async {
    final dbPath = join(await getDatabasesPath(), 'database.db');
    await databaseFactory.deleteDatabase(dbPath);
    print("Database deleted");
  } */
}
