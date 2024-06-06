import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widgets_basicos/baseDeDatos/databaseHelper.dart';
import 'package:widgets_basicos/baseDeDatos/productoDao.dart';
import 'package:widgets_basicos/baseDeDatos/productoModel.dart';
import 'package:widgets_basicos/models/favoritesModel.dart';
import 'package:widgets_basicos/screens/pedidosScreen.dart';
import 'package:widgets_basicos/view_models/modeloUsuario.dart';

class ProductScreen extends StatefulWidget {
  final String image;
  final String nombre;
  final int precio;
  final String desc;

  ProductScreen(this.image, this.nombre, this.precio, this.desc, {super.key});

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool isButtonEnabled = true;

  final ProductoDao dao = ProductoDao();
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  bool estaCargado = true;

  @override
  Widget build(BuildContext context) {
    return Consumer<ModeloUsuario>(
      builder: (context, modeloUsuario, child) {
        final bool esFavorito =
            modeloUsuario.existFavorite(widget.nombre) != -1;

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
                          image: FileImage(File(widget.image)),
                          fit: BoxFit.cover),
                    ),
                    child: Column(
                      children: [
                        Padding(
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
                                  child: Icon(Icons.arrow_back_ios_new,
                                      size: 22, color: Colors.black),
                                ),
                              ),
                              Spacer(
                                flex: 1,
                              ),
                              //Boton de compartir
                              Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: InkWell(
                                  onTap: () {
                                    compartirWhatsApp(
                                        nombreProducto: widget.nombre,
                                        precio: widget.precio,
                                        desc: widget.desc);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30),
                                    ),

                                    // Botón de compartir
                                    child: const Icon(
                                      Icons.share,
                                      size: 22,
                                    ),
                                  ),
                                ),
                              ),

                              // Botón de favorito
                              InkWell(
                                onTap: () {
                                  int indexFav = modeloUsuario
                                      .existFavorite(widget.nombre);
                                  // Si existe el favorito lo borra
                                  if (indexFav != -1) {
                                    modeloUsuario.deleteFavorite(indexFav);
                                  } else {
                                    // Lo agrega
                                    modeloUsuario.addFavorite(
                                      Favorito(
                                          id: 0,
                                          nombre: widget.nombre,
                                          imagen: widget.image,
                                          precio: widget.precio,
                                          desc: widget.desc),
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
                                    color:
                                        esFavorito ? Colors.red : Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
                                widget.nombre,
                                style: const TextStyle(
                                    fontSize: 28, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),

                        // Precio del producto
                        Text(
                          "${widget.precio.toStringAsFixed(2)} €",
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
                          widget.desc,
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
                              onTap: isButtonEnabled
                                  ? () async {
                                      setState(() {
                                        isButtonEnabled = false;
                                      });

                                      if (modeloUsuario.inicioSesion) {
                                        final name = widget.nombre;
                                        ProductoModel producto = ProductoModel(
                                            name: name, price: widget.precio);
                                        final id = await dao.insert(producto,
                                            modeloUsuario.usuarioActual!.id);
                                        producto = producto.copyWith(id: id);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            duration: Duration(
                                                seconds: 1, microseconds: 30),
                                            content: Text(
                                                'Producto añadido al carrito correctamente'),
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Por favor, inicie sesión para agregar al carrito.'),
                                          ),
                                        );
                                      }

                                      // Habilitar el botón después de 10 segundos
                                      await Future.delayed(
                                          Duration(seconds: 10));
                                      if (mounted) {
                                        setState(() {
                                          isButtonEnabled = true;
                                        });
                                      }
                                    }
                                  : null,
                              child: Container(
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                    color: isButtonEnabled
                                        ? const Color(0xFFF7F8FA)
                                        : Colors.grey,
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
                                              if (estaCargado) {
                                                showDialog(
                                                  barrierDismissible: false,
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return const AlertDialog(
                                                      title: Row(
                                                        children: [
                                                          CircularProgressIndicator(),
                                                          SizedBox(width: 20),
                                                          Text(
                                                              "Realizando pedido")
                                                        ],
                                                      ),
                                                      content: Text(
                                                          "Por favor espera mientras se procesa"),
                                                    );
                                                  },
                                                );
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
                                                        widget.precio);

                                                // Insertar los detalles del pedido en la tabla DetallesPedido
                                                await dao.insertarDetallePedido(
                                                    pedidoId,
                                                    Random().nextInt(100) + 1,
                                                    1,
                                                    widget.nombre,
                                                    widget.precio);

                                                //----Envio de email de confirmación del pedido ---//
                                                String correoUsuario = await dao
                                                    .mostrarCorreo(usuarioId);
                                                String nombreUsuario = await dao
                                                    .mostrarNombreUsuario(
                                                        usuarioId);
                                                String mensajeCorreo =
                                                    "✅ ${widget.nombre}";

                                                await _databaseHelper.sendEmail(
                                                  name: nombreUsuario,
                                                  email: correoUsuario,
                                                  subject:
                                                      'Confirmación de pedido: Virtual Vault',
                                                  message:
                                                      'Hola $nombreUsuario, \n\n¡Gracias por realizar tu pedido en nuestra aplicación !/n/n $mensajeCorreo \n/n 💶 Total del pedido: ${widget.precio}€  \n\nSaludos,\nEquipo de Soporte',
                                                );

                                                Navigator.of(context)
                                                    .pop(); // Cierra el progres indicator bar
                                                Navigator.of(context)
                                                    .pop(); //Cerrar la ventana de confirmacion
                                                // ignore: use_build_context_synchronously
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
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: const Text(
                                                              'Aceptar'),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                                //Cierra el bloqueo de la pantalla
                                                setState(
                                                  () {
                                                    estaCargado = false;
                                                  },
                                                );
                                                //Vuelve a colocar el alert de carga para la proxima compra
                                                estaCargado = true;
                                              }
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
