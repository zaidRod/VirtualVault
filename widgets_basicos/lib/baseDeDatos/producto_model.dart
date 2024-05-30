class ProductoModel {
  final int id;
  int cantidad;
  final String name;
  final int price; // Añadir el campo price

  ProductoModel({
    this.id = -1,
    required this.name,
    this.cantidad = 1,
    required this.price, // Añadir price en el constructor
  });

  ProductoModel copyWith({int? id, int? cantidad, String? name, int? price}) {
    return ProductoModel(
        id: id ?? this.id,
        cantidad: cantidad ?? this.cantidad,
        name: name ?? this.name,
        price: price ?? this.price); // Añadir price en copyWith
  }

  factory ProductoModel.fromMap(Map<String, dynamic> map) {
    return ProductoModel(
        id: map['id'],
        name: map['name'],
        cantidad: map['cantidad'],
        price: map['price']); // Añadir price en fromMap
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'cantidad': cantidad,
        'price': price
      }; // Añadir price en toMap
}
