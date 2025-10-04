import 'package:fit_motiv/constants/app_colors.dart';
import 'package:fit_motiv/constants/app_text_styles.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.loadingText,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.borderRadius = 30.0,
    this.elevation = 2.0,
    this.padding = const EdgeInsets.symmetric(vertical: 16),
    this.textStyle,
    this.disabled = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final String? loadingText;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final double borderRadius;
  final double elevation;
  final EdgeInsetsGeometry padding;
  final TextStyle? textStyle;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final isButtonDisabled = disabled || isLoading || onPressed == null;

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isButtonDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          padding: padding,
          backgroundColor: isButtonDisabled ? Colors.grey.shade400 : backgroundColor ?? AppColors.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
          elevation: isButtonDisabled ? 0 : elevation,
        ),
        child: isLoading
            ? _buildLoadingContent()
            : Text(text, style: textStyle ?? AppTextStyles.buttonText.copyWith(color: textColor ?? Colors.white)),
      ),
    );
  }

  Widget _buildLoadingContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(textColor ?? AppColors.background),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          loadingText ?? 'Loading...',
          style: textStyle ?? AppTextStyles.buttonText.copyWith(color: textColor ?? AppColors.background),
        ),
      ],
    );
  }
}
