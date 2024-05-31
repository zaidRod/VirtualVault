import "dart:io";
import "dart:math";

import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:widgets_basicos/baseDeDatos/producto_dao.dart";
import "package:widgets_basicos/baseDeDatos/producto_model.dart";
import "package:widgets_basicos/models/Favoritos.dart";
import "package:widgets_basicos/screens/pedidosScreen.dart";
import "package:widgets_basicos/view_models/modelo_usuario.dart";

class ProductScreen extends StatelessWidget {
  final String image;
  final String nombre;
  final int precio;
  final String desc;

  ProductScreen(this.image, this.nombre, this.precio, this.desc, {super.key}) {
    super.key;
  }

  // Métodos de insert y de la base de datos
  final dao = ProductoDao();

  @override
  Widget build(BuildContext context) {
    return Consumer<ModeloUsuario>(
      builder: (context, modeloUsuario, child) {
        final bool esFavorito = modeloUsuario.existFavorite(nombre) != -1;

        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.topCenter,
                    height: MediaQuery.of(context).size.height / 1.7,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 244, 224, 224),
                      image: DecorationImage(
                          image: FileImage(File(image)), fit: BoxFit.cover),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Botón de volver
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Icon(
                                Icons.arrow_back_ios_new,
                                size: 22,
                                color: modeloUsuario.isDarkMode
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                          ),

                          // Botón de favorito
                          InkWell(
                            onTap: () {
                              int indexFav =
                                  modeloUsuario.existFavorite(nombre);
                              // Si existe el favorito lo borra
                              if (indexFav != -1) {
                                modeloUsuario.deleteFavorite(indexFav);
                              } else {
                                // Lo agrega
                                modeloUsuario.addFavorite(
                                  Favorito(
                                      id: 0,
                                      nombre: nombre,
                                      imagen: image,
                                      precio: precio,
                                      desc: desc),
                                );
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                              ),

                              // Botón de favorito
                              child: Icon(
                                Icons.favorite,
                                size: 22,
                                color: esFavorito ? Colors.red : Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 15, right: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Row(
                            // Aca se modifica el centrado del nombre del producto
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Nombre del producto
                              Text(
                                nombre,
                                style: const TextStyle(
                                    fontSize: 28, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),

                        // Precio del producto
                        Text(
                          "${precio.toStringAsFixed(2)} €",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              color: Colors.red.withOpacity(0.7)),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        // Descripción larga
                        Text(
                          desc,
                          style: TextStyle(
                              fontSize: 16,
                              color: modeloUsuario.isDarkMode
                                  ? Colors.white
                                  : Colors.black54),
                        ),
                        const SizedBox(height: 20),
                        // Botones de carrito y compra
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              onTap: () async {
                                if (modeloUsuario.inicioSesion) {
                                  final name = nombre;
                                  ProductoModel producto =
                                      ProductoModel(name: name, price: precio);
                                  final id = await dao.insert(producto,
                                      modeloUsuario.usuarioActual!.id);
                                  producto = producto.copyWith(id: id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Producto añadido al carrito correctamente'),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Por favor, inicie sesión para agregar al carrito.'),
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                    color: const Color(0xFFF7F8FA),
                                    borderRadius: BorderRadius.circular(30)),
                                child: const Icon(
                                  CupertinoIcons.cart_fill,
                                  size: 22,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            InkWell(
                              // Botón comprar ahora
                              onTap: () async {
                                if (!modeloUsuario.inicioSesion) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Por favor, inicie sesión para comprar.'),
                                    ),
                                  );
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Confirmar Pedido'),
                                        content: const Text(
                                            '¿Estás seguro de que deseas realizar este pedido?'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Cancelar'),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              Navigator.of(context).pop();

                                              final usuarioId =
                                                  Provider.of<ModeloUsuario>(
                                                          context,
                                                          listen: false)
                                                      .usuarioActual!
                                                      .id;
                                              // Insertar el nuevo pedido en la tabla Pedidos
                                              final pedidoId =
                                                  await dao.insertarPedido(
                                                      usuarioId,
                                                      DateTime.now(),
                                                      precio);

                                              // Insertar los detalles del pedido en la tabla DetallesPedido
                                              await dao.insertarDetallePedido(
                                                  pedidoId,
                                                  Random().nextInt(100) + 1,
                                                  1,
                                                  nombre,
                                                  precio);

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ListadoPedidos()),
                                              );

                                              // Muestra el mensaje de confirmación de compra
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Row(
                                                      children: [
                                                        Icon(
                                                          Icons.check_circle,
                                                          color: Colors.green,
                                                          size: 28.0,
                                                        ),
                                                        SizedBox(width: 10),
                                                        Text(
                                                            'Pedido Realizado'),
                                                      ],
                                                    ),
                                                    content: const Text(
                                                        'El pedido se ha realizado correctamente.'),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Text(
                                                            'Aceptar'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            child: const Text('Confirmar'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 18, horizontal: 70),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Text(
                                  "Comprar ahora",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
