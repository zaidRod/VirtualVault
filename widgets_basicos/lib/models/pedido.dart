import 'package:widgets_basicos/models/producto_pedido.dart';

class Pedido {
  final int id;
  final int userId;
  final String fecha;
  final int total;

  Pedido({
    required this.id,
    required this.userId,
    required this.fecha,
    required this.total, // Añadir el total al constructor
  });

  factory Pedido.fromMap(
      Map<String, dynamic> map, List<ProductoPedido> productosPedido) {
    return Pedido(
      id: map['id'] as int,
      userId: map['userId'] as int,
      fecha: map['fecha'] as String,
      total: map['total'] as int,
    );
  }
}
