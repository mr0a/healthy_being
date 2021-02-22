import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HttpService {
  static final String createUserUrl =
      "https://djangowebdev.herokuapp.com/api/user/create";
  // "http://10.0.2.2:8000/api/user/create/";

  static final String signInUrl =
      "https://djangowebdev.herokuapp.com/api/token/create";
  // final String accessToken = "http://127.0.0.1:8000/api/token/refresh/";

  static final String accessTokenUrl =
      "https://djangowebdev.herokuapp.com/api/token/refresh/";
  static final String verifyRefreshTokenUrl =
      "https://djangowebdev.herokuapp.com/api/token/verify";

  static final String userDataUrl = "http://10.0.2.2:8000/api/user/data";

  static final storage = FlutterSecureStorage();

  static Future<String> getData() async {
    Response response = await get(Uri.parse(userDataUrl));
    print(response.body);
    sleep(Duration(milliseconds: 10));
    return response.body;
  }

  Future<Map<String, dynamic>> createUser(String email, String password) async {
    Response response = await post(
      Uri.parse(createUserUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    print(response.body);
    if (response.statusCode == 201) {
      return {'msg': 'Account Created Successfully', 'error': false};
    }
    String res = jsonDecode(response.body)['email'][0];
    return {'msg': res, 'error': true};
  }

  Future<Map<String, dynamic>> signInUser(String email, String password) async {
    Response response = await post(Uri.parse(signInUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }));
    // print(response.body);
    return jsonDecode(response.body);
  }

  static Future<bool> getAccessToken(String refresh) async {
    Response response = await post(Uri.parse(accessTokenUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'refresh': refresh,
        }));

    Map<String, dynamic> json = jsonDecode(response.body);

    if (json.containsKey('access')) {
      // print(json['access']);
      storage.write(key: 'accessToken', value: json['access']);
      return true;
    } else {
      await storage.deleteAll();
      return false;
    }
  }

  // Future<Map<String, String>> verifyRefreshToken(
  //     String refresh, BuildContext context) async {
  //   Response response = await post(Uri.parse(verifyRefreshTokenUrl),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8',
  //       },
  //       body: jsonEncode(<String, String>{
  //         'token': refresh,
  //       }));

  //   Map<String, dynamic> json = jsonDecode(response.body);

  //   if (json.containsKey('access')) {
  //     print(json['access']);
  //     return json;
  //   } else {
  //     storage.deleteAll();
  //     return {'expired': 'true'};
  //   }
  // }
}

void main() {
  // var hel = HttpService();
  // var res = hel.createUser('demo@demo.com', '0000');
  // hel.createAlbum('demo');
}
