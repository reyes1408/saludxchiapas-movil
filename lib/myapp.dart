// lib/myapp.dart
import 'package:flutter/material.dart';
import 'package:saludxchiapas_frontend/core/router/app_router.dart'; // Importa tu router

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Definimos el color primario de tu app
    final Color primaryColor = Color(0xFF006A7A);

    return MaterialApp.router(
      // Configuración de GoRouter
      routerConfig: appRouter,

      title: 'SaludXChiapas',
      debugShowCheckedModeBanner: false,

      // Tema global de la aplicación
      theme: ThemeData(
        primaryColor: primaryColor,
        scaffoldBackgroundColor: Colors.grey[100],
        useMaterial3: true,

        // Tema para la AppBar
        appBarTheme: AppBarTheme(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white, // Color del texto y los iconos
          elevation: 1,
        ),

        // Tema para los botones elevados
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // Tema para los campos de texto
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
