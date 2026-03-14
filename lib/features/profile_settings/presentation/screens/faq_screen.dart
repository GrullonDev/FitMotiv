import 'package:flutter/material.dart';
import 'package:fit_motiv/constants/app_text_styles.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final faqs = [
      {
        'question': '¿Cómo puedo cambiar mi plan de entrenamiento?',
        'answer': 'Puedes cambiar tu plan de entrenamiento navegando a la sección "Mis Planes" y seleccionando un nuevo plan que se adapte a tus necesidades.'
      },
      {
        'question': '¿Cómo registro mi progreso diario?',
        'answer': 'En el Dashboard principal, encontrarás una sección para registrar tu peso, consumo de agua y calorías diarias.'
      },
      {
        'question': '¿La aplicación funciona sin conexión?',
        'answer': 'Algunas funciones como ver tus rutinas descargadas funcionan sin conexión, pero para sincronizar tu progreso y chatear con la comunidad necesitas internet.'
      },
      {
        'question': '¿Cómo puedo contactar con soporte técnico?',
        'answer': 'Puedes ir a Configuración > Soporte > Enviar Comentarios para enviarnos un correo electrónico directamente.'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preguntas Frecuentes'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                title: Text(
                  faqs[index]['question']!,
                  style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Text(
                      faqs[index]['answer']!,
                      style: AppTextStyles.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
