import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:widgets_basicos/baseDeDatos/producto_dao.dart';
import 'package:widgets_basicos/models/productsModel.dart';
import 'package:widgets_basicos/widgets/products.dart';

final dao = ProductoDao();

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
//Funcion que al iniciar copia las imagenes de la carpeta assets del dispisitivo
//para cargar los productos de prueba
Future<void> copyAssetsToLocal() async {
  try {
    // Obtenemos el directorio de almacenamiento local
    Directory localPath = await getApplicationDocumentsDirectory();

    // Copiamos cada imagen de los assets al directorio local
    await _copyAssetsToLocal('assets/images/Carrusel1.jpg', localPath);
    await _copyAssetsToLocal('assets/images/Carrusel2.jpg', localPath);
    await _copyAssetsToLocal('assets/images/agregarImagen.png', localPath);
  } catch (e) {
    throw Exception('Error al copiar imágenes: $e');
  }
}

Future<void> _copyAssetsToLocal(String assetPath, Directory localPath) async {
  // Obtenemos la referencia al archivo en los assets
  ByteData data = await rootBundle.load(assetPath);
  List<int> bytes = data.buffer.asUint8List();

  // Obtenemos el nombre del archivo
  String fileName = assetPath.split('/').last;

  // Creamos el archivo en el directorio local
  File localFile = File('${localPath.path}/flutter_assets/$fileName');
  await localFile.writeAsBytes(bytes);
}

//Al iniciar el programa esta funcion llena castea todos los productos y sus atributos
//Tambien los agrega al listado de productos

cargarDatos() async {
  //Llamada a la funcion para copias las imagenes
  copyAssetsToLocal().then((_) {
    print("Imagenes copiadas con exito");
  }).catchError((error) {
    print("Error al copiar las imagenes: $error");
  });

  // Verificamos si es la primera vez que se abre la app

  // Verificamos si es la primera vez que se abre la app
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Depuración: Listar todas las claves en SharedPreferences
  print('SharedPreferences keys: ${prefs.getKeys()}');

  bool isFirstRun = prefs.getBool('isFirstRun') ?? true;

  print(isFirstRun);

  //Insert de registros si la tabla productos esta vacia
  if (isFirstRun) {
    final estavacia = await ProductoDao().isProductEmpty();
    if (estavacia) {
      //Ruta del directorio del dispoisitivo
      Directory directory = await getApplicationDocumentsDirectory();
      //ruta donde se tiene almacenada la imagen
      String ruta = '${directory.path}/flutter_assets/Carrusel1.jpg';

      for (int i = 0; i < listadoNombre.length; i++) {
        Product producto = Product(
          name: listadoNombre[i],
          price: i + 10,
          desc:
              "Lorem Ipsum es simplemente el texto de relleno de las imprentas y archivos de texto. Lorem Ipsum ha sido el texto de relleno estándar de las industrias desde el año 1500",
          image: ruta,
        );

        listadoProductos.add(
          ProductWidget(producto: producto),
        );

        dao.insertProduct(producto);
        print("Insert completo");
      }
    }
    // Marcamos que ya no es la primera vez que se abre la app
    await prefs.setBool('isFirstRun', false);
  } else {
    //Si no esta vacia carga los valores de la base de datos.
    List<Product> dataBaseList = await dao.readProductList();

    dataBaseList.forEach(
      (element) {
        listadoProductos.add(
          ProductWidget(producto: element),
        );
      },
    );
  }

  /* await dao.insertProduct(miProducto);
  print('Insert completo');

  await dao.insertProduct(miProducto2);
  print('Insert completo'); */

//Antes del update

//  print(await dao.readProductList());

// tener en cuenta qeu al probar el id es -1, hasta que se recojan los datos de DB si se haran los updates.
  // await dao.updateProduct(miProducto2);

  //Borrado
//  dao.deleteProduct(3);
  //print(await dao.readProductList());
}
