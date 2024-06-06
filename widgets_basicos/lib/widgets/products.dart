import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:widgets_basicos/baseDeDatos/productoDao.dart';
import 'package:widgets_basicos/forms/updateForm.dart';
import 'package:widgets_basicos/models/favoritesModel.dart';
import 'package:widgets_basicos/models/productsModel.dart';
import 'package:widgets_basicos/screens/productsScreen.dart';

import '../view_models/modeloUsuario.dart';

class ProductWidget extends StatefulWidget {
  final Product producto;

  ProductWidget({
    super.key,
    required this.producto,
  });

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  //Controlador de la base de datos.
  final dao = ProductoDao();

  Widget build(BuildContext context) {
    //Funcion que llama al nuevo articulo
    updateArticulo(context) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              //LLamada al formulario
              content: UpdateForm(
                producto: widget.producto,
              ),
            );
          });
    }

    return Consumer<ModeloUsuario>(
      builder: (context, ModeloUsuario, child) {
        final bool esAdmin = ModeloUsuario.esAdmin;
        final bool esFavorito =
            ModeloUsuario.existFavorite(widget.producto.name) != -1;

        return Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: ModeloUsuario.isDarkMode
                  ? Colors.grey
                  : const Color(0xFFF1F1F1),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 1,
                  right: 1,
                  child: Padding(
                    padding: EdgeInsets.only(top: 6, right: 9),
                    child: InkWell(
                      onTap: () async {
                        int indexFav =
                            ModeloUsuario.existFavorite(widget.producto.name);

                        if (indexFav != -1) {
                          ModeloUsuario.deleteFavorite(indexFav);
                        } else {
                          ModeloUsuario.addFavorite(
                            Favorito(
                                id: 0, // Autoincremental en la BD
                                imagen: widget.producto.image,
                                nombre: widget.producto.name,
                                precio: widget.producto.price,
                                desc: widget.producto.desc),
                          );
                        }
                      },
                      child: Icon(
                        Icons.favorite,
                        size: 20,
                        // Dependiendo si es favorito o no lo pinta de un color u otro
                        color: esFavorito ? Colors.red : Colors.black,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 30,
                  right: 0,
                  left: 0,
                  child: Center(
                    child: Column(
                      children: [
                        //Verificara si se le a dado tap a la imagen
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ProductScreen(
                                    widget.producto.image,
                                    widget.producto.name,
                                    widget.producto.price,
                                    widget.producto.desc),
                              ),
                            );
                          },
                          child: Image.file(
                            File(widget.producto.image),
                            fit: BoxFit.fill,
                            height: 160,
                            width: 120,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          textAlign: TextAlign.center,
                          widget.producto.name,
                          style: GoogleFonts.montserrat(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${widget.producto.price.toStringAsFixed(2)} €",
                          style: GoogleFonts.montserrat(fontSize: 18),
                        ),
                        //Fila de los botones de edicion y borrado
                        Visibility(
                          visible: esAdmin,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                //Boton de edicion
                                onPressed: () {
                                  updateArticulo(context);
                                },
                                child: Icon(Icons.border_color_outlined),
                              ),
                              ElevatedButton(
                                //Boton de borrado
                                onPressed: () async {
                                  await dao.deleteProduct(widget.producto.id);
                                  ModeloUsuario.actualizarGrid();
                                },
                                child: Icon(Icons.delete_outline),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
