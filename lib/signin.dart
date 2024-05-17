import 'package:flashcard/widget/button.dart';
import 'package:flashcard/widget/color.dart';
import 'package:flashcard/widget/text.dart';
import 'package:flashcard/forgot_password.dart';
import 'package:flashcard/home.dart';
import 'package:flashcard/signup.dart';
import 'package:flashcard/widget/textField.dart';
import 'package:flashcard/model/user_model.dart';
import 'package:flutter/material.dart';

final String textFontFamily = 'BricolageGrotesque';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController _controller = TextEditingController();
  TextEditingController _controller2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: SingleChildScrollView( 
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTitle(
                          text: 'Flash Card',
                          textColor: AppColors.text,
                        ),
                        CustomDesc(
                          text: 'Please log in to continue',
                          textColor: AppColors.text,
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return HomePage(token: null,);
                        }));
                      }, 
                      icon: Icon(Icons.close), 
                      alignment: Alignment.centerRight,
                    ),
                  ],
                ),
                SizedBox(height: 50),
                Image.asset(
                  'asset/signin.png',
                  fit: BoxFit.cover,
                  width: 150,
                  height: 150,
                ),
                SizedBox(height: 50),
                CustomTextField(
                  controller: _controller,
                  label: 'Email',
                  hintText: 'Enter your email',
                  isIcon: false,
                ),
                SizedBox(height: 20),
                CustomTextField(
                  controller: _controller2,
                  label: 'Password',
                  hintText: 'Enter your password',
                  isIcon: true,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ForgotPw();
                          }));
                        },
                        child: CustomDesc(text: 'Forgot Password?', textColor: AppColors.text,),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 50),
                CustomButton(
                  onPressed: () async {
                    print(_controller.text);
                    print(_controller2.text);
                    final isVerified = await verifyCredentials(
                      _controller.text, 
                      _controller2.text,
                    );

                    if (isVerified != null) {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return HomePage(token: isVerified,);
                      }));
                    } else {
                      print('Login failed. Please check your credentials.');
                    }
                  },
                  text: 'Sign In',
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: CustomDesc(text: "Don't have an account yet?", textColor: AppColors.text,),
                ),
                OutlinedButton(
                  onPressed: () async{
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return SignUp();
                    }));
                    
                  },
                  child: CustomSubTitle(text:
                    'Sign Up',
                    textColor: AppColors.text,
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.text, width: 1.5),
                    minimumSize: Size(double.infinity, 0),
                    textStyle: TextStyle(fontSize: 18, fontFamily: textFontFamily),
                    backgroundColor: Colors.transparent,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
