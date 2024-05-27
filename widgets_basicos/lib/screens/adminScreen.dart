import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:provider/provider.dart";
import "package:widgets_basicos/forms/addForm.dart";
import "package:widgets_basicos/screens/homeScreenGrid.dart";
import "package:widgets_basicos/screens/temporal_loginScreen.dart";
import "package:widgets_basicos/view_models/modelo_usuario.dart";

//Scaffol del administrador
class AdminScaffold extends StatefulWidget {
  const AdminScaffold({
    super.key,
  });

  @override
  State<AdminScaffold> createState() => _AdminScaffoldState();
}

class _AdminScaffoldState extends State<AdminScaffold> {
  //Funcion que llama al formulario para introducir nuevo articulo
  nuevoArticulo(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
            //LLamada al formulario
            content: InputForm(),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ModeloUsuario>(
      builder: (context, ModeloUsuario, child) {
        return Scaffold(
          //AppBar
          appBar: AppBar(
            toolbarHeight: 70,
            elevation: 0,
            actions: [
              //Icono que manda al logIn
              ElevatedButton(

                  //Controlo que al iniciar la sesion de admin se cambie el boton de salida de sesion.
                  onPressed: () {
                    ModeloUsuario.loginAdmin(false);
                    ModeloUsuario.modificarBotonInicio(false);
                    ModeloUsuario.cambiarNombre("");
                  },
                  child: const Icon(Icons.exit_to_app))
            ],
            backgroundColor: Colors.black,
            title: Text(
              //nombre del usuario a modificar
              "Buenas Don administrador",
              style: GoogleFonts.playfairDisplay(
                  fontSize: 22, fontWeight: FontWeight.bold),
            ),
            foregroundColor: Colors.white,
          ),
          body: const HomeScreenGrid(),

          //Ventana lateral del login page
          endDrawer: const Drawer(
            child: LoginPage(),
          ),
          //Boton para agregar nuevos productos
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              //Llamada a la funcion del alertDialog
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
