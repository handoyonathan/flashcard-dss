import 'package:flutter/material.dart';

const String textFontFamily = 'BricolageGrotesque';

class CustomBigTitle extends StatelessWidget {
  final Color textColor;
  final String text;
  final String? align;

  const CustomBigTitle({super.key, required this.text, required this.textColor, this.align});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align != null ? TextAlign.center : null,
      maxLines: 2,
      style: TextStyle(
        color: textColor,
        fontWeight: FontWeight.bold,
        fontSize: 32,
        fontFamily: textFontFamily,
      ),
    );
  }
}


class CustomTitle extends StatelessWidget {
  final Color textColor;
  final String text;
  final String? align;

  const CustomTitle({super.key, required this.text, required this.textColor, this.align});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align == null ? TextAlign.center : null,
      style: TextStyle(
        color: textColor,
        fontWeight: FontWeight.bold,
        fontSize: 24,
        fontFamily: textFontFamily,
        
      ),
    );
  }
}

class CustomSubTitle extends StatelessWidget {
  final Color textColor;
  final String text;

  const CustomSubTitle({super.key, required this.text, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: textColor,
        fontWeight: FontWeight.bold,
        fontSize: 20,
        fontFamily: textFontFamily,
      ),
    );
  }
}


class CustomSubTitle2 extends StatelessWidget {
  final Color textColor;
  final String text;

  const CustomSubTitle2({super.key, required this.text, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: textColor,
        fontWeight: FontWeight.bold,
        fontSize: 16,
        fontFamily: textFontFamily,
      ),
    );
  }
}

class CustomTextPlaceholder extends StatelessWidget {
  final Color textColor;
  final String text;

  const CustomTextPlaceholder({super.key, required this.text, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: textColor,
        fontWeight: FontWeight.normal,
        fontSize: 16,
        fontFamily: textFontFamily,
      ),
    );
  }
}

class CustomDesc extends StatelessWidget {
  final Color textColor;
  final String text;
  // final String? align;

  const CustomDesc({super.key, required this.text, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      // textAlign: align == null ? TextAlign.center : null,
      style: TextStyle(
        color: textColor,
        fontWeight: FontWeight.normal,
        fontSize: 14,
        fontFamily: textFontFamily,
      ),
    );
  }
}

class CustomCaption extends StatelessWidget {
  final Color textColor;
  final String text;

  const CustomCaption({super.key, required this.text, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: textColor,
        fontWeight: FontWeight.normal,
        fontSize: 12,
        fontFamily: textFontFamily,
      ),
    );
  }
}