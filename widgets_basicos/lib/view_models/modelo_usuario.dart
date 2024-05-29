import 'package:flutter/material.dart';
import 'package:widgets_basicos/models/Favoritos.dart';
import 'package:widgets_basicos/models/carga_Datos.dart';
import 'package:widgets_basicos/baseDeDatos/producto_dao.dart';
import 'package:widgets_basicos/baseDeDatos/database_helper.dart';
import 'package:widgets_basicos/baseDeDatos/usuarioModel.dart';
import 'package:widgets_basicos/baseDeDatos/producto_model.dart';

class ModeloUsuario extends ChangeNotifier {
  // Listado de favoritos y carrito
  List<Favorito> favorites = <Favorito>[];
  List<ProductoModel> carrito = <ProductoModel>[]; // Cambio aquí
  final ProductoDao _productoDao = ProductoDao();
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  // Usuario actual
  Usuario? _usuarioActual;

  Usuario? get usuarioActual => _usuarioActual;

  // Verifica si se ha iniciado sesión
  bool get inicioSesion => _usuarioActual != null;

  // Constructor
  ModeloUsuario() {
    _loadFavorites();
    _loadCarrito();
  }

  Future<void> _loadFavorites() async {
    if (_usuarioActual != null) {
      favorites = (await _databaseHelper.getFavoritos(_usuarioActual!.id))
          .map((map) => Favorito.fromMap(map))
          .toList();
    }
    notifyListeners();
  }

  Future<void> _loadCarrito() async {
    if (_usuarioActual != null) {
      carrito = (await _productoDao.readAll(_usuarioActual!.id));
    }
    notifyListeners();
  }

  void modificarBotonInicio(bool valor) {
    notifyListeners();
  }

  Future<void> actualizarGrid() async {
    listadoProductos = [];
    await cargarDatos();
    notifyListeners();
  }

  // Cantidad de favoritos
  int get numFavorites => favorites.length;

  // Método para agregar el favorito
  void addFavorite(Favorito element) async {
    if (_usuarioActual != null && existFavorite(element.nombre) == -1) {
      await _databaseHelper.insertFavorito(_usuarioActual!.id, element.imagen,
          element.nombre, element.precio, element.desc);
      favorites.add(element);
      notifyListeners();
    }
  }

  // Método para borrar el elemento
  void deleteFavorite(int favotiteIndex) async {
    if (_usuarioActual != null) {
      final favorito = favorites[favotiteIndex];

      await _databaseHelper.deleteFav(favorito.id);
      favorites.removeAt(favotiteIndex);
      notifyListeners();
    }
  }

  // Método para verificar si el favorito ya fue agregado
  int existFavorite(String nombreArticulo) {
    for (int i = 0; i < favorites.length; i++) {
      if (favorites[i].nombre == nombreArticulo) {
        // Devuelve la posición
        return i;
      }
    }

    // Si no encuentra el artículo devuelve -1
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

  void upadteScreen() {
    notifyListeners();
  }

  // Registro de usuario
  Future<bool> registrarUsuario(String username, String password, String email,
      String phoneNumber, String birthDate) async {
    bool existe = await _databaseHelper.checkUsuarioExistente(username);
    if (existe) {
      return false;
    } else {
      final usuario = Usuario(
        username: username,
        password: password,
        email: email,
        phoneNumber: phoneNumber,
        birthDate: birthDate,
      );
      await _databaseHelper.insertUsuario(usuario);
      return true;
    }
  }

  // Inicio de sesión de usuario
  Future<bool> iniciarSesion(String username, String password) async {
    final usuario = await _databaseHelper.getUsuario(username, password);
    if (usuario != null) {
      _usuarioActual = usuario;
      await _loadFavorites();
      await _loadCarrito();
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  void cerrarSesion() {
    _usuarioActual = null;
    favorites.clear();
    carrito.clear();
    notifyListeners();
  }

  // Métodos para el carrito
  Future<void> addToCarrito(String name, int cantidad, int price) async {
    if (_usuarioActual != null) {
      await _productoDao.insert(
          ProductoModel(name: name, cantidad: cantidad, price: price),
          _usuarioActual!.id);
      await _loadCarrito();
    }
  }
}
