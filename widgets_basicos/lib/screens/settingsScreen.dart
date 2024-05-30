// settingScreen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widgets_basicos/screens/pedidosScreen.dart';
import 'package:widgets_basicos/view_models/modelo_usuario.dart';

class settingScreen extends StatelessWidget {
  const settingScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ModeloUsuario>(
      builder: (context, modeloUsuario, child) {
        return ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: modeloUsuario.isDarkMode ? Colors.black : Colors.blue,
              ),
              child: Text(
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
            ListTile(
              leading: Icon(Icons.dark_mode),
              title: Text(modeloUsuario.isDarkMode ? 'Modo Claro' : 'Modo Oscuro'),
              onTap: () {
                // Cambiar el modo entre claro y oscuro
                modeloUsuario.toggleDarkMode();
              },
            ),
            SizedBox(
              height: 250,
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Cerrar sesión"),
              onTap: () {
                // Cierra la sesión del usuario
                modeloUsuario.cerrarSesion();
                // Actualiza el estado de la aplicación
                modeloUsuario.loginAdmin(false);
                modeloUsuario.modificarBotonInicio(false);
                modeloUsuario.cambiarNombre("");
                // Navega fuera de la pantalla actual
                Navigator.of(context).pop();
              },
            ),
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
