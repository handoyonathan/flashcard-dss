import 'package:flashcard/widget/color.dart';
import 'package:flashcard/widget/text.dart';
import 'package:flutter/material.dart';

// final Color danger = new Color.fromRGBO(255, 80, 97, 1);
final String textFontFamily = 'BricolageGrotesque';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final bool isIcon;
  // final IconData? icon;
  // final bool obscureText;
  final String? errorText;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hintText,
    required this.isIcon,
    // this.icon,
    // this.obscureText = true,
    this.errorText,
  });


  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomSubTitle2(
          text: widget.label,
          textColor: AppColors.text,
        ),
        SizedBox(height: 8),
        TextField(
          autofocus: true,
          controller: widget.controller,
          obscureText: widget.isIcon ? _obscureText : false,
          decoration: InputDecoration(
            errorText: widget.errorText,
            errorStyle: TextStyle(
              color: AppColors.danger,
        fontSize: 16,
        fontFamily: textFontFamily,),
            fillColor: AppColors.white,
            filled: true,
            hintText: widget.hintText,
            hintStyle: TextStyle(color: AppColors.gray, fontSize: 16, fontFamily: textFontFamily),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: widget.errorText != null ? AppColors.danger : AppColors.white,),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color:widget.errorText != null ? AppColors.danger : AppColors.text,),
            ),
            contentPadding:
                EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
            suffixIcon: widget.isIcon ? GestureDetector(
              onTap: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
              child:
                  Image.asset(!_obscureText ? 'asset/Frame.png' : 'asset/Frame-2.png', color: widget.errorText != null ? AppColors.text : null, width: 24, height: 24,)
                  
            ) : null
          ),
        ),
      ],
    );
  }
}
