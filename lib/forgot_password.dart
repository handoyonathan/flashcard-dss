import 'package:flashcard/widget/button.dart';
import 'package:flashcard/email_sent.dart';
import 'package:flashcard/widget/color.dart';
import 'package:flashcard/widget/text.dart';
import 'package:flashcard/widget/textField.dart';
import 'package:flutter/material.dart';


class ForgotPw extends StatefulWidget {
  const ForgotPw({super.key});

  @override
  State<ForgotPw> createState() => _ForgotPwState();
}

class _ForgotPwState extends State<ForgotPw> {
  TextEditingController _controller = TextEditingController();
  bool isEmpty = false;
  // TextEditingController _controller2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          CustomTitle(text:
            'Forgot Password',
            textColor: AppColors.text,
          ),
        ]),
        leading: GestureDetector(
          onTap: (){Navigator.pop(context);},
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.text,
          ),
        ),
        backgroundColor: AppColors.bg,
        toolbarHeight: 100,
        bottom: PreferredSize(
          preferredSize:
              Size.fromHeight(0.0),
          child: Padding(
            padding:
                EdgeInsets.only(left: 72), 
            child: Align(
              alignment: Alignment.centerLeft,
              child: CustomDesc(text:
                'Enter your email below to receive a password reset link',
                textColor: AppColors.text,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Image.asset(
                'asset/signin.png',
                fit: BoxFit.cover,
                width: 150,
                height: 150,
              ),
              // Spacer(),
              SizedBox(
                height: 30,
              ),
              CustomTextField(
                controller: _controller,
                label: 'Email',
                hintText: 'Enter your email',
                isIcon: false,
                errorText: !isEmpty ? null : 'Email must not be empty',
              ),
              Spacer(),
              CustomButton(onPressed: () {
                if (_controller.text.isNotEmpty){
                  isEmpty = false;
                  Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return EmailSent(email: _controller.text);
          }));
                }
                else {
                  setState(() {
                    isEmpty = true;
                  });
                }
                }, text: 'Submit'),
            ],
          ),
        ),
      ),
    );
  }
}
