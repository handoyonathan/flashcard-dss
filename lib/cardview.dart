import 'dart:math';
import 'package:flashcard/model/card_model.dart';
import 'package:flashcard/widget/color.dart';
import 'package:flashcard/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:loop_page_view/loop_page_view.dart';
import 'package:audioplayers/audioplayers.dart';

class CardView extends StatefulWidget {
  final String id, name, token;
  const CardView(
      {super.key, required this.id, required this.name, required this.token});

  @override
  State<CardView> createState() => _CardViewState();
}

class _CardViewState extends State<CardView> {
  List<CardModel> card = [];
  List<bool> isTouchedList = [];
  String? cardName;
  int? cardIndex = 0;
  bool grid = true;
  bool isPlaying = false;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() {
    fetchAllCard(widget.token, widget.id).then((fetchedCard) {
      setState(() {
        card = fetchedCard;
        isTouchedList = List<bool>.filled(card.length, false);
        if (fetchedCard.isNotEmpty) {
          cardName = fetchedCard[0].name;
        }
      });
    }).catchError((error) {
      print('Error fetching categories: $error');
    });
  }

  void shuffleCards() {
    setState(() {
      card.shuffle(Random());
      isTouchedList = List<bool>.filled(card.length, false);
      if (card.isNotEmpty) {
        cardName = card[0].name;
      }
    });
  }

  Future<void> playAudio(String? audioUrl, int? index) async {
    if (audioUrl != null && audioUrl.isNotEmpty) {
      setState(() {
        isPlaying = true;
        if (index != null) {
          isTouchedList[index] = true;
        }
      });
      await _audioPlayer.play(UrlSource(audioUrl));
      await _audioPlayer.onPlayerComplete.first;
      setState(() {
        isPlaying = false;
        if (index != null) {
          isTouchedList[index] = false;
        }
      });
    } else {
      print('No audio URL found for this card');
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: CustomSubTitle(
            text: widget.name,
            textColor: AppColors.white,
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context, true);
          },
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.text,
        actions: [
          GestureDetector(
            onTap: () {
              setState(() {
                grid = !grid;
              });
            },
            child: Container(
              margin: EdgeInsets.only(left: 10, right: 35),
              child: Image.asset(
                grid ? 'asset/Grid.png' : 'asset/Grid2.png',
                color: AppColors.white,
                width: 24,
                height: 24,
              ),
            ),
          )
        ],
      ),
      body: card.isEmpty
          ? Column(
              children: [
                Spacer(
                  flex: 1,
                ),
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 20),
                      Image.asset(
                        'asset/EmptyState.png',
                        width: 120,
                        height: 120,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomSubTitle2(
                          text: "You haven't created any card lists yet.",
                          textColor: AppColors.text),
                      SizedBox(
                        height: 10,
                      ),
                      CustomDesc(
                          text: "Let's create a new one!",
                          textColor: AppColors.text)
                    ],
                  ),
                ),
                Spacer(
                  flex: 1,
                )
              ],
            )
          : SafeArea(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: grid
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 6,
                            child: card.length > 1
                                ? LoopPageView.builder(
                                    itemCount: card.length,
                                    itemBuilder: (context, index) {
                                      final currentCard = card[index];
                                      return Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            5, 0, 5, 10),
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: AppColors.white,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black26,
                                                offset: Offset(0, 1),
                                                blurRadius: 4,
                                              ),
                                            ],
                                          ),
                                          child: Center(
                                            child: AspectRatio(
                                              aspectRatio: 0.6,
                                              child: Image.network(
                                                '${api}images/${currentCard.imageName}',
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    onPageChanged: (index) {
                                      setState(() {
                                        cardName = card[index].name;
                                        cardIndex = index;
                                      });
                                    },
                                  )
                                : Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      child: AspectRatio(
                                        aspectRatio: 1,
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: AppColors.white,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black26,
                                                offset: Offset(0, 1),
                                                blurRadius: 4,
                                              ),
                                            ],
                                          ),
                                          child: Center(
                                            child: AspectRatio(
                                              aspectRatio: 0.6,
                                              child: Image.network(
                                                '${api}images/${card[0].imageName}',
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomBigTitle(
                                  text: 'Swipe card',
                                  textColor: AppColors.accent2,
                                  align: 'center',
                                ),
                                CustomBigTitle(
                                  text: 'left or right',
                                  textColor: AppColors.accent2,
                                  align: 'center',
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              final currentCard = card.isNotEmpty
                                  ? card.length > 1
                                      ? card[cardIndex!]
                                      : card[0]
                                  : null;
                              if (currentCard != null) {
                                final url =
                                    '${api}audios/${currentCard.audioName}';
                                playAudio(url, null);
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              height: 64,
                              decoration: BoxDecoration(
                                color: AppColors.text,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomSubTitle(
                                      text: cardName!,
                                      textColor: AppColors.white,
                                    ),
                                    Image.asset(
                                      'asset/sound.png',
                                      width: 24,
                                      height: 24,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          GestureDetector(
                            onTap: shuffleCards,
                            child: Container(
                              width: double.infinity,
                              height: 64,
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomSubTitle(
                                      text: 'Shuffle Card',
                                      textColor: AppColors.text,
                                    ),
                                    Image.asset(
                                      'asset/shuffle.png',
                                      width: 24,
                                      height: 24,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: shuffleCards,
                            child: Container(
                              width: double.infinity,
                              height: 64,
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomSubTitle(
                                      text: 'Shuffle Card',
                                      textColor: AppColors.text,
                                    ),
                                    Image.asset(
                                      'asset/shuffle.png',
                                      width: 24,
                                      height: 24,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Expanded(
                              child: GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount:
                                              (card.length % 3 == 0) ? 3 : 2,
                                          crossAxisSpacing: 10,
                                          mainAxisSpacing: 10),
                                  itemCount: card.length,
                                  itemBuilder: (context, index) {
                                    final currentCard = card[index];
                                    return GestureDetector(
                                      onTap: () async {
                                        final url =
                                            '${api}audios/${currentCard.audioName}';
                                        if (!isPlaying) {
                                          setState(() {
                                            isTouchedList[index] = true;
                                          });
                                          await playAudio(url, index);
                                          setState(() {
                                            isTouchedList[index] = false;
                                          });
                                        }
                                      },
                                      child: isTouchedList[index]
                                          ? Container(
                                              decoration: BoxDecoration(
                                                color: AppColors.text,
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black26,
                                                    offset: Offset(0, 1),
                                                    blurRadius: 4,
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  CustomSubTitle2(
                                                    text: currentCard.name,
                                                    textColor: AppColors.white,
                                                  ),
                                                  SizedBox(height: 30),
                                                  Image.asset(
                                                    'asset/sound.png',
                                                    width: 24,
                                                    height: 24,
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Container(
                                              decoration: BoxDecoration(
                                                color: AppColors.white,
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black26,
                                                    offset: Offset(0, 1),
                                                    blurRadius: 4,
                                                  ),
                                                ],
                                              ),
                                              child: Center(
                                                child: AspectRatio(
                                                  aspectRatio: 0.6,
                                                  child: Image.network(
                                                    '${api}images/${currentCard.imageName}',
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                              ),
                                            ),
                                    );
                                  }))
                        ],
                      ),
              ),
            ),
    );
  }
}
