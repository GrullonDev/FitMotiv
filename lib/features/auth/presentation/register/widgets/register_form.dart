import 'package:fit_motiv/features/auth/presentation/register/bloc/register_bloc.dart';
import 'package:fit_motiv/utils/widgets/user_input.dart';
import 'package:flutter/material.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key, required this.bloc});

  final RegisterBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Nombre completo
        UserInput(hint: 'Enter your full name', controller: bloc.fullNameController),
        const SizedBox(height: 16),

        // Nombre de usuario
        UserInput(hint: 'Enter your username', controller: bloc.usernameController),
        const SizedBox(height: 16),

        // Email
        UserInput(hint: 'Enter your email', controller: bloc.emailController),
        const SizedBox(height: 16),

        // Contraseña
        UserInput(hint: 'Enter your password', controller: bloc.passwordController, obscureText: true),
        const SizedBox(height: 16),

        // Confirmar contraseña
        UserInput(hint: 'Confirm your password', controller: bloc.confirmPasswordController, obscureText: true),
        const SizedBox(height: 16),

        // Biografía (opcional)
        UserInput(hint: 'Tell us about yourself (optional)', controller: bloc.bioController),
        const SizedBox(height: 16),

        // Row para campos numéricos
        Row(
          children: [
            Expanded(
              child: UserInput(hint: 'Age', controller: bloc.ageController),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: UserInput(hint: 'Height (cm)', controller: bloc.heightController),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: UserInput(hint: 'Weight (kg)', controller: bloc.weightController),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Objetivo de fitness
        _buildDropdownField(
          label: 'Fitness Goal',
          value: bloc.fitnessGoal.isEmpty ? null : bloc.fitnessGoal,
          items: const ['Weight Loss', 'Muscle Gain', 'Maintain Weight', 'General Fitness', 'Athletic Performance'],
          onChanged: (value) => bloc.setFitnessGoal(value ?? ''),
        ),
        const SizedBox(height: 16),

        // Nivel de actividad
        _buildDropdownField(
          label: 'Activity Level',
          value: bloc.activityLevel.isEmpty ? null : bloc.activityLevel,
          items: const ['Sedentary', 'Lightly Active', 'Moderately Active', 'Very Active', 'Extremely Active'],
          onChanged: (value) => bloc.setActivityLevel(value ?? ''),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(color: const Color(0xFFE8F5F1), borderRadius: BorderRadius.circular(12)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 16)),
          isExpanded: true,
          items: items.map((String item) {
            return DropdownMenuItem<String>(value: item, child: Text(item));
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
