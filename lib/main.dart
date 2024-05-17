import 'package:flashcard/cardview.dart';
import 'package:flashcard/category_deck.dart';
import 'package:flashcard/edit_profile.dart';
import 'package:flashcard/email_sent.dart';
import 'package:flashcard/forgot_password.dart';
import 'package:flashcard/home.dart';
import 'package:flashcard/onboard.dart';
import 'package:flashcard/profile.dart';
import 'package:flashcard/pw_success.dart';
import 'package:flashcard/signin.dart';
import 'package:flashcard/signup.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // color: bgColor,
      // home: OnboardingScreen(),
      home: SignIn(),
      // home: CardSlide(),
      // home: HomePage(token: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIxYjFhYTRiMy05NmIzLTRiM2MtOTc5ZS1kZmViYWUwNmUyYWUiLCJpYXQiOjE3MTQ3MjIwMjAsImV4cCI6MTcxNDgwODQyMH0.P6QG6ubREkWiieJPO5XaigX4e2uHgt-5ljc4dUu1WNU'),
      // home: SignUp(),
      // home: Profile(),
      // home: EditProfile(),
      // home: NewCategory(),
      // home: EmailSent(email: 'uhuy',),
      // home: PwSuccess(),
      // home: CategoryDeck(name: 'animal',),
      // home: NewData(token: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIxYjFhYTRiMy05NmIzLTRiM2MtOTc5ZS1kZmViYWUwNmUyYWUiLCJpYXQiOjE3MTQ2MTcxOTksImV4cCI6MTcxNDcwMzU5OX0.0qkIhypAsVQVrIPL2MH1VGBSofTaTFIWG6WZ1eSHL_M', detail: 'card'),
    );
  }
}

