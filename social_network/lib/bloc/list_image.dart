import 'dart:async';

class ListImageBloc{
  final listStreamController = StreamController<List<String>>();
  Stream<List<String>> get stream => listStreamController.stream;
  final List<String> listImage = [];

  void addImage(String url){
    listImage.add(url);
    listStreamController.add(listImage);
  }

  void removeImage(String url){
    listImage.remove(url);
    listStreamController.add(listImage);
  }
}