import 'package:flashcard/widget/color.dart';
import 'package:flashcard/widget/text.dart';
import 'package:flutter/material.dart';

class CustomCardContainer extends StatelessWidget {
  final String imageAsset;
  final String text;
  final String imageAsset2;
  final int? desc;
  final String? title;
  final bool? isAsset;
  final VoidCallback? onTap;
  

  const CustomCardContainer({
    super.key,
    required this.imageAsset,
    required this.text,
    required this.imageAsset2,
    this.desc,
    this.title,
    this.isAsset = false,
    this.onTap

  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          // height: double.minPositive,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        Positioned(
          left: 15,
          right: 15,
          top: 15,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              isAsset! ? Image.asset(
                imageAsset,
                width: 50,
                height: 50,
              ) :
              Image.network(
                imageAsset,
                width: 50,
                height: 50,
              ),
              SizedBox(width: 5,),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: title != null || desc != null 
                    ? title != null ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomDesc( text:
                            title!,
                            textColor: AppColors.text,
                          ),
                          // SizedBox(height: 5),
                          CustomSubTitle(text:
                            text,
                            textColor: AppColors.text,
                          ),
                        ],
                      ) : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomSubTitle( text:
                        text,
                        textColor: AppColors.text,
                        ),
                          SizedBox(height: 5),
                          CustomDesc(text:
                            '$desc Cards',
                            textColor: AppColors.text,
                          ),
                        ],
                      )
                    : CustomSubTitle( text:
                        text,
                        textColor: AppColors.text,
                        ),
              ),
              Spacer(),
              GestureDetector(
                onTap: onTap,
                child: Image.asset(
                  imageAsset2,
                  width: 25,
                  height: 25,
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}



