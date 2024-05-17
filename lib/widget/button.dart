import 'package:flashcard/widget/color.dart';
import 'package:flashcard/widget/text.dart';
import 'package:flutter/material.dart';


class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final ButtonStyle? style;
  final double? width;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.style,
    this.width = double.minPositive
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: CustomSubTitle(text: text, textColor: AppColors.white),
      style: ElevatedButton.styleFrom(
        // Tambahkan gaya di sini
        minimumSize: Size(double.infinity, 0),
        textStyle: TextStyle(fontSize: 18),
        backgroundColor: AppColors.text,
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(8),
        // ),
      ),
    );
  }
}
