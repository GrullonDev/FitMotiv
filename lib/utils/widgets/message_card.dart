import 'package:flutter/material.dart';

class MessageCard extends StatelessWidget {
  const MessageCard({
    super.key,
    required this.message,
    required this.isError,
    this.margin = const EdgeInsets.only(bottom: 16),
  });

  final String message;
  final bool isError;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    final color = isError ? Colors.red : Colors.green;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: margin,
      decoration: BoxDecoration(
        color: color.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.shade200),
      ),
      child: Row(
        children: [
          Icon(isError ? Icons.error_outline : Icons.check_circle_outline, color: color.shade700, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(message, style: TextStyle(color: color.shade700, fontSize: 14)),
          ),
        ],
      ),
    );
  }
}
