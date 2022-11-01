import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_network/bloc/list_image.dart';
import 'package:social_network/common/widgets/toastOverlay.dart';
import 'package:social_network/module/newsfeed_page.dart';
import 'package:social_network/service/content_service.dart';
import 'package:social_network/service/photo_service.dart';
import '../common/const.dart';
import '../common/widgets/widgets.dart';
import '../service/api_service.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  var url = '';
  final picker = ImagePicker();
  final list = ListImageBloc();
  String photos = '';

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ReportPage'),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: StreamBuilder(
          stream: list.stream,
          builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                    controller: titleController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: Colors.grey.shade300,
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                    enableSuggestions: true,
                    autocorrect: false,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    height: 5 * 24.0,
                    child: TextField(
                      controller: contentController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        labelText: 'Content',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            color: Colors.grey.shade300,
                          ),
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      enableSuggestions: true,
                      autocorrect: false,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 3 / 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10
                        ),
                        itemCount: list.listImage.length + 1,
                        itemBuilder: (context, index) {
                          if (index == list.listImage.length) {
                            return GestureDetector(
                              onTap: () {
                                selectImage(source: ImageSource.gallery);
                              },
                              child: Image.asset('assets/image/add.png'),
                            );
                          }
                          return buildImage(list.listImage[index]);
                        }
                    ),
                  ),
                  const SizedBox(height: 20,),
                  BuildButton(
                      text: 'Save', enabled: true, context: context, onTap: () {
                    postContent();
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                        builder: (context) => const NewsfeedPage()), (
                        route) => false);
                  }),
                ],
              ),
            );
          }
        ),
      ),
    );
  }

  Widget buildImage(String urlImg) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey.shade100,
          ),
          child: CachedNetworkImage(
            imageUrl: urlImg,
            fit: BoxFit.fill,
            placeholder: (context, url) =>
            const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          )
          ,
        ),
        Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: (){
                list.removeImage(urlImg);
              },
              child: Container(
                height: 25,
                width: 25,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
                child: const Icon(Icons.remove, color: Colors.white,),
              ),
            )
        ),
      ]
      ,
    );
  }

  Future selectImage({required ImageSource source}) async {
    try {
      final image = await picker.pickImage(
        source: source,
        preferredCameraDevice: CameraDevice.front,
        imageQuality: 10,
      );

      if (image != null) {
        url = '';
        await upload(image);
        if (url != '') {
          list.addImage(url);
        }
      }
    } catch (e) {
      ToastOverlay(context).showToastOverlay(
          message: e.toString(), type: ToastType.error);
    }
  }

  Future<void> upload(XFile f) async {
    await apiService.uploadAvatar(file: f).then((value) {
      // setState(() {
      //   url = '$baseUrl${value.path}';
      // });
      url = '$baseUrl${value.path}';
    }).catchError((e) {
      ToastOverlay(context).showToastOverlay(
          message: e.toString(), type: ToastType.error);
    });
  }

  void postContent() {
    for (int i = 0; i < list.listImage.length; i++) {
      photos = '$photos${list.listImage[i]}|';
    }
    if (list.listImage.isNotEmpty) {
      photos = photos.substring(0, photos.length - 1);
    }
    apiService.postContent(title: titleController.text,
        text: contentController.text,
        photo: photos).then((value) {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => const NewsfeedPage()), (
              route) => false);
    }).catchError((e) {
      ToastOverlay(context).showToastOverlay(
          message: e.toString(), type: ToastType.error);
    });
  }
}
