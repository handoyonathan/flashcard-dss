import 'package:flashcard/cardview.dart';
import 'package:flashcard/detail_data.dart';
import 'package:flashcard/model/card_model.dart';
import 'package:flashcard/model/deck_model.dart';
import 'package:flashcard/widget/card_container.dart';
import 'package:flashcard/widget/color.dart';
import 'package:flashcard/widget/text.dart';
import 'package:flutter/material.dart';

String api = 'https://c2cb-112-215-224-194.ngrok-free.app/';
// String api = 'http://localhost:5050/';

class CategoryDeck extends StatefulWidget {
  final String name, id, token;
  const CategoryDeck(
      {super.key, required this.name, required this.id, required this.token});

  @override
  State<CategoryDeck> createState() => _CategoryDeckState();
}

class _CategoryDeckState extends State<CategoryDeck> {
  List<DeckModel> decks = [];
  List<DeckModel> filteredDecks = [];
  String searchQuery = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  void loadData() {
    fetchAllDeck(widget.token, widget.id).then((fetchedDecks) {
      setState(() {
        decks = fetchedDecks;
        filteredDecks = fetchedDecks;
      });
    }).catchError((error) {
      print('Error fetching decks: $error');
    });
  }

  void filterDecks(String query) {
    List<DeckModel> results = [];
    if (query.isEmpty) {
      results = decks;
    } else {
      results = decks
          .where((deck) =>
              deck.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    setState(() {
      searchQuery = query;
      filteredDecks = results;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            )),
        backgroundColor: AppColors.text,
        actions: [
          GestureDetector(
            onTap: () async {
              final result = await Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                return DetailData(
                  id: widget.id,
                  token: widget.token,
                  detail: 'category',
                );
              }));

              if (result == true) {
                loadData();
              }
            },
            child: Container(
              margin: EdgeInsets.only(left: 10, right: 35),
              // color: Colors.amber,
              child: Row(
                children: [
                  Image.asset(
                    'asset/edit_icon.png',
                    color: AppColors.white,
                    width: 16,
                    height: 16,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Edit',
                    style: TextStyle(
                        color: AppColors.white,
                        fontSize: 12,
                        fontFamily: 'BricolageGrotesque'),
                  )
                ],
              ),
            ),
          )
        ],
      ),
      backgroundColor: AppColors.bg,
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              onChanged: (query){
                filterDecks(query);
              },
              decoration: InputDecoration(
                hintText: 'Search',
                fillColor: AppColors.white,
                filled: true,
                prefixIcon: GestureDetector(
                    child: SizedBox(
                        height: 10,
                        width: 10,
                        child: Image.asset(
                          'asset/search-line.png',
                          width: 20,
                          height: 20,
                        ))),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  // borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredDecks.length,
                itemBuilder: (context, index) {
                  final deck = filteredDecks[index];
                  print(deck.imageUrl);
                  print(deck.name);
                  print(deck.fileName);
                  print('${api}images/${deck.fileName}');
                  return FutureBuilder<int>(
                    future: fetchCardCount(widget.token, deck.id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        final cardCount = snapshot.data;
                        return Column(
                          children: [
                            CustomCardContainer(
                              imageAsset: '${api}images/${deck.fileName}',
                              text: deck.name,
                              desc: cardCount,
                              imageAsset2: 'asset/arrow.png',
                              onTap: () async {
                                final result = await Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return CardView(id: deck.id, name: deck.name, token: widget.token,);
                                }));

                                if (result == true) {
                                  loadData();
                                }
                              },
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      )),
    );
  }
}
