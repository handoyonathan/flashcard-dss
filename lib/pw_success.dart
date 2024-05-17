import 'package:flashcard/widget/color.dart';
import 'package:flashcard/widget/text.dart';
import 'package:flutter/material.dart';



class PwSuccess extends StatelessWidget {
  const PwSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.text,
          ),
        ),
        backgroundColor: AppColors.bg,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 7),
                child: Icon(Icons.lock_outline),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomTitle(text:
                      'Success',
                      textColor: AppColors.text,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Congratulations! Your password has been reset. After this you will be redirected back to the sign in page.',
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis, style: TextStyle(color: AppColors.text, fontSize: 14, fontWeight: FontWeight.w400, fontFamily: textFontFamily)
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
