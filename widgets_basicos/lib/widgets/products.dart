import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:widgets_basicos/models/Favoritos.dart';
import 'package:widgets_basicos/screens/productScreen.dart';

import '../view_models/modelo_usuario.dart';

class ProductWidget extends StatefulWidget {
  final String nombre;
  final int precio;
  final String desc;
  final String image;

  ProductWidget({
    super.key,
    required this.nombre,
    required this.precio,
    required this.desc,
    required this.image,
  });

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ModeloUsuario>(
      builder: (context, ModeloUsuario, child) {
        final bool esAdmin = ModeloUsuario.esAdmin;
        final bool esFavorito =
            ModeloUsuario.existFavorite(widget.nombre) != -1;

        return Center(
          child: Container(
            color: const Color(0xFFF1F1F1),
            child: Stack(
              children: [
                Positioned(
                  top: 1,
                  right: 1,
                  child: Padding(
                    padding: EdgeInsets.only(top: 6, right: 9),
                    child: InkWell(
                      onTap: () {
                        int indexFav =
                            ModeloUsuario.existFavorite(widget.nombre);

                        //Si existe el favorito lo borra

                        if (indexFav != -1) {
                          ModeloUsuario.deleteFavorite(indexFav);
                        } else {
                          //Lo agrega
                          ModeloUsuario.addFavorite(
                            Favorito(
                                widget.nombre, widget.image, widget.precio),
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
                  top: 25,
                  right: 0,
                  left: 0,
                  child: Column(
                    children: [
                      //Verificara si se le a dado tap a la imagen
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ProductScreen(widget.image,
                                  widget.nombre, widget.precio, widget.desc),
                            ),
                          );
                        },
                        child: Image.asset(
                          "assets/images/Carrusel2.jpg",
                          fit: BoxFit.contain,
                          width: 111,
                          height: 111,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        widget.nombre,
                        style: GoogleFonts.playfairDisplay(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${widget.precio.toStringAsFixed(2)} €",
                        style: GoogleFonts.playfairDisplay(fontSize: 16),
                      ),
                      //Fila de los botones de edicion y borrado
                      Visibility(
                        visible: esAdmin,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              child: Icon(Icons.border_color_outlined),
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              child: Icon(Icons.delete_outline),
                            )
                          ],
                        ),
                      )
                    ],
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
