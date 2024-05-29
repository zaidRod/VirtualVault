import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widgets_basicos/screens/home_pageScreen.dart';
import 'package:widgets_basicos/models/carga_Datos.dart';
import 'baseDeDatos/database_helper.dart';
import 'view_models/modelo_usuario.dart';

void main() async {
  // Asegura la inicialización de widgets
  WidgetsFlutterBinding.ensureInitialized();

  // Elimina la base de datos existente (solo para desarrollo)
  // await DatabaseHelper.instance.deleteDatabase();

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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Temas de la aplicación, texto, colores etc
      theme: ThemeData(
        // Texto de la app
        fontFamily: 'Georgia',
      ),
      // La propiedad home es el inicio de la app, desde allí ya se manejan los demás widget que la componen
      home: HomePage(),
    );
  }
}
