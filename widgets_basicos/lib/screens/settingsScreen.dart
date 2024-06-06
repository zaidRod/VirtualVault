import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widgets_basicos/models/cargarDatos.dart';
import 'package:widgets_basicos/screens/carritoScreen.dart';
import 'package:widgets_basicos/screens/favoritesScreen.dart';
import 'package:widgets_basicos/screens/pedidosScreen.dart';
import 'package:widgets_basicos/screens/adminScreen.dart';
import 'package:widgets_basicos/view_models/modeloUsuario.dart';

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
      ListTile(
        leading: Icon(Icons.favorite),
        title: Text('Favoritos'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ListadoFavoritos()),
          );
        },
      ),
      ListTile(
        leading: Icon(Icons.shopping_cart),
        title: Text('Carrito'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CarritoPage(),
            ),
          );
        },
      ),
      ListTile(
        leading: Icon(Icons.dark_mode),
        title: Text(modeloUsuario.isDarkMode ? 'Modo Claro' : 'Modo Oscuro'),
        onTap: () {
          modeloUsuario.toggleDarkMode();
        },
      ),
      ListTile(
        leading: Icon(Icons.help),
        title: Text("Ayuda: Contacto"),
        onTap: () async {
          //Variable que almacena el Id del usuario
          final usuarioId = Provider.of<ModeloUsuario>(context, listen: false)
              .usuarioActual!
              .id;
          String correoUsuario = await dao.mostrarCorreo(usuarioId);
          String nombreUsuario = await dao.mostrarNombreUsuario(usuarioId);
          //-----Creación del string para whatsapp ---//
          String whatsappMessage =
              "🚐 Solicitud de contacto por el usuario: $nombreUsuario. \n📨 Correo de contacto $correoUsuario\n 🧐 Indique el motivo de su consulta: ";

          sendWhatsApp(phoneNumber: "34642054838", message: whatsappMessage);
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
          modeloUsuario.activarModoClaro();
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
