import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:photo_gallery/network/endpoints.dart';
import 'app_exception.dart';

class ApiBaseHelper {
  final String _baseUrl = Endpoints.baseURL;

  Future<dynamic> get(String url) async {
    Response returnResponse;
    try {
      final response = await http.get(Uri.parse(_baseUrl + url)).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw FetchDataException('Request timeout');
        },
      );
      returnResponse = Response(_returnResponse(response), response.statusCode);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return returnResponse;
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

  Response(this.body, this.statusCode);
}
