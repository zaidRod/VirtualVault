import 'package:flutter/material.dart';
import 'package:widgets_basicos/models/Favoritos.dart';

class ModeloUsuario extends ChangeNotifier {
  //Listado de favoritos
  List<Favorito> favorites = <Favorito>[];

  //Cantidad de favoritos
  int get numFavorites => favorites.length;

  //Metodo para agregar el favorito
  void addFavorite(Favorito element) {
    favorites.add(element);
    notifyListeners();
  }

  //Metodo para borrar el elemento

  void deleteFavorite(int favotiteIndex) {
    favorites.removeAt(favotiteIndex);
    notifyListeners();
  }

  //Metodo para verificar si el favorito ya fue agregado
  int existFavorite(String nombreArticulo) {
    for (int i = 0; i < favorites.length; i++) {
      if (favorites[i].nombre == nombreArticulo) {
        //Devuelve la posicion
        return i;
      }
    }

    // Si no encuentra el articulo devuelve - 1
    return -1;
  }

  String _nombre = "";

  bool esAdmin = false;

  String get nombre => _nombre;

  void cambiarNombre(String nombreNuevo) {
    _nombre = nombreNuevo;
    notifyListeners();
  }

  void loginAdmin(bool esAdminis) {
    esAdmin = esAdminis;
    notifyListeners();
  }
}
