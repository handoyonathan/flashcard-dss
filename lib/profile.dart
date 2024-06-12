import 'package:flashcard/edit_profile.dart';
import 'package:flashcard/signin.dart';
import 'package:flashcard/widget/card_container.dart';
import 'package:flashcard/widget/color.dart';
import 'package:flashcard/widget/text.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  final String? token;
  const Profile({super.key, required this.token});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // TextEditingController _controller = TextEditingController();
  // TextEditingController _controller2 = TextEditingController();
  // TextEditingController _controller3 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomSubTitle(text: 'Profile', textColor: AppColors.white),
            ],
          ),
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context, true);
            },
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.white,
            ),
          ),
          backgroundColor: AppColors.text),
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomCardContainer(
                imageAsset: 'asset/Edit.png',
                text: 'Edit Profile',
                imageAsset2: 'asset/edit2.png',
                isAsset: true,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return EditProfile(token: widget.token);
                  }));
                },
              ),
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 65,
                    // color: Colors.white,
                    decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16)),
                    // decoration: BoxDecoration(shape: BoxShape.circle, color: black),
                  ),
                  Positioned(
                    left: 15,
                    right: 15,
                    top: 17.5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomSubTitle(
                          text: 'Logout',
                          textColor: AppColors.text,
                        ),
                        // Spacer(),
                        GestureDetector(
                          onTap:  (){
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                              return SignIn();
                            }));
                          },
                          child: Image.asset(
                            'asset/Logout.png',
                            width: 25,
                            height: 25,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
