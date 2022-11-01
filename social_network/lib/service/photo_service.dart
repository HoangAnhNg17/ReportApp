import 'package:image_picker/image_picker.dart';
import 'package:social_network/service/api_service.dart';

import '../model/photo.dart';

extension PhotoService on APIService {
  Future<Photo> uploadAvatar({
    required XFile file
  }) async {
    final result  = await request(path: '/api/upload',file: file);
    final photo = Photo.fromJson(result);

    return photo;
  }



}