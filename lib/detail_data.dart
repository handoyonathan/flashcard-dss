import 'package:flashcard/model/card_model.dart';
import 'package:flashcard/widget/button.dart';
import 'package:flashcard/widget/card_container.dart';
import 'package:flashcard/widget/color.dart';
import 'package:flashcard/widget/text.dart';
import 'package:flashcard/model/category_model.dart';
import 'package:flashcard/model/deck_model.dart';
import 'package:flashcard/form_data.dart';
import 'package:flutter/material.dart';

String api = 'https://2aac-112-215-226-99.ngrok-free.app/';
// String api = 'http://localhost:5050/';

class DetailData extends StatefulWidget {
  final String id, token, detail;
  const DetailData(
      {super.key, required this.id, required this.token, required this.detail});

  @override
  State<DetailData> createState() => _DetailDataState();
}

class _DetailDataState extends State<DetailData> {
  // bool isEmpty = true;
  List<dynamic> child = [];
  // List<CategoryModel> categories = [];
  String? imagePath;
  String? name;
  // late Future<CategoryModel> _categoryFuture;
  // late Future<DeckModel> _deckFuture;
  late Future<dynamic> fetchData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  void loadData() {
    if (widget.detail == 'category') {
      fetchData = fetchOneCategory(widget.token, widget.id);

      fetchAllDeck(widget.token, widget.id).then((fetchedDecks) {
        setState(() {
          child = fetchedDecks;
        });
      }).catchError((error) {
        print('Error fetching decks: $error');
      });
    } else {
      fetchData = fetchOneDeck(widget.token, widget.id);
      // print(fetchData);

      fetchAllCard(widget.token, widget.id).then((fetchedCards) {
        setState(() {
          child = fetchedCards;
        });
      }).catchError((error) {
        print('Error fetching cards: $error');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomSubTitle(
                  text: widget.detail == 'category'
                      ? 'Category Detail'
                      : 'Deck Detail',
                  textColor: AppColors.white),
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
      // backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: FutureBuilder(
            future: fetchData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error di edit: ${snapshot.error}');
              } else {
                final data = snapshot.data!;
                final imagePath = '${api}images/${data.fileName}';
                final name = data.name;
                return Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomCardContainer(
                      imageAsset: imagePath,
                      text: name,
                      title:
                          widget.detail == 'category' ? 'Categories' : 'Decks',
                      imageAsset2: 'asset/edit_icon.png',
                      onTap: () async {
                        final result = await Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          if (widget.detail == 'category') {
                            return FormData(
                              id: data.id,
                              token: widget.token,
                              detail: 'category',
                              isEdit: true,
                            );
                          } else {
                            return FormData(
                              token: widget.token,
                              id: data.id,
                              detail: 'deck',
                              isEdit: true,
                            );
                          }
                        }));

                        if (result == true) {
                          loadData();
                        }
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: CustomSubTitle(
                            text:
                                widget.detail == 'category' ? 'Decks' : 'Cards',
                            textColor: AppColors.text)),
                    SizedBox(
                      height: 10,
                    ),
                    child.isEmpty
                        ? Column(
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
                                  text: widget.detail == 'category'
                                      ? "You haven't created any deck lists yet."
                                      : "You haven't created any card lists yet.",
                                  textColor: AppColors.text),
                              SizedBox(
                                height: 10,
                              ),
                              CustomDesc(
                                  text: "Let's create a new one!",
                                  textColor: AppColors.text)
                            ],
                          )
                        : Expanded(
                            child: ListView.builder(
                              itemCount: child.length,
                              itemBuilder: (context, index) {
                                final childs = child[index];

                                // print(deck.imageUrl);
                                // print(deck.name);
                                // print(deck.fileName);
                                // print('${api}images/${deck.fileName}');
                                return Column(
                                  children: [
                                    CustomCardContainer(
                                        imageAsset: widget.detail == 'category'
                                            ? '${api}images/${childs.fileName}'
                                            : '${api}images/${childs.imageName}',
                                        text: childs.name,
                                        imageAsset2: widget.detail == 'category'
                                            ? 'asset/arrow.png'
                                            : 'asset/edit_icon.png',
                                        onTap: () async {
                                          if (widget.detail == 'category') {
                                            var result = await Navigator.push(
                                                context, MaterialPageRoute(
                                                    builder: (context) {
                                              return DetailData(
                                                id: childs.id,
                                                token: widget.token,
                                                detail: 'deck',
                                              );
                                            }));
                                            if (result == true) {
                                              loadData();
                                            }
                                          }
                                          if (widget.detail == 'deck') {
                                            final result = await Navigator.push(
                                            context, MaterialPageRoute(
                                                builder: (context) {
                                            return FormData(
                                              token: widget.token,
                                              id: childs.id,
                                              detail: 'card',
                                              isEdit: true,
                                            );}));
                                            if (result == true) {
                                              loadData();
                                            }
                                          }
                                          
                                        }),
                                    SizedBox(
                                      height: 15,
                                    )
                                  ],
                                );
                              },
                            ),
                          ),
                    // Spacer(),
                    // SizedBox(height: 30,),
                    child.isEmpty
                        ? Spacer()
                        : SizedBox(
                            height: 30,
                          ),
                    CustomButton(
                        onPressed: () async {
                          bool result = false;
                          if (widget.detail == 'category') {
                            result = await Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return FormData(
                                token: widget.token,
                                detail: 'deck',
                                id: widget.id,
                              );
                            }));
                          } else if (widget.detail == 'deck') {
                            result = await Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return FormData(
                                token: widget.token,
                                detail: 'card',
                                id: widget.id,
                              );
                            }));
                          }

                          if (result == true) {
                            loadData();
                          }
                        },
                        text: widget.detail == 'category'
                            ? 'Add New Deck'
                            : 'Add New Card')
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
