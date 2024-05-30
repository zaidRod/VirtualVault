class ProductoPedido {
  final int id;
  final int pedidoId;
  final int productoId;
  final int cantidad;
  final String nombre;
  final int precio;

  ProductoPedido({
    required this.id,
    required this.pedidoId,
    required this.productoId,
    required this.cantidad,
    required this.nombre,
    required this.precio,
  });

  factory ProductoPedido.fromMap(Map<String, dynamic> map) {
    return ProductoPedido(
      id: map['id'] as int,
      pedidoId: map['pedidoId'] as int,
      productoId: map['productoId'] as int,
      cantidad: map['cantidad'] as int,
      nombre: map['nombre'] as String,
      precio: map['precio'] as int,
    );
  }
}
