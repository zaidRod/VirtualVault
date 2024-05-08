import 'package:widgets_basicos/widgets/products.dart';

List<ProductWidget> listadoProductos = [];

List<String> listadoNombre = [
  'zanahoria',
  'lechuga',
  'espinaca',
  'brócoli',
  'pepino',
  'tomate',
  'pimiento',
  'calabacín',
  'apio',
  'coliflor',
  'berenjena',
  'judía verde',
  'acelga',
  'cebolla',
  'ajo',
  'puerro',
  'rábano',
  'remolacha',
  'calabaza',
  'champiñón'
];

//Al iniciar el programa esta funcion llena castea todos los productos y sus atributos
//Tambien los agrega al listado de productos

void CargarDatos() {
  for (int i = 0; i < listadoNombre.length; i++) {
    listadoProductos.add(ProductWidget(
      nombre: listadoNombre[i],
      precio: i + 10,
      image: "assets/images/Carrusel2.jpg",
      desc:
          "Lorem Ipsum es simplemente el texto de relleno de las imprentas y archivos de texto. Lorem Ipsum ha sido el texto de relleno estándar de las industrias desde el año 1500",
    ));
  }
}
