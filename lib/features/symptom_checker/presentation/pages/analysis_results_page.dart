// lib/features/symptom_checker/presentation/pages/analysis_results_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saludxchiapas_frontend/features/symptom_checker/domain/entities/analysis_result.dart';
import 'package:saludxchiapas_frontend/features/symptom_checker/presentation/providers/symptom_provider.dart';

class AnalysisResultsPage extends ConsumerWidget {
  const AnalysisResultsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final symptomState = ref.watch(symptomProvider);
    final AnalysisResult? result = symptomState.result;

    if (result == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('No se ha encontrado ningún resultado.'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => context.go('/home'),
                child: const Text('Volver al inicio'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados del análisis'),
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildGeneralSymptomsCard(context, result),
              const SizedBox(height: 16),
              _buildRecommendationsCard(context, result),
              const SizedBox(height: 16),
              _buildReportedSymptomsCard(context, result),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        context.pop();
                      },
                      child: const Text('Nuevo Análisis'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        context.go('/home');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[600],
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
  Widget _buildGeneralSymptomsCard(
    BuildContext context,
    AnalysisResult result,
  ) {
    final (urgencyText, urgencyColor) = _getUrgencyInfo(result.nivelUrgencia);

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
                // 9. Usamos el dato de la API
                Expanded(
                  child: Text(
                    result.diagnosticoProbable,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: urgencyColor.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    urgencyText,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: urgencyColor.shade900,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Text(
              'Confianza del análisis: ${result.confianza.toStringAsFixed(0)}%',
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
  Widget _buildRecommendationsCard(
    BuildContext context,
    AnalysisResult result,
  ) {
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
            Text(
              result.recomendacionPublica,
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }

  // Card para Síntomas Reportados
  Widget _buildReportedSymptomsCard(
    BuildContext context,
    AnalysisResult result,
  ) {
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

            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: result.sintomasReportados
                  .map(
                    (sintoma) => Chip(
                      label: Text(sintoma),
                      backgroundColor: Colors.grey[200],
                    ),
                  )
                  .toList(),
            ),

            if (result.textoOriginal.isNotEmpty &&
                !result.sintomasReportados.contains(result.textoOriginal))
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Text(
                  'Texto original: "${result.textoOriginal}"',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey[600],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Helper para mapear el nivel de urgencia a un color y texto
  (String, MaterialColor) _getUrgencyInfo(String nivelUrgencia) {
    switch (nivelUrgencia.toLowerCase()) {
      case 'alto':
      case 'alta':
        return ('Urgencia Alta', Colors.red);
      case 'media':
      case 'medio':
        return ('Urgencia Media', Colors.orange);
      case 'bajo':
      case 'baja':
      default:
        return ('Urgencia Baja', Colors.green);
    }
  }
}
