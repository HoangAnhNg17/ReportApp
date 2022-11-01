import 'package:social_network/model/Content.dart';
import 'package:social_network/service/api_service.dart';

extension ContentService on APIService {
  Future<List<Content>> getContent({
    int limit = 10,
    required int offset,
  }) async {
    final result = await request(
      path: '/api/issues?limit=$limit&offset=$offset',
    );

    final contents = List<Content>.from(result.map((e) => Content.fromJson(e)));
    return contents;
  }

  Future<Content> postContent({
  required String title,
    required String text,
    required String photo,
}) async{
    final body = {
      'Title': title,
      'Content': text,
      'Photos': photo
    };
    final result = await request(path: '/api/issues', method: Method.post, body: body);
    return result;
}
}

