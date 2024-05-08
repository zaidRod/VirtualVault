import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:widgets_basicos/view_models/modelo_usuario.dart";

class ListadoFavoritos extends StatelessWidget {
  const ListadoFavoritos({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ModeloUsuario>(
      builder: (context, ModeloUsuario, child) {
        if (ModeloUsuario.numFavorites == 0) {
          return const Center(
            child: Text(
              "No tienes ningun favorito.",
              style: TextStyle(fontSize: 18),
            ),
          );
        }

        return Container(
          decoration: BoxDecoration(
              color: Colors.lightGreen,
              borderRadius: BorderRadius.circular(20)),
          child: ListView.separated(
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 15,
              );
            },
            itemCount: ModeloUsuario.numFavorites,
            itemBuilder: (context, index) {
              return Dismissible(
                onDismissed: (direction) {
                  ModeloUsuario.deleteFavorite(index);
                },
                key: UniqueKey(),
                child: Container(
                  child: ListTile(
                    leading: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(ModeloUsuario.favorites[index].nombre),
                        Text(
                          ModeloUsuario.favorites[index].precio.toString() +
                              ".00 €",
                        ),
                        ElevatedButton(
                          onPressed: () {
                            ModeloUsuario.deleteFavorite(index);
                          },
                          child: const Icon(Icons.delete, color: Colors.black),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
