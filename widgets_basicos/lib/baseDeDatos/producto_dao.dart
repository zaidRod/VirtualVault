import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:widgets_basicos/baseDeDatos/database_helper.dart';
import 'package:widgets_basicos/baseDeDatos/producto_model.dart';
import 'package:widgets_basicos/models/pedido.dart';
import 'package:widgets_basicos/models/producto_pedido.dart';
import 'package:widgets_basicos/models/productsModel.dart';

class ProductoDao {
  final database = DatabaseHelper.instance.db;

  Future<List<ProductoModel>> readAll(int userId) async {
    final data = await database
        .query('carrito', where: 'userId = ?', whereArgs: [userId]);
    return data.map((e) => ProductoModel.fromMap(e)).toList();
  }

  Future<int> insert(ProductoModel producto, int userId) async {
    return await database.insert('carrito', {
      'userId': userId,
      'name': producto.name,
      'cantidad': producto.cantidad,
      'price': producto.price
    });
  }

  Future<void> limpiarCarrito(int userId) async {
    await database.delete('carrito', where: 'userId = ?', whereArgs: [userId]);
  }

  Future<void> updateCantidad(int id, int nuevaCantidad) async {
    Map<String, dynamic> row = {
      'cantidad': nuevaCantidad,
    };
    await database.update(
      'carrito',
      row,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> update(ProductoModel producto, int userId) async {
    await database.update('carrito', producto.toMap(),
        where: 'id = ? AND userId = ?', whereArgs: [producto.id, userId]);
  }

  Future<void> delete(ProductoModel producto, int userId) async {
    await database.delete('carrito',
        where: 'id = ? AND userId = ?', whereArgs: [producto.id, userId]);
  }

  //*************************Tabla productos*************************//

  // Metodo insert en tabla productos
  Future<void> insertProduct(Product producto) async {
    await database.insert(
        'productos',
        {
          'name': producto.name,
          'price': producto.price,
          'desc': producto.desc,
          'image': producto.image
        },
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Metoodo de lectura de productos
  Future<List<Product>> readProductList() async {
    //Variable que contiene el listado de todos los productos
    final List<Map<String, Object?>> productMaps =
        await database.query('productos');
    // Convierte el listado de cada elemento de listado de mapas en un objeto producto
    return [
      for (final {
            'id': id as int,
            'name': name as String,
            'price': price as int,
            'desc': desc as String,
            'image': image as String,
          } in productMaps)
        Product(id: id, name: name, price: price, desc: desc, image: image)
    ];
  }

  //Metodo para actualizar productos
  Future<void> updateProduct(Product producto) async {
    await database.update('productos', producto.toMap(),
        where: 'id = ?', whereArgs: [producto.id]);
  }

  //Metodo para borrado de productos
  Future<void> deleteProduct(int id) async {
    database.delete(
      "productos",
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<bool> isProductEmpty() async {
    List<Map<String, dynamic>> products =
        await database.query('productos', limit: 1);
    if (products.isEmpty) {
      return true;
    }
    return false;
  }
  //*************************Tabla pedidios*************************//

  // Método para insertar un nuevo pedido en la tabla 'pedidos'
  Future<int> insertarPedido(
      int userId, DateTime fechaPedido, int total) async {
    final idPedido = await database.insert('pedidos', {
      'userId': userId,
      'fecha': fechaPedido.toIso8601String(),
      'total': total,
    });
    return idPedido;
  }

  // Método para insertar un detalle de pedido en la tabla 'productos_pedido'
  Future<void> insertarDetallePedido(int idPedido, int idProducto, int cantidad,
      String nombre, int precio) async {
    await database.insert('productos_pedido', {
      'pedidoId': idPedido,
      'productoId': idProducto,
      'cantidad': cantidad,
      'nombre': nombre,
      'precio': precio
    });
  }

  // Función para obtener la lista de pedidos con detalles
  Future<List<Pedido>> obtenerPedidosConDetalles() async {
    final List<Map<String, dynamic>> pedidosResult =
        await database.rawQuery('SELECT * FROM pedidos');
    final List<Pedido> pedidos = [];
    for (final pedidoMap in pedidosResult) {
      final int pedidoId = pedidoMap['id'] as int;
      final List<Map<String, dynamic>> productosPedidoResult =
          await database.rawQuery(
              'SELECT * FROM productos_pedido WHERE pedidoId = $pedidoId');
      final List<ProductoPedido> productosPedido = productosPedidoResult
          .map((productoPedidoMap) => ProductoPedido.fromMap(productoPedidoMap))
          .toList();
      final Pedido pedido = Pedido.fromMap(pedidoMap, productosPedido);
      pedidos.add(pedido);
    }
    return pedidos;
  }

  // Función para obtener los productos de un pedido específico
  Future<List<ProductoPedido>> obtenerProductosPedido(int pedidoId) async {
    final List<Map<String, dynamic>> productosPedidoResult = await database
        .rawQuery('SELECT * FROM productos_pedido WHERE pedidoId = $pedidoId');
    return productosPedidoResult
        .map((productoPedidoMap) => ProductoPedido.fromMap(productoPedidoMap))
        .toList();
  }

  Future<void> borrarPedido(int idPedido) async {
    await database.delete('productos_pedido',
        where: 'pedidoId = ?', whereArgs: [idPedido]);
    await database.delete('pedidos', where: 'id = ?', whereArgs: [idPedido]);
  }

  //Metodo que retorna el correo
  Future<String> mostrarNombreUsuario(int userId) async {
    try {
      final nombreUsuario = await database
          .rawQuery('SELECT username FROM usuarios WHERE id = $userId');

      return nombreUsuario.first['username'].toString();
    } catch (e) {
      print('Error al consultar la información del usuario: $e');
      return null.toString();
    }
  }

  //Metodo que retorna el correo
  Future<String> mostrarCorreo(int userId) async {
    try {
      final correo = await database
          .rawQuery('SELECT email FROM usuarios WHERE id = $userId');

      return correo.first['email'].toString();
    } catch (e) {
      print('Error al consultar la información del usuario: $e');
      return null.toString();
    }
  }
}
