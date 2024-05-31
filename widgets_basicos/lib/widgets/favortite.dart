import "dart:io";

import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:provider/provider.dart";
import "package:widgets_basicos/models/Favoritos.dart";
import "package:widgets_basicos/screens/ProductScreen.dart";
import "package:widgets_basicos/view_models/modelo_usuario.dart";

class FavoriteWidget extends StatefulWidget {
  final Favorito myFavorite;
  const FavoriteWidget({super.key, required this.myFavorite});

  @override
  State<FavoriteWidget> createState() => _FavoriteWidgetState();
}

class _FavoriteWidgetState extends State<FavoriteWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ModeloUsuario>(
      builder: (context, modeloUsuario, child) {
        return Center(
          child: Container(
            //decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            color: modeloUsuario.isDarkMode
                ? Colors.grey
                : const Color(0xFFF1F1F1),
            child: Stack(
              children: [
                Positioned(
                  top: 1,
                  right: 1,
                  child: IconButton(
                    icon: Icon(Icons.delete, size: 32, color: Colors.red),
                    onPressed: () async {
                      bool? confirmDelete = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Confirmar eliminación'),
                            content: Text(
                                '¿Estás seguro de que deseas eliminar este favorito?'),
                            actions: [
                              TextButton(
                                child: Text('Cancelar'),
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                              ),
                              TextButton(
                                child: Text('Eliminar'),
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirmDelete ?? false) {
                        int indexFav = modeloUsuario
                            .existFavorite(widget.myFavorite.nombre);
                        if (indexFav != -1) {
                          modeloUsuario.deleteFavorite(indexFav);
                        }
                      }
                    },
                  ),
                ),
                Positioned(
                  top: 45,
                  right: 0,
                  left: 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //Verificara si se le a dado tap a la imagen
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ProductScreen(
                                  widget.myFavorite.imagen,
                                  widget.myFavorite.nombre,
                                  widget.myFavorite.precio,
                                  widget.myFavorite.desc),
                            ),
                          );
                        },
                        child: Image.file(
                          File(widget.myFavorite.imagen),
                          fit: BoxFit.fill,
                          width: 111,
                          height: 180,
                        ),
                      ),
                      Text(
                        textAlign: TextAlign.center,
                        widget.myFavorite.nombre,
                        style: GoogleFonts.playfairDisplay(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${widget.myFavorite.precio.toStringAsFixed(2)} €",
                        style: GoogleFonts.playfairDisplay(fontSize: 16),
                      ),
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
