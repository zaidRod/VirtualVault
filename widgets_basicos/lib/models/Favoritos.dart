class Favorito {
  final int id;
  final String imagen;
  final String nombre;
  final int precio;

  Favorito({
    required this.id,
    required this.imagen,
    required this.nombre,
    required this.precio,
  });

  // Método toMap para convertir un objeto Favorito a un mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'image': imagen,
      'name': nombre,
      'price': precio,
    };
  }

  // Método fromMap para convertir un mapa a un objeto Favorito
  factory Favorito.fromMap(Map<String, dynamic> map) {
    return Favorito(
      id: map['id'],
      imagen: map['image'],
      nombre: map['name'],
      precio: map['price'],
    );
  }
}
