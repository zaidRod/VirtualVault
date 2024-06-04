import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:widgets_basicos/models/pedidosModel.dart';
import 'package:widgets_basicos/models/productosPedidoModel.dart';
import 'usuarioModel.dart';
import 'package:http/http.dart' as http;

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

        // Crear tablas
        await db.execute(
            'CREATE TABLE productos (id INTEGER PRIMARY KEY AUTOINCREMENT, name VARCHAR(255), price INTEGER DEFAULT 1, image VARCHAR(255), desc VARCHAR(255))');
        print("Table 'productos' created."); // Log de creación de tabla

        await db.execute(
            'CREATE TABLE pedidos (id INTEGER PRIMARY KEY AUTOINCREMENT, userId INTEGER, total INTEGER, fecha TEXT, FOREIGN KEY(userId) REFERENCES usuarios(id))');
        print("Table 'pedidos' created.");

        await db.execute(
            'CREATE TABLE productos_pedido (id INTEGER PRIMARY KEY AUTOINCREMENT, pedidoId INTEGER, productoId INTEGER, cantidad INTEGER, nombre TEXT, precio INTEGER, FOREIGN KEY(pedidoId) REFERENCES pedidos(id), FOREIGN KEY(productoId) REFERENCES productos(id))');
        print("Table 'productos_pedidos' created.");

        await db.execute(
            'CREATE TABLE carrito (id INTEGER PRIMARY KEY AUTOINCREMENT, userId INTEGER, name TEXT, cantidad INTEGER DEFAULT 1, price INTEGER, FOREIGN KEY(userId) REFERENCES usuarios(id))');
        print("Table 'carrito' created."); // Log de creación de tabla

        await db.execute(
            'CREATE TABLE usuarios (id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT, password TEXT, email TEXT, phoneNumber TEXT, birthDate TEXT)');
        print("Table 'usuarios' created."); // Log de creación de tabla

        await db.execute(
            'CREATE TABLE favoritos (id INTEGER PRIMARY KEY AUTOINCREMENT, userId INTEGER, image TEXT, name TEXT, description TEXT, price INTEGER DEFAULT 1, FOREIGN KEY(userId) REFERENCES usuarios(id))');
        print("Table 'favoritos' created."); // Log de creación de tabla

        // Insertar usuarios predeterminados
        await db.insert('usuarios', {
          'username': 'prueba',
          'password': 'prueba',
          'email': 'prueba@example.com',
          'phoneNumber': '123456789',
          'birthDate': '2000-01-01'
        });

        await db.insert('usuarios', {
          'username': 'admin',
          'password': 'admin',
          'email': 'virtual.vault11@gmail.com',
          'phoneNumber': '987654321',
          'birthDate': '1990-01-01'
        });

        print("Default users 'prueba' and 'admin' created.");
      },
      onOpen: (db) async {
        print("Database opened"); // Log de apertura de base de datos
      },
    );
  }

  Future<int> insertUsuario(Usuario usuario) async {
    final db = await instance.db;
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

  // Método para gestionar el carrito
  Future<List<Map<String, dynamic>>> getCarrito(int userId) async {
    final db = await instance.db;
    return await db.query('carrito', where: 'userId = ?', whereArgs: [userId]);
  }

  // Métodos para gestionar los favoritos
  Future<int> insertFavorito(
      int userId, String image, String name, int price, String desc) async {
    final db = await instance.db;
    return await db.insert('favoritos', {
      'userId': userId,
      'image': image,
      'name': name,
      'description': desc,
      'price': price
    });
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

  // Métodos para gestionar los pedidos
  Future<List<Pedido>> obtenerPedidosConDetalles() async {
    final db = await instance.db;
    final List<Map<String, dynamic>> pedidosResult =
        await db.rawQuery('SELECT * FROM pedidos');
    final List<Pedido> pedidos = [];
    for (final pedidoMap in pedidosResult) {
      final int pedidoId = pedidoMap['id'] as int;
      final List<Map<String, dynamic>> productosPedidoResult =
          await db.rawQuery(
              'SELECT * FROM productos_pedido WHERE pedidoId = $pedidoId');
      final List<ProductoPedido> productosPedido = productosPedidoResult
          .map((productoPedidoMap) => ProductoPedido.fromMap(productoPedidoMap))
          .toList();
      final Pedido pedido = Pedido.fromMap(pedidoMap, productosPedido);
      pedidos.add(pedido);
    }
    return pedidos;
  }

  Future<List<ProductoPedido>> obtenerProductosPedido(int pedidoId) async {
    final db = await instance.db;
    final List<Map<String, dynamic>> productosPedidoResult = await db
        .rawQuery('SELECT * FROM productos_pedido WHERE pedidoId = $pedidoId');
    return productosPedidoResult
        .map((productoPedidoMap) => ProductoPedido.fromMap(productoPedidoMap))
        .toList();
  }

  // Correo de confirmación
  Future sendEmail({
    required String name,
    required String email,
    required String subject,
    required String message,
  }) async {
    final serviceId = 'service_3nkbevr';
    final templateId = 'template_gxrf0s9';
    final userId = 'eS70l0Zazvj-2Thi9';

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(
      url,
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': {
          'to_name': name,
          'to_email': email,
          'user_email':
              'virtual.vault11@gmail.com', 
          'user_subject': subject,
          'user_message': message,
          'user_name': 'Virtual Vault',
        },
      }),
    );

    print(response.body);
  }

  // Función de eliminar la base de datos
  Future<void> deleteDatabase() async {
    final dbPath = join(await getDatabasesPath(), 'database.db');
    await databaseFactory.deleteDatabase(dbPath);
    print("Database deleted");
  }
}
