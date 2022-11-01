import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:social_network/common/const.dart';

class APIService {
  static final _service = APIService._internal();

  factory APIService() => _service;
  String token = "";

  APIService._internal();

  Future request({
    Method method = Method.get,
    required String path,
    Map<String, dynamic>? body,
    XFile? file,
  }) async {
    final uri = Uri.parse(baseUrl + path);
    http.Response response;
    final headers = {
      'Authorization': 'Bearer $token',
    };
    if (file != null) {
      final request = http.MultipartRequest('POST', uri);
      request.headers.addAll(headers);
      request.files.add(http.MultipartFile.fromBytes(
        'file',
        await file.readAsBytes(),
        filename: 'a.jpg',
      ));
      final stream = await request.send();
      response = await http.Response.fromStream(stream);
    } else {
      switch (method) {
        case Method.get:
          response = await http.get(uri, headers: headers);
          break;
        case Method.put:
          response =
          await http.put(uri, headers: headers, body: body, encoding: utf8);
          break;
        case Method.delete:
          response = await http.delete(uri,
              headers: headers, body: body, encoding: utf8);
          break;
        default:
          response = await http.post(uri,
              headers: headers, body: body, encoding: utf8);
          break;
      }
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final json = jsonDecode(response.body);

      if (json['code'] == 0) {
        // map, dictionary, key:value
        final data = json['data'];
        return data;
      } else {
        throw Exception(json['message']);
      }
    }
    throw Exception('Có lỗi xảy ra, http status code: ${response.statusCode}');
  }
}

final apiService = APIService();

enum Method { get, post, put, delete }