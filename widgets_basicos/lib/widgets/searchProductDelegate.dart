import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:widgets_basicos/models/carga_Datos.dart';
import 'package:widgets_basicos/models/productsModel.dart';
import 'package:widgets_basicos/screens/ProductScreen.dart';
import 'package:widgets_basicos/widgets/products.dart';

class SearchProductDelegate extends SearchDelegate<Product> {
  @override
  String get searchFieldLabel => 'Buscar juego';

  final List<ProductWidget> poductos;

  SearchProductDelegate(this.poductos);
  List<ProductWidget> filtroResultados = [];

  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      //Borra el contenido de la busqueda
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: Icon(Icons.close))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // Boton de volver
    return IconButton(
        onPressed: () {
          close(
              context,
              //Cuando se cierra no quiero que devuelva nada
              Product(name: "name", price: 0, desc: "desc", image: "image"));
        },
        icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListView.builder(
      itemCount: filtroResultados.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(filtroResultados[index].producto.name),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProductScreen(
                    filtroResultados[index].producto.image,
                    filtroResultados[index].producto.name,
                    filtroResultados[index].producto.price,
                    filtroResultados[index].producto.desc),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    filtroResultados = listadoProductos.where((element) {
      return element.producto.name
          .toLowerCase()
          .contains(query.trim().toLowerCase());
    }).toList();
    return ListView.builder(
      itemCount: filtroResultados.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(filtroResultados[index].producto.name,
              style: GoogleFonts.montserrat(fontSize: 18)),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProductScreen(
                    filtroResultados[index].producto.image,
                    filtroResultados[index].producto.name,
                    filtroResultados[index].producto.price,
                    filtroResultados[index].producto.desc),
              ),
            );
          },
        );
      },
    );
  }
}
