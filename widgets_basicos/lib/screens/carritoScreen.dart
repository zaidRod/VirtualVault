import 'package:flutter/material.dart';
import 'package:widgets_basicos/baseDeDatos/producto_dao.dart';
import 'package:widgets_basicos/baseDeDatos/producto_model.dart';

class CarritoPage extends StatefulWidget {
  const CarritoPage({super.key});

  @override
  State<CarritoPage> createState() => _CarritoPageState();
}

class _CarritoPageState extends State<CarritoPage> {
  final controller = TextEditingController();
  List<ProductoModel> productos = [];
  final dao = ProductoDao();
  @override
  void initState() {
    super.initState();
    dao.readAll().then((value) {
      setState(() {
        productos = value;
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
          ),
          ListView.builder(
            physics:
                const NeverScrollableScrollPhysics(), // Deshabilita el desplazamiento del ListView
            primary: false,
            shrinkWrap: true,
            itemCount: productos.length,
            itemBuilder: ((context, index) {
              final producto = productos[index];
              return Padding(
                padding: const EdgeInsets.all(2.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 153, 152, 150),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  padding: const EdgeInsets.all(15),
                  margin: const EdgeInsets.symmetric(
                      vertical: 2.0, horizontal: 20.0),
                  child: Row(
                    children: [
                      Text('${producto.id}'), // id de los productos
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Text(
                          producto.name, //nombre de los productos
                          style: const TextStyle(fontSize: 16.0),
                        ),
                      ),
                      SizedBox(
                        width: 25,
                        child: IconButton(
                          onPressed: () async {
                            if (producto.cantidad > 1) {
                              producto.cantidad--;
                              await dao.update(producto);
                              setState(() {});
                            }
                          },
                          icon: const Icon(Icons.remove),
                          color: const Color.fromARGB(255, 0, 0, 0),
                          iconSize: 18,
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Text(
                        '${producto.cantidad}', //cantidad de productos
                        style: const TextStyle(fontSize: 16.0),
                      ),
                      const SizedBox(width: 5.0),
                      SizedBox(
                        width: 25,
                        child: IconButton(
                          onPressed: () async {
                            if (producto.cantidad < 99) {
                              producto.cantidad++;
                              await dao.update(producto);
                              setState(() {});
                            }
                          },
                          icon: const Icon(Icons.add),
                          color: const Color.fromARGB(255, 0, 0, 0),
                          iconSize: 18,
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      IconButton(
                        onPressed: () async {
                          await dao.delete(producto);
                          setState(() {
                            productos.removeWhere(
                                (element) => element.id == producto.id);
                          });
                        },
                        icon: const Icon(Icons.delete),
                        color: const Color.fromARGB(255, 248, 70, 70),
                        iconSize: 22,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
