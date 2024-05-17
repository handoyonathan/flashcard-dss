import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

String api = 'https://c2cb-112-215-224-194.ngrok-free.app/';
// String api = 'http://localhost:5050/';

class CardModel {
  final String id, name, imageName, imageUrl, deckId;
  final String? audioName, audioUrl;

  const CardModel(
      {required this.id,
      required this.name,
      required this.imageName,
      required this.imageUrl,
      required this.deckId,
      this.audioName,
      this.audioUrl});

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
        id: json['id'],
        name: json['name'],
        imageName: json['imagefilename'],
        imageUrl: json['image_card_url'],
        audioName: json['audiofilename'],
        audioUrl: json['audio_card_url'],
        deckId: json['deck_id']);
  }
}

final dio = Dio();

Future<List<CardModel>> fetchAllCard(String token, String deckId) async {
  try {
    dio.options.headers['Authorization'] = 'Bearer $token';

    final response = await dio.get('${api}card/$deckId');

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data['Cards'];
      final List<CardModel> cards =
          data.map((categoryJson) => CardModel.fromJson(categoryJson)).toList();
      return cards;
    } else {
      throw Exception('Failed to get data: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
    throw Exception('Failed to fetch data: $e');
  }
}

Future<CardModel> fetchOneCard(String token, String id) async {
  try {
    dio.options.headers['Authorization'] = 'Bearer $token';

    final response = await dio.get('${api}card/get/$id');

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = response.data['card'];

      return CardModel.fromJson(data);
    } else {
      throw Exception('Failed to get data: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
    throw Exception('Failed to fetch data: $e');
  }
}

Future<String?> postCard(String token, String text, File imageFile,
    File? audioFile, String id) async {
  try {
    print('masuk ke dio card');
    dio.options.headers['Authorization'] = 'Bearer $token';
    FormData formData = FormData.fromMap({
      'name': text,
      'file': await MultipartFile.fromFile(
        imageFile.path,
      ),
      if (audioFile != null)
        'audio': await MultipartFile.fromFile(
          audioFile.path,
        ),
    });
    Response response = await dio.post('${api}card/$id', data: formData);

    if (response.statusCode == 200) {
      print('Data udah masuk card');
      Map<String, dynamic> responseBody = response.data;
      String cardId = responseBody['cardId'];

      print('Data udah masuk. card ID: $cardId');
      return cardId;
    } else {
      print('Gagal kirim data');
    }
  } catch (error) {
    print('Error: $error');
  }
  return null;
}

Future<void> deleteCard(String id, String token) async {
  try {
    dio.options.headers['Authorization'] = 'Bearer $token';

    final response = await dio.delete('${api}card/$id');

    if (response.statusCode == 200) {
      print('Card deleted successfully');
    } else {
      throw Exception('Failed to delete card: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
    throw Exception('Failed to delete card: $e');
  }
}

Future<File> downloadFile(String url) async {
  final response = await http.get(Uri.parse(url));
  final documentDirectory = await getTemporaryDirectory();
  final file = File('${documentDirectory.path}/temp_image.jpg');
  await file.writeAsBytes(response.bodyBytes);
  return file;
}

Future<String?> patchCard(String token, String text, File imageFile,
    File? audioFile, String id) async {
  try {

    dio.options.headers['Authorization'] = 'Bearer $token';
    FormData formData;
    dynamic tempImage;
    dynamic tempAudio;

    if (imageFile.path.substring(0, 4) != 'http') {
      tempImage = await MultipartFile.fromFile(imageFile.path);
    } else {
      dynamic temp = await downloadFile(imageFile.path);
      tempImage = await MultipartFile.fromFile(temp.path);
    }

    if (audioFile != null) {
      if (audioFile.path.substring(0, 4) != 'http') {
        tempAudio = await MultipartFile.fromFile(audioFile.path);
      } else {
        dynamic temp = await downloadFile(audioFile.path);
        tempAudio = await MultipartFile.fromFile(temp.path);
      }
    }

    // print(tempAudio);

    formData = FormData.fromMap({
      'name': text,
      'file': tempImage,
      // if (audioFile != null)
        'audio': tempAudio,
    });

    Response response = await dio.patch('${api}card/$id', data: formData);

    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = response.data;
      String msg = responseBody['message'];

      return msg;
    } else {
      print('Gagal update data');
    }
  } catch (error) {
    print('Error patch card: $error');
  }
  return null;
}

Future<int> fetchCardCount(String token, String id) async {
  try {
    List<CardModel> card = await fetchAllCard(token, id);
    // int count = decks.length;
    return card.length;
  } catch (error) {
    print('Error fetching card count: $error');

    return 0;
  }
}
