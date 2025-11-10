// lib/features/symptom_checker/presentation/pages/analysis_results_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AnalysisResultsPage extends StatelessWidget {
  const AnalysisResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados del análisis'),
        automaticallyImplyLeading: false, // No hay botón de "atrás"
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildGeneralSymptomsCard(context),
              const SizedBox(height: 16),
              _buildRecommendationsCard(context),
              const SizedBox(height: 16),
              _buildReportedSymptomsCard(context),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        context.pop();
                      },
                      child: const Text('Nuevo Análisis'),
                      // El estilo primario ya está en el tema
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        context.go('/home');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[600], // Botón secundario
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Volver al inicio'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Card para Síntomas Generales
  Widget _buildGeneralSymptomsCard(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Síntomas generales',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.yellow[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Urgencia Media',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade900,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Presentas síntomas que podría ser Dengue, te recomiendo que acudas a un médico en cuanto puedas.',
              style: TextStyle(fontSize: 16, height: 1.4),
            ),
            const SizedBox(height: 16),
            Text(
              'Confianza del análisis: 75%',
              style: TextStyle(
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Card para Recomendaciones
  Widget _buildRecommendationsCard(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recomendaciones:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            _buildRecommendationItem(
              '1',
              'Visita un centro de salud para evaluación',
            ),
            _buildRecommendationItem('2', 'Mantente hidratado'),
            _buildRecommendationItem('3', 'Evita el contacto con mosquitos'),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationItem(String number, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$number. ',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  // Card para Síntomas Reportados
  Widget _buildReportedSymptomsCard(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tus síntomas reportados:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            Chip(
              label: const Text('Tengo calentura y dolor de cabeza'),
              backgroundColor: Colors.grey[200],
            ),
          ],
        ),
      ),
    );
  }
}
