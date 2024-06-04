import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widgets_basicos/models/Favoritos.dart';
import 'package:widgets_basicos/screens/home_pageScreen.dart';
import 'package:widgets_basicos/view_models/modelo_usuario.dart';
import 'package:widgets_basicos/widgets/favortite.dart';

class ListadoFavoritos extends StatelessWidget {
  const ListadoFavoritos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: Icon(Icons.favorite),
          )
        ],
        title: const Text(
          'Favoritos',
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
      body: Consumer<ModeloUsuario>(
        builder: (context, modeloUsuario, child) {
          if (modeloUsuario.numFavorites == 0) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    color: Colors.grey,
                    size: 80,
                  ),
                  const Text(
                    "No tienes ningun favorito. 😯",
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  //Si no hay productos en favoritos envia al home page
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()),
                      );
                    },
                    child: const Text('Agregar Productos'),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: modeloUsuario.numFavorites,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 13,
                crossAxisSpacing: 13,
                mainAxisExtent: 310,
              ),
              itemBuilder: (context, index) {
                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: FavoriteWidget(
                    myFavorite: Favorito(
                      id: modeloUsuario.favorites[index].id,
                      imagen: modeloUsuario.favorites[index].imagen,
                      nombre: modeloUsuario.favorites[index].nombre,
                      precio: modeloUsuario.favorites[index].precio,
                      desc: modeloUsuario.favorites[index].desc,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
