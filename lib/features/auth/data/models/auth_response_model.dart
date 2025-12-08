// lib/features/auth/data/models/auth_response_model.dart

class AuthResponseModel {
  final String message;
  final String token;
  final UserModel user;
  final String expiresIn;

  AuthResponseModel({
    required this.message,
    required this.token,
    required this.user,
    required this.expiresIn,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      message: json['message'] ?? '',
      token: json['token'] ?? '',
      // Si 'user' es nulo, pasamos un mapa vacío para evitar crash,
      // aunque el UserModel manejará los valores por defecto.
      user: UserModel.fromJson(json['user'] ?? {}),
      expiresIn: json['expiresIn'] ?? '',
    );
  }
}

class UserModel {
  final String id;
  final String name;
  final String username;
  final String email;

  // --- NUEVOS CAMPOS ---
  final int age;
  final double weight;
  final String gender;

  UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.age,
    required this.weight,
    required this.gender,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',

      // --- PARSEO SEGURO DE NUEVOS CAMPOS ---

      // Edad: aseguramos que sea int
      age: (json['age'] is int)
          ? json['age']
          : int.tryParse(json['age'].toString()) ?? 0,

      // Peso: aseguramos que sea double (incluso si la API manda int, como 70)
      weight: (json['weight'] is num)
          ? (json['weight'] as num).toDouble()
          : double.tryParse(json['weight'].toString()) ?? 0.0,

      // Género: string simple
      gender: json['gender'] ?? 'other',
    );
  }

  // Método opcional para facilitar el guardado en SharedPreferences
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'age': age,
      'weight': weight,
      'gender': gender,
    };
  }
}
