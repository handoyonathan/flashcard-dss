import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flashcard/detail_data.dart';
import 'package:flashcard/home.dart';
import 'package:flashcard/model/card_model.dart';
import 'package:flashcard/model/category_model.dart';
import 'package:flashcard/widget/button.dart';
import 'package:flashcard/widget/color.dart';
import 'package:flashcard/widget/text.dart';
import 'package:flashcard/widget/textField.dart';
import 'package:flashcard/model/deck_model.dart';
import 'package:flashcard/model/user_model.dart';
import 'package:flutter/material.dart';

String api = 'https://2aac-112-215-226-99.ngrok-free.app/';
// String api = 'http://localhost:5050/';

class FormData extends StatefulWidget {
  final String token, detail;
  final String? id;
  final bool? isEdit;
  const FormData(
      {super.key,
      required this.token,
      required this.detail,
      this.id,
      this.isEdit});

  @override
  State<FormData> createState() => _FormDataState();
}

class _FormDataState extends State<FormData> {
  TextEditingController _controller = TextEditingController();
  // TextEditingController _controller2 = TextEditingController();
  // TextEditingController _controller3 = TextEditingController();
  File? image;
  File? audio;
  bool? isImagePicked;
  bool? isNamePicked;
  bool? isAudioPicked;
  var imageURL, audioURL, fullAudioURL;
  String? detail;
  String? sourceID;
  Future<dynamic>? fetchData;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.isEdit != null) {
      if (widget.detail == 'category') {
        fetchData = fetchOneCategory(widget.token, widget.id!);
      } else if (widget.detail == 'deck') {
        fetchData = fetchOneDeck(widget.token, widget.id!);
      } else {
        fetchData = fetchOneCard(widget.token, widget.id!);
      }
    }
  }

  void showTopSnackBar(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 16,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              message,
              style: TextStyle(color: AppColors.text),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }

  Future<void> playAudio(String? audioUrl) async {
    if (audioUrl != null && audioUrl.isNotEmpty) {
      
      await _audioPlayer.play(UrlSource(audioUrl));
      // await _audioPlayer.onPlayerComplete.first;
      
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
      appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomSubTitle(
                  text: widget.isEdit == null
                      ? widget.detail == 'category'
                          ? 'Create New Category'
                          : widget.detail == 'deck'
                              ? 'Add New Deck'
                              : 'Add New Card'
                      : widget.detail == 'category'
                          ? 'Edit Category'
                          : widget.detail == 'deck'
                              ? 'Edit Deck'
                              : 'Edit Card',
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
                  return Text('Error 1: ${snapshot.error}');
                } else {
                  if (widget.isEdit != null && isImagePicked == null) {
                    final data = snapshot.data!;
                    detail = data.name;

                    if (widget.detail == 'card') {
                      image = File('${api}images/${data.imageName}');
                      sourceID = data.deckId;

                      if (data.audioName == null) {
                        isAudioPicked = false;
                        audio = null;
                      } else {
                        audio = File('${api}audios/${data.audioName}');
                        audioURL = audio!.path;
                        fullAudioURL = audioURL;
                        print('audio pathnya ngih: ' + audio!.path);
                        if (audioURL.toString().length > 20) {
                          audioURL = audioURL.toString().substring(0, 10) +
                              '...' +
                              audioURL.toString().substring(
                                  audioURL.toString().length - 10,
                                  audioURL.toString().length);
                        }
                        print(audioURL);

                        isAudioPicked = true;
                      }
                    } else {
                      image = File('${api}images/${data.fileName}');
                      if (widget.detail == 'deck') {
                        sourceID = data.categoryId;
                      }
                    }

                    imageURL = image!.path;
                    _controller.text = data.name;
                    // imageURL = data.fileName;
                    if (imageURL.toString().length > 20) {
                      imageURL = imageURL.toString().substring(0, 10) +
                          '...' +
                          imageURL.toString().substring(
                              imageURL.toString().length - 10,
                              imageURL.toString().length);
                    }
                    print(imageURL);
                    print('ini image pathnya: ' + image!.path);
                    isImagePicked = true;
                  }
                  else {
                    // imageURL = null;
                    print('masuk sini ga');

                  }
                  return Column(
                    children: [
                      CustomTextField(
                        controller: _controller,
                        label: widget.detail == 'category'
                            ? 'Category Name'
                            : widget.detail == 'deck'
                                ? 'Deck Name'
                                : 'Card Name',
                        hintText: widget.detail == 'category'
                            ? 'Enter category name'
                            : widget.detail == 'deck'
                                ? "Enter deck's name"
                                : "Enter card's name",
                        isIcon: false,
                        errorText: isNamePicked == null || isNamePicked!
                            ? null
                            : widget.detail == 'category'
                                ? 'Category name must be filled'
                                : widget.detail == 'deck'
                                    ? 'Deck name must be filled'
                                    : 'Card name must be filled',
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: CustomSubTitle2(
                            text: 'Cover Image',
                            textColor: AppColors.text,
                          )),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                          child: image != null
                              ? imageURL.toString().substring(0, 4) != 'http'
                                  ? Image.file(image!)
                                  : Image.network(image!.path)
                              : Image.asset('asset/image.png'),
                          width: double.infinity,
                          // constraints: BoxConstraints(minHeight: 50),
                          height: 170,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: isImagePicked == null || isImagePicked!
                                    ? AppColors.text
                                    : AppColors.danger,
                                width: 1),
                            borderRadius: BorderRadius.circular(10),
                          )),
                      // isImagePicked ?
                      SizedBox(
                        height: 20,
                      ),
                      image == null
                          ? GestureDetector(
                              onTap: () async {
                                try {
                                  File? selectedImage = await getImage();
                                  print('imagenya null, lagi di select');

                                  setState(() {
                                    // print('bisa nih');

                                    image = selectedImage;
                                    // print(image!.uri);
                                    print('ini image dari get : ' +
                                        image!.toString());
                                    imageURL = image!.path;

                                    if (imageURL.toString().length > 20) {
                                      imageURL = imageURL
                                              .toString()
                                              .substring(0, 10) +
                                          '...' +
                                          imageURL.toString().substring(
                                              imageURL.toString().length - 10,
                                              imageURL.toString().length);
                                    }
                                    // print(imageURL);
                                    // print('ini image pathnya: ' + image!.path);
                                    isImagePicked = true;
                                  });
                                } catch (e) {
                                  isImagePicked = false;
                                  print('Error image: $e');
                                }
                              },
                              child: Container(
                                  // color: placeholder,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(top: 12, bottom: 12),
                                    child: Column(
                                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Image.asset('asset/Upload.png'),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        CustomDesc(
                                          text: 'Upload image ratio 300x300 px',
                                          textColor: AppColors.gray,
                                        ),
                                        CustomDesc(
                                          text: 'format JPG or PNG',
                                          textColor: AppColors.gray,
                                        ),
                                      ],
                                    ),
                                  ),
                                  width: double.infinity,
                                  // constraints: BoxConstraints(minHeight: 50),
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: AppColors.bg_placeholder,
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                            )
                          : Container(
                              width: double.infinity,
                              height: 45,
                              decoration: BoxDecoration(
                                color: AppColors.bg_placeholder,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomDesc(
                                        text: imageURL,
                                        textColor: AppColors.gray),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isImagePicked = true;
                                          image = null;
                                          // imageURL = null;
                                        });
                                      },
                                      child: Image.asset(
                                        'asset/Delete.png',
                                        width: 20,
                                        height: 20,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                      if (widget.detail == 'card')
                        Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Align(
                                alignment: AlignmentDirectional.centerStart,
                                child: Row(
                                  children: [
                                    CustomSubTitle2(
                                      text: 'Audio',
                                      textColor: AppColors.text,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    CustomTextPlaceholder(
                                        text: '(Optional)',
                                        textColor: AppColors.gray)
                                  ],
                                )),
                            SizedBox(
                              height: 10,
                            ),
                            audio == null
                                ? GestureDetector(
                                    onTap: () async {
                                      try {
                                        File? selectedAudio = await getFile();
                                        print('bisa kesini si audio');

                                        setState(() {
                                          print('bisa nih audio');

                                          audio = selectedAudio;
                                          print('ini audio pathnya: ' +
                                              audio!.path);

                                          audioURL = audio!.path;
                                          fullAudioURL = audioURL;

                                          if (audioURL.toString().length > 20) {
                                            audioURL = audioURL
                                                    .toString()
                                                    .substring(0, 10) +
                                                '...' +
                                                audioURL.toString().substring(
                                                    audioURL.toString().length -
                                                        10,
                                                    audioURL.toString().length);
                                          }
                                          print('audio url ' + audioURL);

                                          isAudioPicked = true;
                                        });
                                      } catch (e) {
                                        isAudioPicked = false;
                                        print('Error 2: $e');
                                      }
                                    },
                                    child: Container(
                                        // color: placeholder,

                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: 25, bottom: 20),
                                          child: Column(
                                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Image.asset('asset/Upload.png'),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              CustomDesc(
                                                text:
                                                    'Upload audio format .wav or .mp3',
                                                textColor: AppColors.gray,
                                              )
                                            ],
                                          ),
                                        ),
                                        width: double.infinity,
                                        // constraints: BoxConstraints(minHeight: 50),
                                        height: 100,
                                        decoration: BoxDecoration(
                                          color: AppColors.bg_placeholder,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        )),
                                  )
                                : Column(
                                  children: [
                                    Container(
                                        width: double.infinity,
                                        height: 45,
                                        decoration: BoxDecoration(
                                          color: AppColors.bg_placeholder,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, right: 20),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              CustomDesc(
                                                  text: audioURL,
                                                  textColor: AppColors.gray),
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    isAudioPicked = true;
                                                    audio = null;
                                                  });
                                                },
                                                child: Image.asset(
                                                  'asset/Delete.png',
                                                  width: 20,
                                                  height: 20,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 20,),
                                      GestureDetector(
                                        onTap: (){
                                          setState(() {
                                            print(fullAudioURL);
                                            playAudio(fullAudioURL);
                                          });
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          height: 45,
                                          decoration: BoxDecoration(
                                            color: AppColors.bg,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20, right: 20),
                                            child: Center(
                                              child: Image.asset('asset/playsound.png'),
                                            )
                                          ),
                                        ),
                                      ),
                                      
                                  ],
                                ),
                          ],
                        ),
                      // else
                      //   SizedBox(),
                      // Spacer(),
                      // SizedBox(height: 90,),
                      SizedBox(
                        height: 20,
                      ),
                      if (widget.isEdit != null)
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: AppColors.white,
                                  contentPadding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  title: Center(
                                    child: CustomTitle(
                                      text:
                                          "Are you sure you to remove $detail ${widget.detail}?",
                                      textColor: AppColors.text,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        if (widget.detail == 'category') {
                                          deleteCategory(
                                              widget.id!, widget.token);
                                          showTopSnackBar(context,
                                              '$detail ${widget.detail} removed');
                                          Navigator.pushReplacement(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return HomePage(
                                              token: widget.token,
                                            );
                                          }));
                                        } else if (widget.detail == 'deck') {
                                          deleteDeck(widget.id!, widget.token);
                                          showTopSnackBar(context,
                                              "$detail ${widget.detail} removed");
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          Navigator.pop(context, true);
                                        } else if (widget.detail == 'card') {
                                          deleteCard(widget.id!, widget.token);
                                          showTopSnackBar(context,
                                              '$detail ${widget.detail} removed');
                                          Navigator.pop(context, true);
                                          Navigator.pop(context, true);
                                        }
                                      },
                                      child: CustomSubTitle(
                                        text: "Yes Remove",
                                        textColor: AppColors.danger,
                                      ),
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                AppColors.white),
                                        foregroundColor:
                                            MaterialStateProperty.all(
                                                AppColors.danger),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            side: BorderSide(
                                                color: AppColors.danger),
                                          ),
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: CustomSubTitle(
                                        text: "Cancel",
                                        textColor: AppColors.white,
                                      ),
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                AppColors.text),
                                        foregroundColor:
                                            MaterialStateProperty.all(
                                                AppColors.white),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            side: BorderSide(
                                                color: AppColors.text),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'asset/Delete.png',
                                width: 24,
                                height: 24,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              CustomTextPlaceholder(
                                  text: 'Remove ' + widget.detail,
                                  textColor: AppColors.danger)
                            ],
                          ),
                        ),

                      Expanded(
                        child: Align(
                          alignment: AlignmentDirectional.bottomCenter,
                          child: CustomButton(
                              onPressed: () async {
                                var id;
                                print(_controller.text);
                                print('audio di post: ' + audio.toString());
                                if (image != null &&
                                    _controller.text.isNotEmpty) {
                                  if (widget.isEdit == null) {
                                    // print('ini image satunya: ' + image!.toString());
                                    // print('ini image satunya: ' + image!.length().toString());
                                    // print(_controller.text);
                                    id = widget.detail == 'category'
                                        ? await postCategory(widget.token,
                                            _controller.text, image!)
                                        : widget.detail == 'deck'
                                            ? await postDeck(
                                                widget.token,
                                                _controller.text,
                                                image!,
                                                widget.id!)
                                            : await postCard(
                                                widget.token,
                                                _controller.text,
                                                image!,
                                                audio,
                                                widget.id!);
                                  } else {
                                    var msg;
                                    // print(audio!.path);
                                    // print('ini image di bawah msg: ' + image!.length().toString());
                                    print(
                                        'ini di pacth : ' + image!.toString());
                                    id = widget.detail == 'category'
                                        ? msg = await patchCategory(
                                            widget.token,
                                            _controller.text,
                                            image!,
                                            widget.id!)
                                        : widget.detail == 'deck'
                                            ? msg = await patchDeck(
                                                widget.token,
                                                _controller.text,
                                                image!,
                                                widget.id!)
                                            : msg = await patchCard(
                                                widget.token,
                                                _controller.text,
                                                image!,
                                                audio,
                                                widget.id!);
                                  }
                                  if (id != null && widget.isEdit == null) {
                                    widget.detail == 'category'
                                        ? Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                            return DetailData(
                                              id: id,
                                              token: widget.token,
                                              detail: widget.detail,
                                            );
                                          }))
                                        : Navigator.pop(context, true);
                                  }
                                  print('masuk');
                                  isImagePicked = true;
                                  isNamePicked = true;
                                  // Navigator.pop(context, true);
                                } else {
                                  print('Gambar atau teks kategori kosong.');

                                  if (image == null) {
                                    setState(() {
                                      isImagePicked = false;
                                    });
                                    if (_controller.text.isNotEmpty) {
                                      setState(() {
                                        isNamePicked = true;
                                      });
                                    }

                                    print('image blm di pick bang');
                                  }
                                  if (_controller.text.isEmpty) {
                                    setState(() {
                                      isNamePicked = false;
                                    });
                                    if (image != null) {
                                      setState(() {
                                        isImagePicked = true;
                                      });
                                    }
                                    print('namenya blm');
                                  }
                                }
                              },
                              text: widget.isEdit != null
                                  ? 'Save Changes'
                                  : 'Save'),
                        ),
                      )
                    ],
                  );
                }
              }),
        ),
      ),
    );
  }
}
