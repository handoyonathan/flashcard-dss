import 'package:flashcard/widget/button.dart';
import 'package:flashcard/widget/color.dart';
import 'package:flashcard/widget/text.dart';
import 'package:flashcard/widget/textField.dart';
import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController _controller = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  TextEditingController _controller3 = TextEditingController();
  TextEditingController _controller4 = TextEditingController();
  bool isMatched = true;
  bool isName = true;
  bool isEmail = true;
  bool isPw = true;
  bool isConfirm = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomSubTitle(text: 'Edit Profile', textColor: AppColors.white),
            ],
          ),
          leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
              child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.white,
          )),
          backgroundColor: AppColors.text),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // SizedBox(height: 20,),
              CustomTextField(
                controller: _controller,
                label: 'Name',
                hintText: 'Enter your name',
                isIcon: false,
                errorText: isName ? null : 'Name must not be empty',
              ),
              SizedBox(
                height: 20,
              ),
              CustomTextField(
                controller: _controller2,
                label: 'Email',
                hintText: 'Enter your email',
                isIcon: false,
                errorText: isEmail ? null : 'Email must not be empty',
              ),
              SizedBox(
                height: 20,
              ),
              CustomTextField(
                controller: _controller3,
                label: 'Password',
                hintText: 'Create password',
                isIcon: true,
                errorText: isPw ? null : 'Password must not be empty',
              ),
              SizedBox(
                height: 20,
              ),
              CustomTextField(
                controller: _controller4,
                label: 'Confirm Password',
                hintText: 'Confirm password',
                isIcon: true,
                errorText: isConfirm ? !isMatched ? 'Password does not match' : null : 'Confirm password must not be empty',
              ),
              Spacer(),
              CustomButton(onPressed: () {
                if (_controller.text.isEmpty){
                  setState(() {
                    isName = false;
                  });
                }
                else{
                  setState(() {
                    isName = true;
                  });
                }
                if (_controller2.text.isEmpty){
                  setState(() {
                    isEmail = false;
                  });
                }
                else{
                  setState(() {
                    isEmail = true;
                  });
                }
                if (_controller3.text.isEmpty){
                  setState(() {
                    isPw = false;
                  });
                }
                else{
                  setState(() {
                    isPw = true;
                  });
                }

                if (_controller4.text.isEmpty){
                  setState(() {
                    isConfirm = false;
                  });
                }
                else{
                  setState(() {
                    isConfirm = true;
                  });
                }

                if (_controller3.text == _controller4.text){
                  isMatched = true;
                  // check to db
                }
                else {
                  setState(() {
                    isMatched = false;
                  });
                }

              }, text: 'Save')
            ],
          ),
        ),
      ),
    );
  }
}
