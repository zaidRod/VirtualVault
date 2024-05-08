import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MiCarrusel extends StatefulWidget {
  const MiCarrusel({super.key});

  @override
  State<MiCarrusel> createState() => _MiCarruselState();
}

class _MiCarruselState extends State<MiCarrusel> {
  final controller = CarouselController();
  int activeIndex = 0;
  List<String> heroImages = [
    "assets/images/Carrusel1.jpg",
    "assets/images/Carrusel2.jpg"
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            //Definicion del carrusel
            CarouselSlider.builder(
              //Listado de elemnetos del carrusel
              itemCount: 2,

              carouselController: controller,
              options: CarouselOptions(
                autoPlay: true,
                initialPage: 0,
                height: 205,
                viewportFraction: 1,
                onPageChanged: (index, reason) =>
                    setState(() => activeIndex = index),
              ),
              itemBuilder: (context, index, realIndex) {
                return Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(heroImages[index]),
                      //Ajusta la imagen al espacio
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 12),
                        child: Text(
                          "Get ur \n new game\n now",
                          style: GoogleFonts.playfairDisplay(
                              backgroundColor: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            //Positioned(child: child)
          ],
        ),
        SizedBox(height: 5),
        buildIndicator(),
      ],
    );
  }

  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: 2,
        effect: const JumpingDotEffect(dotWidth: 15, dotHeight: 15),
        onDotClicked: animateToSlide,
      );

//Metodo que cambia el slider segun el dot que se toque
  void animateToSlide(int index) => controller.jumpToPage(index);
}
