import 'package:flashcard/widget/button.dart';
import 'package:flashcard/widget/color.dart';
import 'package:flashcard/widget/text.dart';
import 'package:flashcard/widget/textField.dart';
import 'package:flashcard/model/user_model.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController _controller = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  TextEditingController _controller3 = TextEditingController();
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  // bool _passwordsMatch = true;


  // List<Map<String, dynamic>> category = [
  //   {'name': 'Animals', 'image': 'asset/cat1.png', },
  //   {'name': 'Geography', 'image': 'asset/cat2.png'},
  //   {'name': 'Gear and Accessories', 'image': 'asset/cat3.png'},
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Align(
            alignment: Alignment.centerLeft,
            child: CustomSubTitle(
              text: 'Sign Up',
              textColor: AppColors.white,
            ),
          ),
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.white,
              )),
          backgroundColor: AppColors.text),
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Spacer(),
                SizedBox(height: 50,),
                Image.asset(
                  'asset/signup.png',
                  fit: BoxFit.cover,
                  width: 150,
                  height: 150,
                ),
                // Spacer(),
                SizedBox(height: 50,),
                CustomTextField(
                  controller: _controller,
                  label: 'Email',
                  hintText: 'Enter your email',
                  isIcon: false,
                  errorText: _emailError,
                ),
                SizedBox(
                  height: 20,
                ),
                CustomTextField(
                  controller: _controller2,
                  label: 'Password',
                  hintText: 'Create password',
                  isIcon: true,
                  errorText: _passwordError,
                ),
                SizedBox(
                  height: 20,
                ),
                CustomTextField(
                  controller: _controller3,
                  label: 'Confirm Password',
                  hintText: 'Confirm password',
                  isIcon: true,
                  errorText: _confirmPasswordError,
                ),
                // Spacer(),
                SizedBox(height: 50,),
                CustomButton(
                    onPressed: () async {
          
                      setState(() {
                      // Reset any previous errors
                      _emailError = null;
                      _passwordError = null;
                      _confirmPasswordError = null;
                    });
                      // print(_controller2.text);
                      // print(_controller3.text);
                      if (_controller.text.isEmpty || _controller2.text.isEmpty || _controller3.text.isEmpty){
                        if (_controller.text.isEmpty)  _emailError = 'Email must be filled';
                        if (_controller2.text.isEmpty) _passwordError = 'Password must be filled';
                        if (_controller3.text.isEmpty) _confirmPasswordError = 'Confirm password must be the same as password';
          
                      } else {
                        if (_controller2.text == _controller3.text) {
                        // print(_controller.text);
                        // print(_controller2.text);
                        bool isVerified = await storeAccount(_controller.text,
                            _controller2.text, _controller3.text);
          
                        if (isVerified) {
                          // print('bisa di halaman sign up');
                          Navigator.pop(context);
                        } else {
                          print('Sign Up failed.');
                        }
                      }
                      else {
                        setState(() {
                          _confirmPasswordError = 'Confirm password must be the same as password';
                        });
                      }
                      }
                    },
                    text: 'Sign Up')
              ],
            ),
          ),
        ),
      ),
    );
  }
}
