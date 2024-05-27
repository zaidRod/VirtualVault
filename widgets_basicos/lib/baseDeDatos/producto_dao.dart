import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:widgets_basicos/baseDeDatos/database_helper.dart';
import 'package:widgets_basicos/baseDeDatos/producto_model.dart';
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
}
