// ignore: file_names
// ignore: file_names
// ignore_for_file: empty_statements

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widgets_basicos/baseDeDatos/database_helper.dart';
import 'package:widgets_basicos/baseDeDatos/producto_dao.dart';
import 'package:widgets_basicos/baseDeDatos/producto_model.dart';
import 'package:widgets_basicos/screens/pedidosScreen.dart';
import 'package:widgets_basicos/view_models/modelo_usuario.dart';

class CarritoPage extends StatefulWidget {
  const CarritoPage({super.key});

  @override
  State<CarritoPage> createState() => _CarritoPageState();
}

class _CarritoPageState extends State<CarritoPage> {
  List<ProductoModel> productos = [];
  final dao = ProductoDao();
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  int totalInsert = 1;
  String nombreUsuario = "";
  String correoUsuario = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final modeloUsuario = Provider.of<ModeloUsuario>(context, listen: false);
      if (modeloUsuario.inicioSesion) {
        dao.readAll(modeloUsuario.usuarioActual!.id).then((value) {
          setState(() {
            productos = value;
          });
        });
      }
    });
  }

  int calcularTotal() {
    int total = 0;
    for (var producto in productos) {
      total += producto.price * producto.cantidad;
    }
    return total;
  }

  void mostrarMensajeCompra(BuildContext context, int total) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: Row(
            children: [
              const Icon(
                Icons.help_outline, // Icono de duda
                color: Colors.orange,
                size: 28.0,
              ),
              const SizedBox(width: 10),
              const Text('Confirmación'),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8.0),
                const Divider(),
                const SizedBox(height: 8.0),
                const Text(
                  'Detalle del pedido:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                const SizedBox(height: 8.0),
                Container(
                  height: 150.0,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: productos.length,
                    itemBuilder: (context, index) {
                      final producto = productos[index];
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 0.0),
                        title: Text(
                          producto.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                          ),
                        ),
                        subtitle: Text(
                          '${producto.cantidad} x ${producto.price.toStringAsFixed(2)} €',
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8.0),
                const Divider(),
                const SizedBox(height: 8.0),
                Text(
                  'Total: ${total.toStringAsFixed(2)} €',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                final usuarioId =
                    Provider.of<ModeloUsuario>(context, listen: false)
                        .usuarioActual!
                        .id;
                // Insertar el nuevo pedido en la tabla Pedidos
                final pedidoId = await dao.insertarPedido(
                    usuarioId, DateTime.now(), totalInsert);

                // Insertar los detalles del pedido en la tabla DetallesPedido
                for (final producto in productos) {
                  await dao.insertarDetallePedido(pedidoId, producto.id,
                      producto.cantidad, producto.name, producto.price);
                }

                //----Envio de email de confirmación del pedido ---//

                correoUsuario = await dao.mostrarCorreo(usuarioId);
                nombreUsuario = await dao.mostrarNombreUsuario(usuarioId);

                String mensajeCorreo = " ";
                productos.forEach(
                  (element) {
                    mensajeCorreo =
                        "$mensajeCorreo\n✅  ${element.name}\n\t\t\tCantidad: ${element.cantidad}";
                  },
                );
                await _databaseHelper.sendEmail(
                  name: nombreUsuario,
                  email: correoUsuario,
                  subject: 'Confirmación de pedido: Virtual Vault',
                  message:
                      'Hola $nombreUsuario, \n ----------------------------------------------------------------------\n¡Gracias por realizar tu pedido en nuestra aplicación ! $mensajeCorreo \n ---------------------------------------------------------------------- \n 💶 Total del pedido: ${calcularTotal()}€  \n ---------------------------------------------------------------------- \nSaludos,\nEquipo de Soporte',
                );

                await _databaseHelper.sendEmail(
                  name: nombreUsuario,
                  email: "virtual.vault11@gmail.com",
                  subject: 'Nuevo pedido realizado por $nombreUsuario',
                  message: 'Hola Admin, \n ---------------------------------------------------------------------- \n¡ Se ha realizado un pedido a nombre de $nombreUsuario ! $mensajeCorreo \n ---------------------------------------------------------------------- \n Correo del cliente: $correoUsuario \n\n Saludos. 😎',
                );

                //-----Creación del string para whatsapp ---//
                String whatsappMessage = "🚐 Resumen del pedido:";
                productos.forEach(
                  (element) {
                    whatsappMessage =
                        "$whatsappMessage\n✅  ${element.name}\n\t\t\tCantidad: ${element.cantidad}";
                  },
                );
                whatsappMessage =
                    "$whatsappMessage\n💶 Total del pedido: ${calcularTotal()}€";
                // --- Envio del mensaje-------//
                /*sendWhatsApp(
                    phoneNumber: "34642054838", message: whatsappMessage);*/

                productos.clear(); // Borra todos los productos del carrito
                dao.limpiarCarrito(
                    Provider.of<ModeloUsuario>(context, listen: false)
                        .usuarioActual!
                        .id);

                setState(() {}); // Actualiza la UI
                Navigator.of(context).pop(); // Cierra el diálogo actual

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListadoPedidos()),
                );

                // Muestra el mensaje de confirmación de compra
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Row(
                        children: [
                          Icon(
                            Icons.check_circle, // Icono de verificación
                            color: Colors.green,
                            size: 28.0,
                          ),
                          SizedBox(width: 10),
                          Text('Pedido Realizado'),
                        ],
                      ),
                      content: Text('El pedido se ha realizado correctamente.'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Aceptar'),
                        ),
                      ],
                    );
                  },
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Carrito de Compras',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
          ),
        ),
        backgroundColor: Colors.teal,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // Acción del botón de carrito, si es necesario
            },
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal, Colors.green],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: productos.isEmpty
          ? const Center(
              child: Text(
                'El carrito está vacío',
                style: TextStyle(fontSize: 18.0),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.only(
                  left: 8.0,
                  right: 8.0,
                  top: 8.0,
                  bottom: 80.0), // Añado padding inferior
              itemCount: productos.length,
              itemBuilder: (context, index) {
                final producto = productos[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                producto.name,
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                '${producto.price.toStringAsFixed(2)} €',
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () async {
                                if (producto.cantidad > 1) {
                                  producto.cantidad--;
                                  await dao.update(
                                      producto,
                                      Provider.of<ModeloUsuario>(context,
                                              listen: false)
                                          .usuarioActual!
                                          .id);
                                  setState(() {});
                                }
                              },
                              icon: const Icon(Icons.remove),
                              color: Colors.teal,
                            ),
                            Text(
                              '${producto.cantidad}',
                              style: const TextStyle(fontSize: 18.0),
                            ),
                            IconButton(
                              onPressed: () async {
                                if (producto.cantidad < 99) {
                                  producto.cantidad++;
                                  await dao.update(
                                      producto,
                                      Provider.of<ModeloUsuario>(context,
                                              listen: false)
                                          .usuarioActual!
                                          .id);
                                  setState(() {});
                                }
                              },
                              icon: const Icon(Icons.add),
                              color: Colors.teal,
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () async {
                            await dao.delete(
                                producto,
                                Provider.of<ModeloUsuario>(context,
                                        listen: false)
                                    .usuarioActual!
                                    .id);
                            setState(() {
                              productos.removeWhere(
                                  (element) => element.id == producto.id);
                            });
                          },
                          icon: const Icon(Icons.delete),
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: productos.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  int total = calcularTotal();
                  totalInsert = total;
                  mostrarMensajeCompra(context, total);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: const Text(
                  'Realizar Compra',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
