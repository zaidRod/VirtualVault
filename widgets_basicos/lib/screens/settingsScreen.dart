// ignore_for_file: prefer_const_literals_to_create_immutables

import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:widgets_basicos/screens/pedidosScreen.dart";
import "package:widgets_basicos/view_models/modelo_usuario.dart";

class settingScreen extends StatelessWidget {
  const settingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ModeloUsuario>(
      builder: (context, ModeloUsuario, child) {
        return ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            // ignore: prefer_const_constructors
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.black,
              ),
              child: const Text(
                'Ajustes',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            _buildListTile(
              icon: Icons.local_shipping,
              title: 'Pedidos',
              onTap: () {
                // Navega a la pantalla ListadoPedidos
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListadoPedidos()),
                );
              },
            ),
            const ListTile(
              leading: Icon(Icons.favorite),
              title: Text('Favoritos'),
            ),
            const ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('Carrito'),
            ),
            const ListTile(
              leading: Icon(Icons.dark_mode),
              title: Text('Modo oscuro'),
            ),
            SizedBox(
              height: 250,
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Cerrar sesión"),
              onTap: () {
                ModeloUsuario.loginAdmin(false);
                ModeloUsuario.modificarBotonInicio(false);
                ModeloUsuario.cambiarNombre("");
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }
}
