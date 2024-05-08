import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:widgets_basicos/screens/adminScreen.dart';
import 'package:widgets_basicos/screens/carritoScreen.dart';
import 'package:widgets_basicos/screens/favoritesScreen.dart';
import 'package:widgets_basicos/screens/homeScreenGrid.dart';
import 'package:widgets_basicos/screens/temporal_loginScreen.dart';

import '../view_models/modelo_usuario.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Index con el que comienza el bottombar
  int currentIndex = 0;
  String saludo = "Bienvenido ";

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //Importante para que se compartan los cambios entre los widgets la linea del consumer y
    //builder deben ser exactas.
    return Consumer<ModeloUsuario>(
      builder: (context, ModeloUsuario, child) {
        //Verifico si el usuario es administrador y dependiendo retorno el homepage
        final esAdmin = ModeloUsuario.esAdmin;
        return esAdmin
            ? const AdminScaffold()
            : Scaffold(
                //AppBar
                appBar: AppBar(
                  toolbarHeight: 70,
                  elevation: 0,
                  actions: [
                    //Icono que manda al logIn
                    Container(
                      margin: const EdgeInsets.only(right: 12),
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                      child: Builder(
                        builder: (context) => InkWell(
                          child: const Icon(Icons.person),
                          // Boton de login
                          onTap: () => _showLoginForm(context),
                        ),
                      ),
                    )
                  ],
                  backgroundColor: Colors.black,
                  title: Text(
                    //nombre del usuario a modificar
                    saludo + ModeloUsuario.nombre,
                    style: GoogleFonts.playfairDisplay(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  foregroundColor: Colors.white,
                ),
                body: [
                  //Listado de paginas que se mostraran en el centro de al app, es un array
                  //que cambia segun el index del bottombar
                  const HomeScreenGrid(),
                  const ListadoFavoritos(),
                  const CarritoPage(),
                  //Pantalla de favoritos
                ][currentIndex],
                //Navigation bar
                bottomNavigationBar: NavigationBar(
                  destinations: const [
                    NavigationDestination(
                        icon: Icon(Icons.home), label: "Inicio"),
                    NavigationDestination(
                      icon: Icon(Icons.favorite),
                      label: "Favoritos",
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.shopping_cart),
                      label: "Carrito",
                    ),
                  ],
                  selectedIndex: currentIndex,
                  indicatorColor: Colors.grey[400],
                  onDestinationSelected: (value) {
                    //Hace el cambio del contenido, modificando el estado.
                    setState(() {
                      currentIndex = value;
                    });
                  },
                ),
                //Ventana lateral del login page
                endDrawer: const Drawer(
                  child: LoginPage(),
                ),
              );
      },
    );
  }

  // Metodo que llama al login page
  void _showLoginForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return LoginPage();
      },
      isScrollControlled: true,
    );
  }
}
