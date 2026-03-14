import 'package:fit_motiv/constants/app_text_styles.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              Column(
                children: [
                  Text('Welcome to FitMotiv!', style: AppTextStyles.heading1, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  Text(
                    'Your journey to a healthier, happier you starts here. Get personalized plans, track your progress, and join our supportive community.',
                    style: AppTextStyles.bodyMedium.copyWith(height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: Text('Get Started', style: AppTextStyles.buttonText),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
