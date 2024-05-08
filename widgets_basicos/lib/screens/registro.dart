import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widgets_basicos/view_models/modelo_usuario.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final textControllerUsuario = TextEditingController();
  final textControllerPass = TextEditingController();
  final textControllerBirthDate = TextEditingController();
  final textControllerEmail = TextEditingController();
  final textControllerMobile = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<ModeloUsuario>(
      builder: (context, modeloUsuario, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            title:
                const Text("Registro", style: TextStyle(color: Colors.white)),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: SingleChildScrollView(
            // Asegura que el teclado no cubra los campos de texto
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(
                    20), // Espacio uniforme alrededor del contenido
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildTextField(
                      controller: textControllerUsuario,
                      label: 'Nombre de usuario',
                      icon: Icons.person,
                    ),
                    buildTextField(
                      controller: textControllerPass,
                      label: 'Contraseña',
                      icon: Icons.lock,
                      isPassword: true,
                    ),
                    buildTextField(
                      controller: textControllerBirthDate,
                      label: 'Fecha de Nacimiento',
                      icon: Icons.calendar_today,
                    ),
                    buildTextField(
                      controller: textControllerEmail,
                      label: 'Correo Electrónico',
                      icon: Icons.email,
                    ),
                    buildTextField(
                      controller: textControllerMobile,
                      label: 'Teléfono Móvil',
                      icon: Icons.phone,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Implementar funcionalidad de registro
                      },
                      child: Text('Registrarse'),
                    ),
                  ],
                ),
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
}
