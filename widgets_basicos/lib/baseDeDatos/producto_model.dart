class ProductoModel {
  final int id;
  int cantidad;
  final String name;

  ProductoModel({
    this.id = -1,
    required this.name,
    this.cantidad = 1,
  });

  ProductoModel copyWith({int? id, int? cantidad, String? name}) {
    return ProductoModel(
        id: id ?? this.id,
        cantidad: cantidad ?? this.cantidad,
        name: name ?? this.name);
  }

  factory ProductoModel.fromMap(Map<String, dynamic> map) {
    return ProductoModel(
        id: map['id'], name: map['name'], cantidad: map['cantidad']);
  }

  Map<String, dynamic> toMap() =>
      {'id': id, 'name': name, 'cantidad': cantidad};
}
