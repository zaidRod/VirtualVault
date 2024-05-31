import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widgets_basicos/screens/pedidosScreen.dart';
import 'package:widgets_basicos/screens/adminScreen.dart';
import 'package:widgets_basicos/view_models/modelo_usuario.dart';

class settingScreen extends StatelessWidget {
  const settingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ModeloUsuario>(
      builder: (context, modeloUsuario, child) {
        print(
            "Usuario admin: ${modeloUsuario.esAdmin}"); // Mensaje de depuración
        return ListView(
          padding: EdgeInsets.zero,
          children: _buildSettings(context, modeloUsuario),
        );
      },
    );
  }

  List<Widget> _buildSettings(
      BuildContext context, ModeloUsuario modeloUsuario) {
    List<Widget> settings = [
      DrawerHeader(
        child: Text(
          'Ajustes',
          style: TextStyle(
            color: modeloUsuario.isDarkMode ? Colors.white : Colors.black,
            fontSize: 24,
          ),
        ),
      ),
      _buildListTile(
        icon: Icons.local_shipping,
        title: 'Pedidos',
        onTap: () {
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
          modeloUsuario.toggleDarkMode();
        },
      ),
      const SizedBox(
        height: 250,
      ),
      ListTile(
        leading: const Icon(Icons.logout),
        title: const Text("Cerrar sesión"),
        onTap: () {
          modeloUsuario.cerrarSesion();
          Navigator.of(context).pop();
        },
      ),
    ];
    // Si el usuario es 'admin', agregar funciones específicas del administrador
    if (modeloUsuario.esAdmin) {
      settings.insert(
        5, // Índice donde quieres insertar las funciones del administrador
        _buildListTile(
          icon: Icons.settings,
          title: 'Administración',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AdminScaffold()),
            );
          },
        ),
      );
    }

    return settings;
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
