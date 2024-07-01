import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:widgets_basicos/screens/adminScreen.dart';
import 'package:widgets_basicos/screens/carritoScreen.dart';
import 'package:widgets_basicos/screens/favoritesScreen.dart';
import 'package:widgets_basicos/screens/homeScreenGrid.dart';
import 'package:widgets_basicos/screens/settingsScreen.dart';
import 'package:widgets_basicos/screens/loginScreen.dart';
import 'package:widgets_basicos/view_models/modeloUsuario.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Index con el que comienza el bottombar
  int currentIndex = 0;
  String saludo = "Bienvenido ";

  void gotoHome() {
    setState(() {
      currentIndex = 0;
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //Importante para que se compartan los cambios entre los widgets la linea del consumer y
    //builder deben ser exactas.
    return Consumer<ModeloUsuario>(
      builder: (context, modeloUsuario, child) {
        //Verifico si el usuario es administrador y dependiendo retorno el homepage
        final esAdmin = modeloUsuario.esAdmin;
        final sesionInciada = modeloUsuario.inicioSesion;

        return esAdmin
            ? const AdminScaffold()
            : Scaffold(
                //AppBar
                appBar: AppBar(
                  toolbarHeight: 70,
                  elevation: 0,
                  actions: [
                    //Dependiendo si se ha iniciado sesion se muestra un boton u otro.
                    sesionInciada
                        //Si se inicia sesesion se muestra estre drawer con las opciones
                        ? Container(
                            margin: EdgeInsets.only(right: 10),
                            width: 40,
                            height: 40,
                            child: Builder(
                              builder: (context) => InkWell(
                                child: const Icon(Icons.settings),
                                onTap: () {
                                  Scaffold.of(context).openEndDrawer();
                                },
                              ),
                            ),
                          )
                        :
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
                  title: Row(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/images/LogoApp.png"),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        //nombre del usuario a modificar
                        saludo + (modeloUsuario.usuarioActual?.username ?? ''),
                        style: GoogleFonts.playfairDisplay(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ],
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
                endDrawer: Drawer(
                  child: Container(
                    width: 100.0,
                    child: const settingScreen(),
                  ),
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
