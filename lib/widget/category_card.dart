import 'package:flashcard/widget/color.dart';
import 'package:flashcard/widget/text.dart';
import 'package:flutter/material.dart';

class CustomCategoryContainer extends StatelessWidget {
  final String imageAsset;
  final String name;
  final int deck;

  const CustomCategoryContainer({
    super.key,
    required this.imageAsset,
    required this.name,
    required this.deck,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 130,
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(15, 5, 0, 5),
                child: Stack(
                  children: [
                    Image.asset(
                      'asset/box.png',
                      width: 120,
                      height: 120,
                    ),
                    Positioned(
                      top: 17.5,
                      left: 17.5,
                      child: Image.network(
                        imageAsset,
                        fit: BoxFit.cover,
                        width: 80,
                        height: 80,
                      ),
                    ),
                  ],
                ),
              ),
              // SizedBox(width: 20),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10,0,10,10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomSubTitle(text: name, textColor: AppColors.white,),
                      SizedBox(height: 5,),
                      CustomCaption(text: '$deck Decks', textColor: AppColors.white,),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 10,)
      ],
    );
  }
}
