import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widgets_basicos/screens/homePageScreen.dart';
import 'package:widgets_basicos/models/cargarDatos.dart';
import 'package:widgets_basicos/baseDeDatos/databaseHelper.dart';
import 'package:widgets_basicos/view_models/modeloUsuario.dart';

void main() async {
  // Asegura la inicialización de widgets
  WidgetsFlutterBinding.ensureInitialized();

  // Elimina la base de datos existente (solo para desarrollo)
  //await DatabaseHelper.instance.deleteDatabase();

  // Inicializa la base de datos
  await DatabaseHelper.instance.init();

  // Carga los datos iniciales (si es necesario)
  await cargarDatos();

  // Inicia la aplicación
  runApp(
    // Implementa el notificador de estado
    ChangeNotifierProvider(
      create: (context) => ModeloUsuario(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ModeloUsuario>(
      builder: (context, modeloUsuario, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          // Temas de la aplicación, texto, colores etc
          theme: ThemeData(
            //Tema claro

            // Modo oscuro o claro según el estado
            brightness:
                modeloUsuario.isDarkMode ? Brightness.dark : Brightness.light,
          ),
          // La propiedad home es el inicio de la app, desde allí ya se manejan los demás widget que la componen
          home: HomePage(),
        );
      },
    );
  }
}
