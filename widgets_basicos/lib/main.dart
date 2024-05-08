import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widgets_basicos/screens/home_pageScreen.dart';
import 'package:widgets_basicos/models/carga_Datos.dart';
import 'baseDeDatos/database_helper.dart';
import 'view_models/modelo_usuario.dart';

void main() async {
  // Incia la base de datos
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.init();
  runApp(
    //Implemento el notificador de estado
    ChangeNotifierProvider(
      create: (context) => ModeloUsuario(),
      child: const MyApp(),
    ),
  );
  CargarDatos();
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
      //Temas de la aplicacion, texto, colores etc
      theme: ThemeData(
        //Texto de la app
        fontFamily: 'Georgia',
      ),
      //La propiedad home es el inicio de la app, desde alli ya se manejan los demas widget que la componen
      home: HomePage(),
    );
  }
}
