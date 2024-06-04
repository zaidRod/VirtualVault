import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widgets_basicos/view_models/modeloUsuario.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final textControllerUsuario = TextEditingController();
  final textControllerPass = TextEditingController();
  final textControllerEmail = TextEditingController();
  final textControllerMobile = TextEditingController();
  final textControllerBirthDate = TextEditingController();

  bool useEmail = true; // Variable para alternar entre correo y móvil
  String errorMessage = ''; // Variable para almacenar mensajes de error

  @override
  Widget build(BuildContext context) {
    return Consumer<ModeloUsuario>(
      builder: (context, modeloUsuario, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: const Text("Registro", style: TextStyle(color: Colors.white)),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
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
                      label: 'Fecha de Nacimiento (dd/mm/aaaa)',
                      icon: Icons.calendar_today,
                    ),
                    if (useEmail)
                      buildTextField(
                        controller: textControllerEmail,
                        label: 'Correo Electrónico',
                        icon: Icons.email,
                      )
                    else
                      buildTextField(
                        controller: textControllerMobile,
                        label: 'Teléfono Móvil',
                        icon: Icons.phone,
                      ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          useEmail = !useEmail;
                        });
                      },
                      child: Text(
                        useEmail ? 'Cambiar al número de teléfono' : 'Cambiar al correo electrónico',
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (isValid()) {
                          bool registrado = await modeloUsuario.registrarUsuario(
                            textControllerUsuario.text,
                            textControllerPass.text,
                            useEmail ? textControllerEmail.text : '',
                            useEmail ? '' : textControllerMobile.text,
                            textControllerBirthDate.text,
                          );
                          if (registrado) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('¡Registro completado!'),
                              ),
                            );
                            Future.delayed(const Duration(seconds: 2), () {
                              Navigator.pop(context);
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Cuenta ya existente'),
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(errorMessage),
                            ),
                          );
                        }
                      },
                      child: const Text('Registrarse'),
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

  bool isValid() {
    bool valid = true;

    // Verificar que todos los campos requeridos están llenos
    if (textControllerUsuario.text.isEmpty ||
        textControllerPass.text.isEmpty ||
        textControllerBirthDate.text.isEmpty ||
        (useEmail && textControllerEmail.text.isEmpty) ||
        (!useEmail && textControllerMobile.text.isEmpty)) {
      errorMessage = 'Por favor, rellene todos los campos.';
      valid = false;
    }

    // Validar fecha de nacimiento
    bool validDate = RegExp(r"^\d{2}/\d{2}/\d{4}$").hasMatch(textControllerBirthDate.text);
    if (validDate) {
      List<String> dateParts = textControllerBirthDate.text.split('/');
      int day = int.parse(dateParts[0]);
      int month = int.parse(dateParts[1]);
      int year = int.parse(dateParts[2]);

      // Verificar que el mes es válido
      if (month < 1 || month > 12) {
        errorMessage = 'Mes no válido. Use un mes entre 01 y 12.';
        valid = false;
      }

      // Verificar que el año no está en el futuro
      if (year > DateTime.now().year) {
        errorMessage = 'Año no válido. Use un año pasado.';
        valid = false;
      }

      // Verificar días según el mes y si es año bisiesto
      if (valid) {
        if (month == 2) {
          bool isLeapYear = (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
          if (day < 1 || day > (isLeapYear ? 29 : 28)) {
            errorMessage = 'Día no válido para febrero. Use un día entre 01 y ${isLeapYear ? 29 : 28}.';
            valid = false;
          }
        } else if ([4, 6, 9, 11].contains(month)) {
          if (day < 1 || day > 30) {
            errorMessage = 'Día no válido. Use un día entre 01 y 30 para este mes.';
            valid = false;
          }
        } else {
          if (day < 1 || day > 31) {
            errorMessage = 'Día no válido. Use un día entre 01 y 31 para este mes.';
            valid = false;
          }
        }
      }
    } else {
      errorMessage = 'Fecha de nacimiento no válida. Use el formato dd/mm/aaaa.';
      valid = false;
    }

    // Validar correo electrónico si se usa
    if (useEmail) {
      bool validEmail = textControllerEmail.text.contains('@');
      if (!validEmail) {
        errorMessage = 'Correo electrónico no válido.';
        valid = false;
      }
    }

    // Validar número de móvil si se usa
    if (!useEmail) {
      bool validMobile = textControllerMobile.text.isNotEmpty && int.tryParse(textControllerMobile.text) != null;
      if (!validMobile) {
        errorMessage = 'Número de teléfono no válido. Use solo números.';
        valid = false;
      }
    }

    return valid;
  }
}
