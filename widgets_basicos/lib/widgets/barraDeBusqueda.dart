import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:widgets_basicos/models/carga_Datos.dart";
import "package:widgets_basicos/view_models/modelo_usuario.dart";
import "package:widgets_basicos/widgets/searchProductDelegate.dart";

class MySearchBar extends StatelessWidget {
  const MySearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ModeloUsuario>(
      builder: (context, modeloUsuario, child) {
        return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: Colors.black12),
          margin: EdgeInsets.all(5),
          child: ListTile(
            title: Text("Buscar juego 🧐"),
            leading: Icon(Icons.search),
            onTap: () {
              showSearch(
                context: context,
                delegate: SearchProductDelegate(listadoProductos),
              );
            },
          ),
        );
      },
    );
  }
}
