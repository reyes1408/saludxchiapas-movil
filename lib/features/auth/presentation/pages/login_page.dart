// lib/features/auth/presentation/pages/login_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Definimos un color primario que se parece al de la imagen
    final Color primaryColor = Color(0xFF006A7A); // Un tono de verde azulado

    return Scaffold(
      appBar: AppBar(
        title: Text('JuntosXSalud'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white, // Texto en blanco
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              Text(
                '¡BIENVENIDO!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Ingresa tus datos correctamente para iniciar sesión',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 40),
              // Campo de Usuario
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Usuario / Correo',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              // Campo de Contraseña
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 32),
              // Botón de Iniciar Sesión
              ElevatedButton(
                onPressed: () {
                  context.go('/home');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      30,
                    ), // Bordes redondeados
                  ),
                ),
                child: const Text(
                  'Iniciar sesión',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 32),
              // Link de Registro
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('¿No tienes una cuenta? '),
                  TextButton(
                    onPressed: () {
                      context.go('/register');
                    },
                    child: Text(
                      'Regístrate',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.grey[100], // Un fondo ligeramente gris
    );
  }
}
