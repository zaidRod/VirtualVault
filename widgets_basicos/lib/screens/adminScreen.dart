import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:provider/provider.dart";
import "package:widgets_basicos/forms/addForm.dart";
import "package:widgets_basicos/screens/homeScreenGrid.dart";
import "package:widgets_basicos/screens/settingsScreen.dart";
import "package:widgets_basicos/view_models/modelo_usuario.dart";

//Scaffold del administrador
class AdminScaffold extends StatefulWidget {
  const AdminScaffold({
    super.key,
  });

  @override
  State<AdminScaffold> createState() => _AdminScaffoldState();
}

class _AdminScaffoldState extends State<AdminScaffold> {
  // Función que llama al formulario para introducir nuevo artículo
  nuevoArticulo(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
            // Llamada al formulario
            content: InputForm(),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ModeloUsuario>(
      builder: (context, modeloUsuario, child) {
        return Scaffold(
          // AppBar
          appBar: AppBar(
            toolbarHeight: 70,
            elevation: 0,
            actions: [
              // Icono que manda al logIn
              ElevatedButton(
                // Controla que al iniciar la sesión de admin se cambie el botón de salida de sesión.
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                onPressed: () {
                  modeloUsuario.loginAdmin(false);
                  modeloUsuario.modificarBotonInicio(false);
                  modeloUsuario.cambiarNombre("");

                  modeloUsuario
                      .cerrarSesion(); // Asegurarse de cerrar la sesión correctamente
                },
                child: const Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                ),
              ),
            ],
            backgroundColor: Colors.black,
            title: Text(
              // Nombre del usuario a modificar
              "Bienvenido administrador",
              style: GoogleFonts.playfairDisplay(
                  fontSize: 22, fontWeight: FontWeight.bold),
            ),
            foregroundColor: Colors.white,
          ),
          body: const HomeScreenGrid(),

          // Ventana lateral con los ajustes
          endDrawer: Drawer(
            child: settingScreen(), // Utiliza el settingScreen
          ),
          // Botón para agregar nuevos productos
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // Llamada a la función del alertDialog
              nuevoArticulo(context);
            },
            backgroundColor: Colors.lightGreen,
            shape: const CircleBorder(),
            child: const Icon(
              Icons.add,
            ),
          ),
        );
      },
    );
  }
}
