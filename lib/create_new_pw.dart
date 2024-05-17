import 'package:flashcard/widget/button.dart';
import 'package:flashcard/widget/color.dart';
import 'package:flashcard/pw_success.dart';
import 'package:flashcard/widget/text.dart';
import 'package:flashcard/widget/textField.dart';
import 'package:flutter/material.dart';

class CreatePw extends StatefulWidget {
  const CreatePw({super.key});

  @override
  State<CreatePw> createState() => _CreatePwState();
}

class _CreatePwState extends State<CreatePw> {
  TextEditingController _controller = TextEditingController();
  // TextEditingController _controller2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          CustomTitle(
            text: 'Create New Password',
            textColor: AppColors.text,
          ),
        ]),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.text,
          ),
        ),
        backgroundColor: AppColors.bg,
        toolbarHeight: 100,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(0.0),
          child: Padding(
            padding: EdgeInsets.only(left: 72),
            child: Align(
              alignment: Alignment.centerLeft,
              child: CustomDesc(text:
                'Your new password must be different from any of your previous password',
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
                label: 'New Password',
                hintText: 'Cerate new password',
                isIcon: true,
              ),
              SizedBox(
                height: 30,
              ),
              CustomTextField(
                controller: _controller,
                label: 'Confirm password',
                hintText: 'Confirm password',
                isIcon: true,
              ),
              Spacer(),
              CustomButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return PwSuccess();
                    }));
                  },
                  text: 'Save'),
            ],
          ),
        ),
      ),
    );
  }
}
