import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widgets_basicos/models/carga_Datos.dart';
import 'package:widgets_basicos/widgets/carrousel.dart';

import '../view_models/modelo_usuario.dart';

class HomeScreenGrid extends StatefulWidget {
  //Variable que determina si se muestran los botones de modificacion y borrado producto.
  const HomeScreenGrid({
    super.key,
  });

  @override
  State<HomeScreenGrid> createState() => _HomeScreenGridState();
}

class _HomeScreenGridState extends State<HomeScreenGrid> {
  //Controlador para manejar los botones  del slider
  final controller = CarouselController();
  int activeIndex = 0;
  List<String> heroImages = [
    "assets/images/Carrusel1.jpg",
    "assets/images/Carrusel2.jpg"
  ];
  @override
  Widget build(BuildContext context) {
    return Consumer<ModeloUsuario>(
      builder: (context, ModeloUsuario, child) {
        final bool esAdmin = ModeloUsuario.esAdmin;
        return SingleChildScrollView(
          child: Column(
            children: [
              const MiCarrusel(),
              listadoProductos.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 150,
                            ),
                            Text(
                              "No tienes productos 👀, ¡Agrega algunos! 😊 ",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(12),
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        //Selecciona la cantidad de productos que mostrara el grid
                        itemCount: listadoProductos.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 13,
                          crossAxisSpacing: 13,
                          //Extiende el largo de los elementos del grid dependiendo si es admin o no
                          mainAxisExtent: esAdmin ? 250 : 200,
                        ),
                        itemBuilder: (context, index) {
                          return listadoProductos[index];
                        },
                      ),
                    )
            ],
          ),
        );
      },
    );
  }
}
