import 'package:flashcard/widget/color.dart';
import 'package:flashcard/widget/text.dart';
import 'package:flutter/material.dart';


// final String textFontFamily = 'BricolageGrotesque';


class EmailSent extends StatelessWidget {
  final String email;
  const EmailSent({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(leading: GestureDetector(
        onTap: (){Navigator.pop(context);},
        child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.text,
          ),
      ),backgroundColor: AppColors.bg,), body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 7),
                  child: Icon(Icons.email_outlined),
                ),
                SizedBox(width: 10,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CustomTitle(text: 'Email Sent', textColor: AppColors.text,),
                      SizedBox(height: 5,),
                      Text('We have sent you an email at $email. Check your inbox and follow the instructions to reset your account password.', maxLines: 5, overflow: TextOverflow.ellipsis, style: TextStyle(color: AppColors.text, fontSize: 14, fontWeight: FontWeight.w400, fontFamily: textFontFamily),),
                      SizedBox(height: 50,),
                      Row(
                        children: [
                          CustomDesc(text: 'Did not recieve the email?', textColor: AppColors.text,),
                          TextButton(onPressed: (){}, child: Text('Resend Email', style: TextStyle(color: AppColors.text, fontWeight: FontWeight.w600, fontSize: 14, fontFamily: textFontFamily),),)
                        ],
                      ),
                      // Text('ahi'),
                      // SizedBox(height: 10,),
                      Row(
                        children: [
                          CustomDesc(text: 'Wrong email address?', textColor: AppColors.text,),
                          TextButton(onPressed: (){
                            Navigator.pop(context);
                          }, child: Text('Change Email', style: TextStyle(color: AppColors.text, fontWeight: FontWeight.w600, fontSize: 14, fontFamily: textFontFamily),),)
                        ],
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