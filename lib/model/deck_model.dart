import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

String api = 'https://2aac-112-215-226-99.ngrok-free.app/';
// String api = 'http://localhost:5050/';

class DeckModel {
  final String id, name, fileName, imageUrl, categoryId;

  const DeckModel(
      { required this.id,
        required this.name,
        required this.fileName,
        required this.imageUrl,
        required this.categoryId});

  factory DeckModel.fromJson(Map<String, dynamic> json) {
    return DeckModel(
        id: json['id'],
        name: json['name'],
        fileName: json['filename'],
        imageUrl: json['image_cover_url'],
        categoryId: json['category_id']
        );
  }
}

final dio = Dio();

Future<List<DeckModel>> fetchAllDeck(String token, String categoryId) async {
  try {
    dio.options.headers['Authorization'] = 'Bearer $token';

    final response = await dio.get('${api}deck/$categoryId');

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data['Decks'];
      final List<DeckModel> decks = data
          .map((categoryJson) => DeckModel.fromJson(categoryJson))
          .toList();
      return decks;
    } else {
      throw Exception('Failed to get data: ${response.statusCode}');
    }


  } catch (e) {
    print('Error: $e');
    throw Exception('Failed to fetch data: $e');
  }
}


Future<DeckModel>fetchOneDeck(String token, String id) async {
  try {
    dio.options.headers['Authorization'] = 'Bearer $token';

    final response = await dio
        .get('${api}deck/get/$id');

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = response.data['deck'];
      // final List<CategoryModel> categories = data
      //     .map((categoryJson) => CategoryModel.fromJson(categoryJson))
      //     .toList();
      
      return DeckModel.fromJson(data);
    } else {
      throw Exception('Failed to get data: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
    throw Exception('Failed to fetch data: $e');
  }
}

Future<String?> postDeck(String token, String text, File imageFile, String id) async {
  try {
    dio.options.headers['Authorization'] = 'Bearer $token';
    FormData formData = FormData.fromMap({
      'name': text,
      'file': await MultipartFile.fromFile(
        imageFile.path,
      ),
    });
    Response response = await dio.post(
        '${api}deck/$id',
        data: formData);

    if (response.statusCode == 200) {
      print('Data udah masuk');
      Map<String, dynamic> responseBody = response.data;
      String deckId = responseBody['deckId'];

      print('Data udah masuk. Deck ID: $deckId');
      return deckId;
    } else {
      print('Gagal kirim data');
    }
  } catch (error) {
    print('Error: $error');
  }
  return null;
}


Future<int> fetchDeckCount(String token, String categoryId) async {
  try {

    List<DeckModel> decks = await fetchAllDeck(token, categoryId);
    // int count = decks.length;
    return decks.length;
  } catch (error) {
    print('Error fetching deck count: $error');

    return 0;
  }
}

Future<void> deleteDeck(String id, String token) async {
  try {
    dio.options.headers['Authorization'] = 'Bearer $token';

    final response = await dio.delete('${api}deck/$id');

    if (response.statusCode == 200) {
      print('Deck deleted successfully');
    } else {
      throw Exception('Failed to delete deck: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
    throw Exception('Failed to delete deck: $e');
  }
}

Future<String?> patchDeck(String token, String text, File imageFile, String id) async {
  try {
    dio.options.headers['Authorization'] = 'Bearer $token';
    FormData formData;

    if (imageFile.path.substring(0,4) != 'http') {
      formData = FormData.fromMap({
        'name': text,
        'file': await MultipartFile.fromFile(
          imageFile.path,
        ),
      });
    } else {
      File tempFile = await downloadFile(imageFile.path);
      formData = FormData.fromMap({
        'name': text,
        'file': MultipartFile.fromFile(tempFile.path),
      });
    } 
    Response response = await dio.patch(
        '${api}deck/$id',
        data: formData);

    if (response.statusCode == 200) {
      print('Data udah update');
      Map<String, dynamic> responseBody = response.data;
      String msg = responseBody['message'];

      return msg;
    } else {
      print('Gagal update data');
    }

    
  } catch (error) {
    print('Error: $error');
  }
  return null;
}

Future<File> downloadFile(String url) async {
  final response = await http.get(Uri.parse(url));
  final documentDirectory = await getTemporaryDirectory();
  final file = File('${documentDirectory.path}/temp_image.jpg');
  await file.writeAsBytes(response.bodyBytes);
  return file;
}