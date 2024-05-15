import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widgets_basicos/screens/registro.dart';

import '../view_models/modelo_usuario.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Guardan el contenido del textField
  final textControlerUsuario = TextEditingController();
  final textControlerPass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //Es importante que los demas widgets tengan el mismo consumer y contexto para poder
    //usar los datos del modelo.
    return Consumer<ModeloUsuario>(
      builder: (context, modeloUsuario, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: const Text("Iniciar sesión",
                style: TextStyle(color: Colors.white)),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildTextField(
                    controller: textControlerUsuario,
                    label: 'Nombre de usuario',
                    icon: Icons.person,
                  ),
                  buildTextField(
                    controller: textControlerPass,
                    label: 'Contraseña',
                    icon: Icons.lock,
                    isPassword: true,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    //Modificaion del incio de sesion.
                    onPressed: () {
                      if (textControlerUsuario.text == "admin") {
                        modeloUsuario.loginAdmin(true);
                      }
                      //Cambio el valor de la variable para mostrar un home
                      modeloUsuario.cambiarNombre(textControlerUsuario.text);
                      modeloUsuario.modificarBotonInicio(true);

                      Navigator.pop(context);
                    },
                    child: const Text('Iniciar sesión'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("¿No tienes una cuenta? "),
                        TextButton(
                          onPressed: () => _navigateToRegisterPage(context),
                          child: const Text('Registrarse'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          fillColor: Colors.grey.shade200,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
        cursorColor: Theme.of(context).primaryColor,
      ),
    );
  }

  void _navigateToRegisterPage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => RegisterPage()));
  }
}
