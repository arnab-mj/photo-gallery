import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:photo_gallery/models/file_response.dart';
import 'app_exception.dart';

class ApiBaseHelper {
  Future<dynamic> get(String url) async {
    Response returnResponse;
    try {
      final response = await http.get(Uri.parse(url)).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw FetchDataException('Request timeout');
        },
      );
      returnResponse = Response(_returnResponse(response), response.statusCode, response.headers);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return returnResponse;
  }

  Future<FileResponse> getFile(String url) async {
    FileResponse responseJson;

    try {
      final response = await http.get(Uri.parse(url));

      List<String> tokens = response.headers['content-disposition']?.split(";") ?? [];
      
      String filename = '';
      for (var i = 0; i < tokens.length; i++) {
        if (tokens[i].contains('filename')) {
          filename = tokens[i].substring(tokens[i].indexOf('"') + 1, tokens[i].lastIndexOf('"'));
          break;
        }
      }

      responseJson = FileResponse(fileBytes: response.bodyBytes, filename: filename);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        if (response.body.isNotEmpty) {
          return response.body;
        }
        return '';
      case 204: // No Content
      case 302: // Found
        return '';
      case 400:
      case 401:
      case 403:
      case 404:
      case 500:
        throw BadRequestException(response.body);
      default:
        throw FetchDataException('Network error. StatusCode : ${response.statusCode}');
    }
  }
}

class Response<T> {
  T body;
  int statusCode;
  Map<String, dynamic> headers;

  Response(this.body, this.statusCode, this.headers);
}
