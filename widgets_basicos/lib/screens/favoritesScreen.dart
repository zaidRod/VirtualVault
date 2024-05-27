import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widgets_basicos/view_models/modelo_usuario.dart';

class ListadoFavoritos extends StatelessWidget {
  const ListadoFavoritos({Key? key});

  get nombre => null;

  get precio => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            return const Center(
              child: Text(
                "No tienes ningun favorito.",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: modeloUsuario.numFavorites,
            itemBuilder: (context, index) {
              final favorito = modeloUsuario.favorites[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  leading: const Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 30.0,
                  ),
                  title: Text(
                    favorito.nombre,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '${favorito.precio.toStringAsFixed(2)} €',
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          modeloUsuario.deleteFavorite(index);
                        },
                      ),
                      IconButton(
                          icon: const Icon(Icons.shopping_cart),
                          onPressed: () async {}),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
