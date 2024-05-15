class Product {
  final int id;
  String name;
  int price;
  String desc;
  String image;

  Product(
      {this.id = -1,
      required this.name,
      required this.price,
      required this.desc,
      required this.image});

  Map<String, Object?> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'price': this.price,
      'desc': this.desc,
      'image': this.image
    };
  }

  @override
  String toString() {
    return 'Producto{id: $id, name:$name, price:$price, desc: $desc, image: $image}';
  }

  // Getters
  int get getId => id;
  String get getName => name;
  int get getPrice => price;
  String get getDesc => desc;
  String get getImage => image;

  // Setters

  set setName(String newName) {
    name = newName;
  }

  set setPrice(int newPrice) {
    price = newPrice;
  }

  set setDesc(String newDesc) {
    desc = newDesc;
  }

  set setImage(String newImage) {
    image = newImage;
  }
}
