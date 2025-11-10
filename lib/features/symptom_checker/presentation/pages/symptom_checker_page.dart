// lib/features/symptom_checker/presentation/pages/symptom_checker_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saludxchiapas_frontend/features/symptom_checker/presentation/providers/symptom_provider.dart';

class SymptomCheckerPage extends ConsumerStatefulWidget {
  const SymptomCheckerPage({super.key});

  @override
  ConsumerState<SymptomCheckerPage> createState() => _SymptomCheckerPageState();
}

class _SymptomCheckerPageState extends ConsumerState<SymptomCheckerPage> {
  String? _selectedMunicipio;
  final TextEditingController _symptomsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    final symptomState = ref.watch(symptomProvider);
    final symptomNotifier = ref.read(symptomProvider.notifier);

    ref.listen(symptomProvider, (previous, next) {
      if (next.result != null) {
        context.go('/symptom-checker/results');
      }
      if (next.errorMessage != null) {
        // ¡Error! Muestra un SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Verificador de síntomas')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '¿Cómo te sientes?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Describe tus síntomas con tus propias palabras. No te preocupes por usar términos médicos, puedes expresarte como normalmente lo haces.',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 24),
              const Text(
                'Tus síntomas',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _symptomsController,
                decoration: const InputDecoration(
                  hintText: 'Ej. Tengo fiebre y dolor de cabeza...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                minLines: 3,
              ),
              const SizedBox(height: 16),
              const Text('Ejemplos de cómo puedes describir:'),
              _buildExampleLink('Tengo calentura y dolor de cabeza'),
              _buildExampleLink('Tengo salpullido en la piel'),
              const SizedBox(height: 24),
              const Text(
                'Selecciona en qué municipio te encuentras:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedMunicipio,
                hint: const Text('Seleccionar'),
                items:
                    [
                      // Estados.
                      'Tuxtla Gutiérrez',
                      'Chiapa de Corzo',
                      'San Cristóbal de Las Casas',
                      'Comitán de Domínguez',
                      'Tapachula',
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedMunicipio = newValue;
                  });
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed:
                    symptomState
                        .isLoading // Deshabilita si está cargando
                    ? null
                    : () {
                        // Valida que el texto no esté vacío
                        if (_symptomsController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Por favor, describe tus síntomas'),
                            ),
                          );
                          return;
                        }
                        // Llama al provider
                        symptomNotifier.analyzeSymptoms(
                          _symptomsController.text,
                        );
                      },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: symptomState.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Analizar síntomas'),
              ),
              const SizedBox(height: 24),
              _buildWarningBox(),
            ],
          ),
        ),
      ),
    );
  }

  // Helper para los links de ejemplo
  Widget _buildExampleLink(String text) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        alignment: Alignment.centerLeft,
      ),
      onPressed: () {
        _symptomsController.text = text;
      },
      child: Text(
        text,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  // Helper para la caja de aviso
  Widget _buildWarningBox() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: RichText(
        text: const TextSpan(
          style: TextStyle(color: Colors.black87, fontSize: 14),
          children: [
            TextSpan(
              text: 'AVISO: ',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
            ),
            TextSpan(
              text:
                  'Si tienes dificultad para respirar, dolor en el pecho, confusión o sangrado severo, busca atención médica de emergencia inmediatamente.',
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _symptomsController.dispose();
    super.dispose();
  }
}
