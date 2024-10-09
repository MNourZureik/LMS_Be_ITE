import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:public_testing_app/src/models/Themes.dart';

class Api {
  static String public_url = "http://10.0.2.2:8000";

  static get_request(String Url) async {
    final response = await http.get(
      Uri.parse('$public_url/api/$Url'),
      headers: {
        "Authorization": "Bearer ${Themes.getUserToken()}",
        "Accept": "application/json",
        "Content-Type": "application/json"
      },
    );

    final decodedResponse = json.decode(response.body);
    return decodedResponse;
  }

  static post_request_with_token_using_json(String Url, Object Body) async {
    final jsonData = json.encode(Body);
    final response = await http.post(
      Uri.parse('$public_url/api/$Url'),
      headers: {
        "Authorization": "Bearer ${Themes.getUserToken()}",
      },
      body: jsonData,
    );
    final decodedResponse = json.decode(response.body);
    return decodedResponse;
  }

  static post_request_with_token(String Url, Object Body) async {
    final response = await http.post(
      Uri.parse('$public_url/api/$Url'),
      headers: {
        "Authorization": "Bearer ${Themes.getUserToken()}",
      },
      body: Body,
    );
    final decodedResponse = json.decode(response.body);
    return decodedResponse;
  }

  static post_request_without_token(String Url, Object Body) async {
    final response = await http.post(
      Uri.parse('$public_url/api/$Url'),
      body: Body,
    );
    final decodedResponse = json.decode(response.body);
    return decodedResponse;
  }

  static post_request_with_files(String Url, Map<String, String>? Body,
      String field, String filePath) async {
    final request =
        http.MultipartRequest('POST', Uri.parse('$public_url/api/$Url'));
    request.files.add(
      await http.MultipartFile.fromPath(field, filePath),
    );

    //? You might need to include an Authorization header with the student's token
    request.headers['Authorization'] = "Bearer ${Themes.getUserToken()}";

    if (Body != null) {
      request.fields.addAll(Body);
    }

    final response = await request.send();
    return response;
  }
}
