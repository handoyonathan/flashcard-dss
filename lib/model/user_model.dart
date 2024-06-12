import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:async';

import 'package:image_picker/image_picker.dart';

String api = 'https://2aac-112-215-226-99.ngrok-free.app/';
// String api = 'http://localhost:5050/';

class User {
  final String token, id;
  // final String email, password;

  User({
    required this.id,
    required this.token,
    // required this.email,
    // required this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      token: json['token'],
      id: json['userId'],
      // email: json['email'],
      // password: json['password'],
    );
  }
}

final dio = Dio();

Future<bool> storeAccount(
    String email, String password, String confirmPassword) async {
  try {
    final dio = Dio();
    final response = await dio.post(
      '${api}register',
      data: {
        'email': email,
        'password': password,
        'confirmPassword': confirmPassword,
      },
    );

    print(response.statusCode);
    final responseData = response.data;
    print(responseData);

    if (response.statusCode == 201) {
      print('akunnya dah terdaftar');
      // final user = User.fromJson(responseData);
      // _showPopUp(context, user.message);
      // Navigator.pop(context);

      // print(user.message);
      print(email);
      print(password);
      print(confirmPassword);
      // print(user.email);
      // print(user.id);
      // print(user.password);
      // print(user.token);
      return true;
    } else {}
  } catch (e) {
    print('Error: $e');
  }

  return false;
}

Future<String?> verifyCredentials(String email, String password) async {
  try {
    final response = await dio.post(
      '${api}login',
      data: {
        'email': email,
        'password': password,
      },
    );

    print('ini codenya' + response.statusCode.toString());
    final responseData = response.data;
    print(responseData);

    // final user = User.fromJson(responseData);
    // print(email);
    //   print(password);
    //   print(user.email);
    //   print(user.password);

    if (response.statusCode == 200) {
      print('masuk ga');
      final user = User.fromJson(responseData);
      // print('masuk ga');

      print(email);
      print(password);
      print(user.id);
      print(user.token);
      return user.token;
    } else {
      print('hm');
    }
  } catch (e) {
    print('Error: $e');
  }
  return null;
}

Future<File> getImage() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    return File(pickedFile.path);
  }
  throw Exception('Gagal mengambil gambar');
}

Future<File> getFile() async {
  print('audio awal');
  final result = await FilePicker.platform
      .pickFiles(type: FileType.custom, allowedExtensions: ['mp3', 'wav']);
  print('audio bisa kesini');
  if (result != null) {
    final filePath = result.files.single.path!;
    print('di model audionya: ' + filePath);
    return File(filePath);
  }
  throw Exception('Gagal mengambil file');
}

Future<String?> forgotPassword(String email) async {
  try {
    final response = await dio.post(
      '${api}forgotpassword',
      data: {
        'email': email,
      },
    );

    print('ini codenya' + response.statusCode.toString());
    final responseData = response.data;
    print(responseData);

    // final user = User.fromJson(responseData);
    // print(email);
    //   print(password);
    //   print(user.email);
    //   print(user.password);

    if (response.statusCode == 200) {
      print('masuk ga');
      final user = User.fromJson(responseData);
      // print('masuk ga');

      print(email);
      return user.token;
    } else {
      print('hm');
    }
  } catch (e) {
    print('Error: $e');
  }
  return null;
}

Future<String?> newPassword(String token, String pw, String confirmPw) async {
  try {
    final response = await dio.post(
      '${api}newpassword',
      data: {
        "tokenEmail": token,
        "newPassword": pw,
        "confirmNewPassword": confirmPw
      },
    );

    print('ini codenya' + response.statusCode.toString());
    final responseData = response.data;
    print(responseData);

    // final user = User.fromJson(responseData);
    // print(email);
    //   print(password);
    //   print(user.email);
    //   print(user.password);

    if (response.statusCode == 200) {
      print('masuk ga');
      final user = User.fromJson(responseData);
      // print('masuk ga');

      // print(email);
      return user.token;
    } else {
      print('hm');
    }
  } catch (e) {
    print('Error: $e');
  }
  return null;
}
