import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:widgets_basicos/baseDeDatos/producto_dao.dart';
import 'package:widgets_basicos/models/productsModel.dart';
import 'package:widgets_basicos/view_models/modelo_usuario.dart';
import 'package:path_provider/path_provider.dart';

class InputForm extends StatefulWidget {
  const InputForm({super.key});
  @override
  State<InputForm> createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  File? imagen;
  String nombreProducto = "";
  int precio = 0;
  String descripcion = "";
  String imagePath = "";

  File addImageIcon = File(
      "/data/user/0/com.example.widgets_basicos/app_flutter/flutter_assets/agregarImagen.png");
//Llave que se usa para guardar los valors del formulario
  final formKey = GlobalKey<FormState>();
  //Objeto file picker que almacena el fichero seleccionado de camara o galeria
  final picker = ImagePicker();

  //Funcion que guarda la imagen el la carpeta de assets del dispositivo
  Future<String> saveImageToDisk(XFile imageFile) async {
    final appDir = await getApplicationDocumentsDirectory();
    //  la fecha y hora actual
    final now = DateTime.now();
    // Formatea la fecha y hora como una cadena
    final formattedDate =
        '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}';
    // Define el nombre del archivo usando la fecha y hora
    final fileName = 'foto_$formattedDate.png';
    final filePath = '${appDir.path}/flutter_assets/$fileName';
    await imageFile.saveTo('${filePath}');
    return filePath;
  }

  //Funcion para cargar las imagenes
  Future selImagen(op) async {
    XFile? pickedFile;
    //Se selecciono camara
    if (op == 1) {
      pickedFile = await picker.pickImage(source: ImageSource.camera);
    } else {
      //Se selecciono galeria
      pickedFile = await picker.pickImage(source: ImageSource.gallery);
    }

    imagePath = await saveImageToDisk(pickedFile!); // Uso de saveImageToDisk
    //Se actualiza el estado del form para mostrar la imagen seleccionada
    setState(
      () {
        if (pickedFile != null) {
          //Actualiza el valor de la variable imagen
          imagen = File(imagePath);
        } else {
          print("No seleccionaste la foto");
        }
      },
    );

    //Cierra la ventana de seleccionar camara o galeria
    Navigator.of(context).pop();
  }

  //Intancia de la base de datos
  final dao = ProductoDao();

  //Funcion para agregar la imagen
  agregarImagen(context) {
    //Abre el cuaadro de dialogo para escoger entre camara y galeria
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(0),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //Boton de tomar foto
                InkWell(
                  onTap: () {
                    selImagen(1);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          size: 40,
                          Icons.camera_alt,
                          color: Colors.blue,
                        ),
                        Text("Tomar foto")
                      ],
                    ),
                  ),
                ),
                //Boton abrir galeria
                InkWell(
                  onTap: () {
                    selImagen(2);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 1, color: Colors.grey),
                      ),
                    ),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          size: 40,
                          Icons.image,
                          color: Colors.red,
                        ),
                        Text("Galeria")
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ModeloUsuario>(
      builder: (context, ModeloUsuario, child) {
        return Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    //Llamada a la funcion de la camara
                    agregarImagen(context);
                  },
                  //Container que muestra la imagen
                  child: Container(
                    height: 100,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: //Siempre que el valor de la imagen no sea nullo la muestra
                        Center(
                      child: imagen == null
                          ? Image.file(addImageIcon)
                          : Image.file(imagen!),
                    ),
                  ),
                ),
                //Formulario con sus campos respectivos
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: "Nombre del producto"),
                  onSaved: (value) {
                    nombreProducto = value!;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Debes llenar los campos";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Precio"),
                  onSaved: (value) {
                    //Verificar que el campo no este vacio y por ende se pueda parsear
                    if (value != null && value.isNotEmpty) {
                      precio = int.parse(value);
                    }
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Debes llenar los campos";
                    } else if (int.tryParse(value) == null) {
                      return "Debe ser valor númerico";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Descripcion"),
                  onSaved: (value) {
                    descripcion = value!;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Debes llenar los campos";
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                    onPressed: () {
                      if (imagePath == "") {
                        imagePath =
                            "/data/user/0/com.example.widgets_basicos/app_flutter/flutter_assets/agregarImagen.png";
                      }

                      //Antes de guardar los campos valida si estan llenos
                      if (formKey.currentState!.validate()) {
                        //Guarda los cambios en una KeyGlobal
                        formKey.currentState!.save();
                        //Realiza el insert del producto a la base de datos
                        dao.insertProduct(
                          Product(
                              name: nombreProducto,
                              price: precio,
                              desc: descripcion,
                              image: imagePath),
                        );
                        //Actualiza el listado de productos luego de la insercion.
                        ModeloUsuario.actualizarGrid();
                        //Cierra la ventana
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Icon(Icons.send))
              ],
            ),
          ),
        );
      },
    );
  }
}
