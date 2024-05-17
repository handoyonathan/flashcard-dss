import 'package:flashcard/widget/button.dart';
import 'package:flashcard/widget/color.dart';
import 'package:flashcard/widget/text.dart';
import 'package:flashcard/signin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';


final List<String> images = [
  'asset/onboarding1.png',
  'asset/onboarding2.png',
  'asset/onboarding3.png',
];
final List<String> boldTexts = [
  'Welcome to Flash Card App!',
  "Let's Get Started!",
  'Enhance Learning with Spelling Sounds'
];
final List<String> texts = [
  'Our app is designed to make vocabulary learning fun and interactive for toddlers. With vibrant images and engaging sounds, get ready for a journey of discovery!',
  "Dive in and create your first deck of cards. Upload images, sounds, and organize your deck easily. In just a few taps, you'll unlock learning opportunities for your little one.",
  "Every child is unique. Utilize our spelling sound feature to personalize your toddler's learning experience. Welcome to endless possibilities!"
];

class OnboardingScreen extends StatelessWidget {
  final List<OnboardingItem> onboardingItems = [
    OnboardingItem(
      isLast: false,
      image: 'asset/onboarding1.png',
      boldText: 'Welcome to Flash Card App!',
      text:
          'Our app is designed to make vocabulary learning fun and interactive for toddlers. With vibrant images and engaging sounds, get ready for a journey of discovery!',
    ),
    OnboardingItem(
      isLast: false,
      image: 'asset/onboarding2.png',
      boldText: "Let's Get Started!",
      text:
          "Dive in and create your first deck of cards. Upload images, sounds, and organize your deck easily. In just a few taps, you'll unlock learning opportunities for your little one.",
    ),
    OnboardingItem(
      isLast: true,
        image: 'asset/onboarding3.png',
        boldText: 'Enhance Learning with Spelling Sounds',
        text:
            "Every child is unique. Utilize our spelling sound feature to personalize your toddler's learning experience. Welcome to endless possibilities!"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Swiper(
        pagination: SwiperPagination(builder: DotSwiperPaginationBuilder(color: AppColors.gray2 , activeColor: AppColors.text)),
        loop: false,
        itemCount: onboardingItems.length,
        itemBuilder: (BuildContext context, int index) {
          return OnboardingPage(
            item: onboardingItems[index],
          );
        },
      ),
    );
  }
}

class OnboardingItem {
  final String image;
  final String boldText;
  final String text;
  final bool isLast;

  OnboardingItem({
    required this.image,
    required this.boldText,
    required this.text,
    this.isLast = false
  });
}

class OnboardingPage extends StatelessWidget {
  final OnboardingItem item;

  const OnboardingPage({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                item.image,
                height: 200,
                width: 200,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: CustomTitle(
                  // align: 'center',
                  text: item.boldText,
                  textColor: AppColors.text,
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                child: CustomDesc(
                  // align: true,
                  text: item.text,
                  textColor: AppColors.text,
                ),
              ),
              if (item.isLast) // Tampilkan tombol hanya jika halaman terakhir
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: CustomButton(
                    text: 'Get Started',
                    onPressed: () {
                      // Action when button is pressed
                      print('masuk');
                      Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return SignIn();
          }));
                    },
                  ),
                ),
            ],
          ),
        ),
        // SwiperPagination(builder: DotSwiperPaginationBuilder()),
      ],
    );
  }
}

