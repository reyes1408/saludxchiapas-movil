// lib/features/about/presentation/pages/about_us_page.dart
import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(title: const Text('Sobre nosotros')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Puente salud Chiapas',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Conectando con la salud a través de la tecnología',
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 24),
              _buildInfoCard(
                context,
                title: 'Misión',
                content:
                    'Facilitar el acceso a la atención médica en comunidades rurales de Chiapas mediante una plataforma digital que comprende el lenguaje local y proporciona orientación de salud oportuna y accesible.',
              ),
              const SizedBox(height: 16),
              _buildInfoCard(
                context,
                title: 'Enfoque Inicial',
                content:
                    'Comenzamos enfocándonos en el dengue como prueba de concepto. Una vez validado el sistema, expandiremos a otras enfermedades endémicas como zika y chikungunya, mejorando continuamente.',
              ),
              const SizedBox(height: 16),
              _buildInfoCard(
                context,
                title: 'Política de privacidad',
                contentWidget: Text(
                  'Leer política de privacidad',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue.shade700,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper para crear las tarjetas de información
  Widget _buildInfoCard(
    BuildContext context, {
    required String title,
    String? content,
    Widget? contentWidget,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 12),
            contentWidget ??
                Text(
                  content ?? '',
                  style: const TextStyle(fontSize: 16, height: 1.4),
                ),
          ],
        ),
      ),
    );
  }
}
