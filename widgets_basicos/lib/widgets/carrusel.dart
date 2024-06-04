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
    "assets/images/cover.Pac-man.jpg",
    "assets/images/banner.Resident-evil-0.jpg",
    "assets/images/cover.Halo-4.jpg",
    "assets/images/banner.Mortal-kombat-x.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Stack(
            children: [
              //Definición del carrusel
              CarouselSlider.builder(
                //Listado de elementos del carrusel
                itemCount: 4,
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
                      borderRadius: BorderRadius.circular(30),
                      image: DecorationImage(
                        image: AssetImage(heroImages[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.black.withOpacity(0.2),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Get ur \n new game\n now",
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  blurRadius: 10.0,
                                  color: Colors.black,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 5),
          buildIndicator(),
        ],
      ),
    );
  }

  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: 4,
        effect: const JumpingDotEffect(dotWidth: 15, dotHeight: 15),
        onDotClicked: animateToSlide,
      );

  //Método que cambia el slider según el dot que se toque
  void animateToSlide(int index) => controller.jumpToPage(index);
}
