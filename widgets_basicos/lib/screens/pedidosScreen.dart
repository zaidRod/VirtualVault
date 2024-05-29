import 'package:flutter/material.dart';
import 'package:widgets_basicos/baseDeDatos/producto_dao.dart';
import 'package:widgets_basicos/models/pedido.dart';
import 'package:widgets_basicos/models/producto_pedido.dart';

class ListadoPedidos extends StatefulWidget {
  ListadoPedidos({Key? key}) : super(key: key);

  @override
  _ListadoPedidosState createState() => _ListadoPedidosState();
}

class _ListadoPedidosState extends State<ListadoPedidos> {
  final dao = ProductoDao();
  late Future<List<Pedido>> _pedidosFuture;

  @override
  void initState() {
    super.initState();
    _pedidosFuture = dao.obtenerPedidosConDetalles();
  }

  void _refreshPedidos() {
    setState(() {
      _pedidosFuture = dao.obtenerPedidosConDetalles();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Listado de Pedidos',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
          ),
        ),
        backgroundColor: Colors.teal,
        elevation: 0,
        centerTitle: true,
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
      body: FutureBuilder<List<Pedido>>(
        future: _pedidosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            final pedidos = snapshot.data!;
            if (pedidos.isEmpty) {
              return Center(
                child: Text(
                  'No se han realizado pedidos.',
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              );
            }
            return ListView.builder(
              itemCount: pedidos.length,
              itemBuilder: (context, index) {
                final pedido = pedidos[index];
                // Resto del código para construir cada elemento de la lista de pedidos
                final fechaPedido = DateTime.parse(pedido.fecha);
                final fechaFormateada =
                    '${fechaPedido.day}/${fechaPedido.month}/${fechaPedido.year}';
                final horaFormateada =
                    '${fechaPedido.hour}:${fechaPedido.minute}:${fechaPedido.second}';

                return Card(
                  color: Colors.grey[200], // Fondo más oscuro
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Numero de pedido: ${pedido.id}',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                bool? confirmDelete = await showDialog<bool>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Confirmar eliminación'),
                                      content: Text(
                                          '¿Estás seguro de que deseas eliminar este pedido?'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('Cancelar'),
                                          onPressed: () {
                                            Navigator.of(context).pop(false);
                                          },
                                        ),
                                        TextButton(
                                          child: Text('Eliminar'),
                                          onPressed: () {
                                            Navigator.of(context).pop(true);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );

                                if (confirmDelete == true) {
                                  // Lógica para borrar el pedido
                                  await dao.borrarPedido(pedido.id);
                                  // Actualizar la lista después de borrar
                                  _refreshPedidos();
                                }
                              },
                            ),
                          ],
                        ),
                        Divider(),
                        SizedBox(height: 8.0),
                        Text(
                          'Fecha: $fechaFormateada',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          'Hora: $horaFormateada',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                        ),
                        Divider(),
                        SizedBox(height: 8.0),
                        Text(
                          'Total: ${pedido.total} €',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Divider(), // Línea separadora
                        SizedBox(height: 8.0),
                        Text(
                          'Productos:',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        FutureBuilder<List<ProductoPedido>>(
                          future: dao.obtenerProductosPedido(pedido.id),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text('Error: ${snapshot.error}'),
                              );
                            } else if (snapshot.hasData) {
                              final productosPedido = snapshot.data!;
                              return Column(
                                children: productosPedido
                                    .map(
                                      (productoPedido) => ListTile(
                                        title: Text(
                                          '${productoPedido.cantidad} x ${productoPedido.nombre}',
                                        ),
                                      ),
                                    )
                                    .toList(),
                              );
                            } else {
                              return SizedBox.shrink();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }
}
