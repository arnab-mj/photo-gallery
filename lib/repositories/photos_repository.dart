import 'package:photo_gallery/models/photos_list_response.dart';
import 'package:photo_gallery/network/api_base_helper.dart';
import 'package:photo_gallery/network/endpoints.dart';
import 'package:photo_gallery/utils/app_constant.dart';

class PhotosRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<Response<List<Photo>>> getPhotosList(int pageNumber) async {
    final Response response = await _helper.get('${Endpoints.photoList}/?page=$pageNumber&limit=${AppConstant.photoListLimit}');
    return Response(photoListFromJson(response.body), response.statusCode);
  }
}
