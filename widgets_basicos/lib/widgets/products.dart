import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:widgets_basicos/baseDeDatos/producto_dao.dart';
import 'package:widgets_basicos/models/Favoritos.dart';
import 'package:widgets_basicos/models/carga_Datos.dart';
import 'package:widgets_basicos/models/productsModel.dart';
import 'package:widgets_basicos/screens/productScreen.dart';

import '../view_models/modelo_usuario.dart';

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
  @override
  //Controlador de la base de datos.
  final dao = ProductoDao();

  Widget build(BuildContext context) {
    return Consumer<ModeloUsuario>(
      builder: (context, ModeloUsuario, child) {
        final bool esAdmin = ModeloUsuario.esAdmin;
        final bool esFavorito =
            ModeloUsuario.existFavorite(widget.producto.name) != -1;

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
                            ModeloUsuario.existFavorite(widget.producto.name);

                        //Si existe el favorito lo borra

                        if (indexFav != -1) {
                          ModeloUsuario.deleteFavorite(indexFav);
                        } else {
                          //Lo agrega
                          ModeloUsuario.addFavorite(
                            Favorito(widget.producto.name,
                                widget.producto.image, widget.producto.price),
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
                              builder: (context) => ProductScreen(
                                  widget.producto.image,
                                  widget.producto.name,
                                  widget.producto.price,
                                  widget.producto.desc),
                            ),
                          );
                        },
                        child: Image.asset(
                          widget.producto.image,
                          fit: BoxFit.contain,
                          width: 111,
                          height: 111,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        widget.producto.name,
                        style: GoogleFonts.playfairDisplay(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${widget.producto.price.toStringAsFixed(2)} €",
                        style: GoogleFonts.playfairDisplay(fontSize: 16),
                      ),
                      //Fila de los botones de edicion y borrado
                      Visibility(
                        visible: esAdmin,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              //Boton de edicion
                              onPressed: () {},
                              child: Icon(Icons.border_color_outlined),
                            ),
                            ElevatedButton(
                              //Boton de borrado
                              onPressed: () async {
                                dao.deleteProduct(widget.producto.id);
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
              ],
            ),
          ),
        );
      },
    );
  }
}
