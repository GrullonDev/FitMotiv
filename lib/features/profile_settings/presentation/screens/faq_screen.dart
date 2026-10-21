import 'package:flutter/material.dart';
import 'package:fit_motiv/constants/app_text_styles.dart';
import 'package:fit_motiv/l10n/app_localizations.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final faqs = [
      {
        'question': l10n.faqChangeTrainingPlan,
        'answer': l10n.faqChangeTrainingPlanAnswer,
      },
      {
        'question': l10n.faqRegisterProgress,
        'answer': l10n.faqRegisterProgressAnswer,
      },
      {
        'question': l10n.faqOffline,
        'answer': l10n.faqOfflineAnswer,
      },
      {
        'question': l10n.faqContactSupport,
        'answer': l10n.faqContactSupportAnswer,
      },
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.faq)),
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
              data: Theme.of(
                context,
              ).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                title: Text(
                  faqs[index]['question']!,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
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
