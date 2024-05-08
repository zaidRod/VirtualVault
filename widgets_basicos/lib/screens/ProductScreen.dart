import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:widgets_basicos/baseDeDatos/producto_dao.dart";
import "package:widgets_basicos/baseDeDatos/producto_model.dart";
import "package:widgets_basicos/models/Favoritos.dart";
import "package:widgets_basicos/view_models/modelo_usuario.dart";

class ProductScreen extends StatelessWidget {
  final String image;
  final String nombre;
  final int precio;
  final String desc;

  ProductScreen(this.image, this.nombre, this.precio, this.desc, {super.key}) {
    super.key;
  }
  //Metodos de insert y de la base de datos
  final dao = ProductoDao();
  @override
  Widget build(BuildContext context) {
    return Consumer<ModeloUsuario>(
      builder: (context, ModeloUsuario, child) {
        final bool esFavorito = ModeloUsuario.existFavorite(nombre) != -1;

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
                      color: Color.fromARGB(255, 244, 224, 224),
                      image: DecorationImage(
                          image: AssetImage(image), fit: BoxFit.cover),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //Boton de volver
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
                              child: const Icon(
                                Icons.arrow_back_ios_new,
                                size: 22,
                              ),
                            ),
                          ),

                          //Boton de favorito
                          InkWell(
                            onTap: () {
                              int indexFav =
                                  ModeloUsuario.existFavorite(nombre);
                              //Si existe el favorito lo borra

                              if (indexFav != -1) {
                                ModeloUsuario.deleteFavorite(indexFav);
                              } else {
                                //Lo agrega
                                ModeloUsuario.addFavorite(
                                  Favorito(nombre, image, precio),
                                );
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                              ),

                              //Boton de favorito
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //Nombre del producto
                              Text(
                                nombre,
                                style: const TextStyle(
                                    fontSize: 28, fontWeight: FontWeight.bold),
                              ),
                              //Precio del producto
                              Text(
                                "${precio.toStringAsFixed(2)} €",
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.red.withOpacity(0.7)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        //Descripcion simple
                        const Text(
                          "Infoooo",
                          style: TextStyle(color: Colors.black54, fontSize: 16),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        //Descripcion larga
                        Text(
                          desc,
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                        const SizedBox(height: 20),
                        //Botones de carrito y compra
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              onTap: () async {
                                final name = nombre;
                                ProductoModel producto =
                                    ProductoModel(name: name);
                                final id = await dao.Insert(producto);
                                producto = producto.copyWith(id: id);

                                //agregarCarrito(producto);
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
                              //Boton comprara ahora
                              onTap: () {},
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
