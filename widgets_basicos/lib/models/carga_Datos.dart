import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:widgets_basicos/baseDeDatos/producto_dao.dart';
import 'package:widgets_basicos/models/productsModel.dart';
import 'package:widgets_basicos/widgets/products.dart';

// Instancia de la base de datos
final dao = ProductoDao();

List<ProductWidget> listadoProductos = [];

List<String> listadoNombre = [
  'Call-of-duty-black-ops-3',
  'Halo-4',
  'Metal-gear-solid',
  'Mortal-kombat-x',
  'Pac-man',
  'Resident-evil-0',
  'Rise-of-the-tomb-raider',
  'Destiny',
];

List<String> descripciones = [
  'Call of Duty: Black Ops 3 es un juego de disparos en primera persona con una intensa campaña, multijugador y modo zombis.',
  'Halo 4 continúa la historia del Jefe Maestro en un emocionante juego de disparos en primera persona con gráficos impresionantes.',
  'Metal Gear Solid es un juego de sigilo donde controlas a Solid Snake en misiones de espionaje y acción.',
  'Mortal Kombat X es un juego de lucha con gráficos realistas, personajes icónicos y brutales fatalities.',
  'Pac-Man es un clásico arcade donde guías a Pac-Man a través de laberintos, comiendo puntos y evitando fantasmas.',
  'Resident Evil 0 es un juego de terror y supervivencia, precuela de la serie, con resolución de acertijos y combate contra zombis.',
  'Rise of the Tomb Raider sigue a Lara Croft en su búsqueda de secretos antiguos, combinando exploración y acción.',
  'Destiny es un juego de acción y aventuras en un mundo de ciencia ficción. Explora planetas, combate enemigos alienígenas y completa misiones épicas en línea.'
];

/*Funcion que al iniciar copia las imagenes de la carpeta assets del dispisitivo
para cargar los productos de prueba*/
Future<void> copyAssetsToLocal() async {
  try {
    // Obtenemos el directorio de almacenamiento local
    Directory localPath = await getApplicationDocumentsDirectory();

    // Copiamos cada imagen de los assets al directorio local
    listadoNombre.forEach((element) async {
      await _copyAssetsToLocal('assets/images/cover.$element.jpg', localPath);
    });

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

/*Al iniciar el programa esta funcion llena castea todos los productos y sus atributos
Tambien los agrega al listado de productos*/

cargarDatos() async {
  // Verificamos si es la primera vez que se abre la app
  SharedPreferences prefs = await SharedPreferences.getInstance();

  bool isFirstRun = prefs.getBool('isFirstRun') ?? true;

  print("Es la primera vez que se ejecuta: $isFirstRun");

  if (isFirstRun) {
    //Llamada a la funcion de copia de imagenes de assets al dispositivo
    copyAssetsToLocal().then((_) {
      print("Imagenes copiadas con exito");
    }).catchError((error) {
      print("Error al copiar las imagenes: $error");
    });

    //Insert de registros si la tabla productos esta vacia
    final estavacia = await ProductoDao().isProductEmpty();
    if (estavacia) {
      //Ruta del directorio del dispoisitivo, usada para las imagenes
      Directory directory = await getApplicationDocumentsDirectory();
      for (int i = 0; i < listadoNombre.length; i++) {
        //define la ruta de cada imagen en el dispositivo, segun el nombre en listadoNombre
        String ruta =
            '${directory.path}/flutter_assets/cover.${listadoNombre[i]}.jpg';

        //Quito los guiones del nombre para crear el producto
        String nombreNuevo = listadoNombre[i].replaceAll("-", ' ');

        Product producto = Product(
          name: nombreNuevo,
          price: i + 10,
          desc: descripciones[i],
          image: ruta,
        );

        //Se agrega al listado de productos
        listadoProductos.add(
          ProductWidget(producto: producto),
        );
        // Insert en la base de datos
        dao.insertProduct(producto);
        print("Insert completo");
      }
    }
    // Marcamos que ya no es la primera vez que se abre la app
    await prefs.setBool('isFirstRun', false);
  } else {
    //Si no esta vacia, se carga los valores de la base de datos.
    List<Product> dataBaseList = await dao.readProductList();
    //listado de productos se carga con lo contenido en DB
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
