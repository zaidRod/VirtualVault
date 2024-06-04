import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:widgets_basicos/models/favoritesModel.dart';
import 'package:widgets_basicos/models/cargarDatos.dart';
import 'package:widgets_basicos/baseDeDatos/productoDao.dart';
import 'package:widgets_basicos/baseDeDatos/databaseHelper.dart';
import 'package:widgets_basicos/baseDeDatos/usuarioModel.dart';
import 'package:widgets_basicos/baseDeDatos/productoModel.dart';

class ModeloUsuario extends ChangeNotifier {
  // Listado de favoritos y carrito
  List<Favorito> favorites = <Favorito>[];
  List<ProductoModel> carrito = <ProductoModel>[]; 
  final ProductoDao _productoDao = ProductoDao();
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  // Usuario actual
  Usuario? _usuarioActual;

  Usuario? get usuarioActual => _usuarioActual;

  // Verifica si se ha iniciado sesión
  bool get inicioSesion => _usuarioActual != null;

  // Indicador de modo oscuro
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

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

  // Método para verificar si el producto ya está en el carrito
  int existCarrito(String nombreArticulo) {
    for (int i = 0; i < carrito.length; i++) {
      if (carrito[i].name == nombreArticulo) {
        // Devuelve la posición
        return i;
      }
    }
    // Si no encuentra el artículo devuelve -1
    return -1;
  }

  // Método para añadir un elemento del carrito
  void addCarrito(ProductoModel producto) async {
    if (_usuarioActual != null && existCarrito(producto.name) == -1) {
      await dao.insertCarrito(producto, usuarioActual!.id);
      carrito.add(producto);
      notifyListeners();
    }
  }

  void deleteCarrito(int carritoIndex) async {
    if (_usuarioActual != null) {
      carrito.removeAt(carritoIndex);
      notifyListeners();
    }
  }

  String _nombre = "";

  bool _esAdmin = false;
  bool get esAdmin => _esAdmin;

  void loginAdmin(bool esAdmin) {
    _esAdmin = esAdmin;
    notifyListeners();
  }

  String get nombre => _nombre;

  void cambiarNombre(String nombreNuevo) {
    _nombre = nombreNuevo;
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
      // Enviar correo de confirmación
      await _databaseHelper.sendEmail(
        name: username,
        email: email,
        subject: 'Confirmación de registro: Virtual Vault',
        message:
            'Hola $username, \n\n¡Gracias por registrarte en nuestra aplicación! Tu registro fue exitoso.\n\nSaludos,\nEquipo de Soporte',
      );

      return true;
    }
  }

  // Inicio de sesión de usuario
  Future<bool> iniciarSesion(String username, String password) async {
    final usuario = await _databaseHelper.getUsuario(username, password);
    if (usuario != null) {
      _usuarioActual = usuario;
      if (username == 'admin' && password == 'admin') {
        loginAdmin(true);
      } else {
        loginAdmin(false);
      }
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
    _esAdmin = false;
    favorites.clear();
    carrito.clear();
    notifyListeners();
  }

  // Métodos para cambiar entre modo oscuro y claro
  void activarModoOscuro() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void activarModoClaro() {
    _isDarkMode = false;
    notifyListeners();
  }
}

// Metodo que envía el mensaje de WP
void sendWhatsApp(
    {required String phoneNumber, required String message}) async {
  String url = "https://api.whatsapp.com/send?phone=$phoneNumber&text=$message";

  if (await canLaunch(url)) {
    await launch(url);
  } else {
    print("Problema al abrir WhatsApp");
  }
}
