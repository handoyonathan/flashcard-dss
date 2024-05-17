import 'package:flashcard/category_deck.dart';
import 'package:flashcard/detail_data.dart';
import 'package:flashcard/form_data.dart';
import 'package:flashcard/model/category_model.dart';
import 'package:flashcard/profile.dart';
import 'package:flashcard/signin.dart';
import 'package:flashcard/widget/category_card.dart';
import 'package:flashcard/widget/color.dart';
import 'package:flashcard/widget/text.dart';
import 'package:flashcard/model/deck_model.dart';
import 'package:flutter/material.dart';

String api = 'https://c2cb-112-215-224-194.ngrok-free.app/';
// String api = 'http://localhost:5050/';

class HomePage extends StatefulWidget {
  final String? token;
  const HomePage({super.key, required this.token});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CategoryModel> categories = [];
  // List<DeckModel> decks = [];
  int? deckCount;
  List<CategoryModel> filteredCategories = [];
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    if (widget.token != null){
      loadData();
    }
    
  }

  void loadData() {
    fetchAllCategory(widget.token!).then((fetchedCategories) {
      setState(() {
        categories = fetchedCategories;
        filteredCategories = fetchedCategories;
        // print(categories.length);
      });
    }).catchError((error) {
      print('Error fetching categories: $error');
    });
  }

  void filterCategories(String query) {
    List<CategoryModel> results = [];
    if (query.isEmpty) {
      results = categories;
    } else {
      results = categories
          .where((category) =>
              category.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    setState(() {
      searchQuery = query;
      filteredCategories = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.text,
        items: [
          BottomNavigationBarItem(
            icon: SizedBox.shrink(),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SizedBox.shrink(),
            label: '',
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () async {
              if (widget.token == null) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return SignIn();
                }));
              } else {
                final result = await Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                  return FormData(
                    token: widget.token!,
                    detail: 'category',
                  );
                }));

                if (result == true) {
                  loadData();
                }
              }
            },
            shape: CircleBorder(),
            backgroundColor: AppColors.cta2,
            child: Image.asset(
              'asset/Plus.png',
              width: 35,
              height: 35,
              color: AppColors.text,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          CustomCaption(text: 'Create New Category', textColor: AppColors.white)
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomTitle(
                  text: 'Flash Card',
                  textColor: AppColors.text,
                ),
                GestureDetector(
                  onTap: () async {
                    // print('hai');
                    if (widget.token == null) {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return SignIn();
                      }));
                    } else {
                      final result = await Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return Profile();
                      }));
                      print(result);
                      if (result == true) {
                        loadData();
                      }
                    }
                  },
                  child: Stack(children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: AppColors.text),
                    ),
                    Positioned(
                        left: 5,
                        top: 5,
                        child: Image.asset(
                          'asset/profile.png',
                          width: 30,
                          height: 30,
                        ))
                  ]),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: TextField(
                onChanged: (query){
                  filterCategories(query);}
                ,
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
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredCategories.length,
                itemBuilder: (context, index) {
                  final category = filteredCategories[index];
                  // fetchDeckCount(widget.token!, category.id).then((int count) {
                  //   deckCount = count;

                  //   print(category.id + " " + count.toString());
                  //   // deckCount = count;
                  // });

                  // print(category.imageUrl);
                  // print(category.name);
                  // print(category.fileName);
                  // print(
                  //     'https://a901-112-215-224-245.ngrok-free.app/images/${category.fileName}');
                  return FutureBuilder<int>(
                    future: fetchDeckCount(widget.token!, category.id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        final deckCount = snapshot.data;

                        return GestureDetector(
                          onTap: () async {
                            final result = await Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return CategoryDeck(
                                name: category.name,
                                id: category.id,
                                token: widget.token!,
                              );
                            }));
                            print(result);
                            if (result == true) {
                              loadData();
                            }
                          },
                          child: CustomCategoryContainer(
                            imageAsset: '${api}images/${category.fileName}',
                            name: category.name,
                            deck: deckCount!,
                          ),
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
