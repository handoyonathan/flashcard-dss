import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

String api = 'https://2aac-112-215-226-99.ngrok-free.app/';
// String api = 'http://localhost:5050/';

class CategoryModel {
  final String id, name, fileName, imageUrl, userId;

  const CategoryModel(
      {required this.id,
      required this.name,
      required this.fileName,
      required this.imageUrl,
      required this.userId});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
        id: json['id'],
        name: json['name'],
        fileName: json['filename'],
        imageUrl: json['image_cover_url'],
        userId: json['user_id']);
  }
}

final dio = Dio();

Future<List<CategoryModel>> fetchAllCategory(String token) async {
  try {
    dio.options.headers['Authorization'] = 'Bearer $token';

    final response =
        await dio.get('${api}category');

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data['categories'];
      final List<CategoryModel> categories = data
          .map((categoryJson) => CategoryModel.fromJson(categoryJson))
          .toList();
      return categories;
    } else {
      throw Exception('Failed to get data: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
    throw Exception('Failed to fetch data: $e');
  }
}

Future<CategoryModel>fetchOneCategory(String token, String id) async {
  try {
    dio.options.headers['Authorization'] = 'Bearer $token';

    final response = await dio
        .get('${api}category/get/$id');

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = response.data['category'];
      // final List<CategoryModel> categories = data
      //     .map((categoryJson) => CategoryModel.fromJson(categoryJson))
      //     .toList();
      
      return CategoryModel.fromJson(data);
    } else {
      throw Exception('Failed to get data: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
    throw Exception('Failed to fetch data: $e');
  }
}

// Future<File> getImage() async {
//   final picker = ImagePicker();
//   final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//   if (pickedFile != null) {
//     return File(pickedFile.path);
//   }
//   throw Exception('Gagal mengambil gambar');
// }

Future<String?> postCategory(String token, String text, File imageFile) async {
  try {
    dio.options.headers['Authorization'] = 'Bearer $token';
    FormData formData = FormData.fromMap({
      'name': text,
      'file': await MultipartFile.fromFile(
        imageFile.path,
      ),
    });
    Response response = await dio.post(
        '${api}category',
        data: formData);

    if (response.statusCode == 200) {
      print('Data udah masuk');
      Map<String, dynamic> responseBody = response.data;
      String categoryId = responseBody['categoryId'];

      print('Data udah masuk. Category ID: $categoryId');
      return categoryId;
    } else {
      print('Gagal kirim data');
    }
  } catch (error) {
    print('Error: $error');
  }
  return null;
}

Future<void> deleteCategory(String categoryId, String token) async {
  try {
    dio.options.headers['Authorization'] = 'Bearer $token';

    final response = await dio.delete('${api}category/$categoryId');

    if (response.statusCode == 200) {
      print('Category deleted successfully');
    } else {
      throw Exception('Failed to delete category: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
    throw Exception('Failed to delete category: $e');
  }
}

Future<String?> patchCategory(String token, String text, File imageFile, String id) async {
  try {
    dio.options.headers['Authorization'] = 'Bearer $token';
    print(imageFile.path);
    print(imageFile.toString().substring(0,4));
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
        '${api}category/$id',
        data: formData);

    if (response.statusCode == 200) {
      print('Data udah update');
      Map<String, dynamic> responseBody = response.data;
      String msg = responseBody['message'];
      print('mesaagenyaa : ' + msg);
      return msg;
    } else {
      print('Gagal update data');
    }
  } catch (error) {
    print('Error di model: $error');
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