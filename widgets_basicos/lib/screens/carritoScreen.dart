// ignore: file_names
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widgets_basicos/baseDeDatos/producto_dao.dart';
import 'package:widgets_basicos/baseDeDatos/producto_model.dart';
import 'package:widgets_basicos/view_models/modelo_usuario.dart';

class CarritoPage extends StatefulWidget {
  const CarritoPage({super.key});

  @override
  State<CarritoPage> createState() => _CarritoPageState();
}

class _CarritoPageState extends State<CarritoPage> {
  List<ProductoModel> productos = [];
  final dao = ProductoDao();

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

  double calcularTotal() {
    double total = 0.0;
    for (var producto in productos) {
      total += producto.price * producto.cantidad;
    }
    return total;
  }

  void mostrarMensajeCompra(BuildContext context, double total) {
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
                Icons.check_circle,
                color: Colors.green,
                size: 28.0,
              ),
              const SizedBox(width: 10),
              const Text('Compra Realizada'),
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
                backgroundColor: Colors.teal,
                primary: Colors.white,
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
                  double total = calcularTotal();
                  mostrarMensajeCompra(context, total);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.teal,
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
