import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Color(0xFF006A7A);

    return Scaffold(
      appBar: AppBar(
        title: const Text('JuntosXSalud'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Describe tus síntomas en tus propias palabras',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Te ayudamos a una detección temprana con recomendaciones',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 24),

              // Card de Verificador de síntomas
              _buildInfoCard(
                title: 'Verificador de síntomas',
                subtitle:
                    'Cuéntanos cómo te sientes y te daremos orientación sobre qué hacer',
                buttonText: 'COMENZAR',
                buttonColor: primaryColor,
                onPressed: () {
                  context.push('/symptom-checker');
                },
              ),
              const SizedBox(height: 16),

              // Card de Sobre nosotros
              _buildLinkCard(
                title: 'Sobre nosotros',
                linkText: 'Conoce más acerca de Puente Salud',
                onPressed: () {
                  context.push('/about');
                },
              ),
              const SizedBox(height: 16),

              // Card de Hospitales
              _buildLinkCard(
                title: 'Hospitales públicos cercanos',
                linkText: 'Conoce más acerca de Puente Salud',
                onPressed: () {
                  // Navegar a "Hospitales" (Vista faltante)
                },
              ),
              const SizedBox(height: 24),

              // Caja de Advertencia
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.yellow[100],
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(color: Colors.black87, fontSize: 14),
                    children: [
                      TextSpan(
                        text: 'IMPORTANTE: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                            'Esta herramienta es solo orientativa. Si tienes síntomas graves, busca atención médica inmediata.',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.grey[100],
    );
  }

  // Helper para las cards con botón
  Widget _buildInfoCard({
    required String title,
    required String subtitle,
    required String buttonText,
    required Color buttonColor,
    required VoidCallback onPressed,
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
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 15, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(buttonText),
            ),
          ],
        ),
      ),
    );
  }

  // Helper para las cards con link
  Widget _buildLinkCard({
    required String title,
    required String linkText,
    required VoidCallback onPressed,
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
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: onPressed,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
              ),
              child: Text(linkText),
            ),
          ],
        ),
      ),
    );
  }
}
