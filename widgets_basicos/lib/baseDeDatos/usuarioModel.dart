class Usuario {
  final int id;
  final String username;
  final String password;
  final String email;
  final String phoneNumber;
  final String birthDate; 

  Usuario({
    this.id = 0, // Valor por defecto 0, lo que significa que se autoincrementará con SQLite
    required this.username,
    required this.password,
    required this.email,
    required this.phoneNumber,
    required this.birthDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id != 0 ? id : null,
      'username': username,
      'password': password,
      'email': email,
      'phoneNumber': phoneNumber,
      'birthDate': birthDate,
    };
  }

  static Usuario fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'],
      username: map['username'],
      password: map['password'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      birthDate: map['birthDate'],
    );
  }
}
