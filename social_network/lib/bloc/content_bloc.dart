import 'dart:async';
import 'package:social_network/model/Content.dart';
import 'package:social_network/service/api_service.dart';
import 'package:social_network/service/content_service.dart';

class ContentBloc{

  // final _countStreamController = StreamController<int>();
  // Stream<int> get stream => _countStreamController.stream;
  // StreamSink<int> get sink => _countStreamController.sink;

  final _contentStreamController = StreamController<List<Content>>();
  Stream<List<Content>> get streamContent => _contentStreamController.stream;

  final contents = <Content>[];
  int count = 0;

  ContentBloc(){
    getContents();
  }

  // void increment(){
  //   count++;
  //   sink.add(count);
  // }

  // void autoIncrement(){
  //   Timer.periodic(const Duration(seconds: 1), (timer) {
  //     increment();
  //   });
  // }

  Future<void> getContents({bool isClear = false}) async{
    await apiService.getContent(offset: isClear ? 0 : contents.length).then((value){
      if(isClear){
        contents.clear();
        _contentStreamController.add(contents);
      }
      if(value.isNotEmpty){
        contents.addAll(value);
        _contentStreamController.add(contents);
      }
    }).catchError((e){
      _contentStreamController.addError(e.toString());
    });
  }

}