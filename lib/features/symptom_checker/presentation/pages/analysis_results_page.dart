import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saludxchiapas_frontend/features/symptom_checker/domain/entities/analysis_result.dart';
import 'package:saludxchiapas_frontend/features/symptom_checker/presentation/providers/symptom_provider.dart';
import 'package:saludxchiapas_frontend/features/hospitals/presentation/providers/hospitals_provider.dart';
import 'package:saludxchiapas_frontend/features/hospitals/data/models/hospital_model.dart';

class AnalysisResultsPage extends ConsumerStatefulWidget {
  const AnalysisResultsPage({super.key});

  @override
  ConsumerState<AnalysisResultsPage> createState() =>
      _AnalysisResultsPageState();
}

class _AnalysisResultsPageState extends ConsumerState<AnalysisResultsPage> {
  @override
  void initState() {
    super.initState();
    final municipio = ref.read(symptomProvider).lastMunicipio;

    if (municipio != null) {
      Future.microtask(() {
        ref.read(hospitalsProvider.notifier).searchHospitals(municipio);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final symptomState = ref.watch(symptomProvider);
    final hospitalsState = ref.watch(hospitalsProvider);

    final AnalysisResult? result = symptomState.result;

    if (result == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: ElevatedButton(
            onPressed: () => context.go('/home'),
            child: const Text('Volver al inicio'),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados del análisis'),
        automaticallyImplyLeading: false,
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

              const Divider(height: 40, thickness: 2),

              Text(
                'Atención médica en ${symptomState.lastMunicipio ?? "tu zona"}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 8),

              if (hospitalsState.isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (hospitalsState.hospitals.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "No encontramos hospitales públicos registrados en este municipio.",
                  ),
                )
              else
                _buildMiniHospitalList(hospitalsState.hospitals),

              // ----------------------------------------
              const SizedBox(height: 32),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => context.pop(),
                      child: const Text('Nuevo Análisis'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => context.go('/home'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[600],
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Ir al Inicio'),
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

  Widget _buildMiniHospitalList(List<HospitalModel> hospitals) {
    final topHospitals = hospitals.take(3).toList();

    return Column(
      children: topHospitals.map((hospital) {
        return Card(
          elevation: 1,
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Icon(Icons.local_hospital, color: Colors.red[400]),
            title: Text(
              hospital.nombre,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(hospital.direccion),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
        );
      }).toList(),
    );
  }

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
              children: [
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
            const SizedBox(height: 8),
            Text(
              'Confianza: ${result.confianza.toStringAsFixed(0)}%',
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
            const SizedBox(height: 8),
            Text(
              result.recomendacionPublica,
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }

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
            const Text(
              'Síntomas detectados:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              children: result.sintomasReportados
                  .map(
                    (s) =>
                        Chip(label: Text(s), backgroundColor: Colors.grey[200]),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  (String, MaterialColor) _getUrgencyInfo(String nivelUrgencia) {
    switch (nivelUrgencia.toLowerCase()) {
      case 'alto':
      case 'alta':
        return ('Urgencia Alta', Colors.red);
      case 'media':
      case 'medio':
        return ('Urgencia Media', Colors.orange);
      default:
        return ('Urgencia Baja', Colors.green);
    }
  }
}
