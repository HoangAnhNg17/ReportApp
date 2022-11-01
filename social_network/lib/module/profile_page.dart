import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_network/common/widgets/widgets.dart';
import 'package:social_network/module/newsfeed_page.dart';
import 'package:social_network/service/photo_service.dart';
import 'package:social_network/service/user_service.dart';
import '../common/const.dart';
import '../common/widgets/toastOverlay.dart';
import '../model/user.dart';
import '../service/api_service.dart';

class ProfilePage extends StatefulWidget {
  final User user;

  const ProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final nameController = TextEditingController();
  final birthController = TextEditingController();
  final addressController = TextEditingController();
  final genderController = TextEditingController();
  final emailController = TextEditingController();
  final picker = ImagePicker();
  var url = '';

  @override
  void initState() {
    url = widget.user.avatar ?? '';
    nameController.text = widget.user.name ?? '';
    birthController.text = widget.user.dateOfBirth ?? '';
    addressController.text = widget.user.address ?? '';
    emailController.text = widget.user.email ?? '';
    if (widget.user.gender == true) {
      genderController.text = 'Nam';
    } else {
      genderController.text = "Nữ";
    }
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    birthController.dispose();
    addressController.dispose();
    genderController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile Page'),
          centerTitle: true,
        ),
        body: GestureDetector(
          onTap: (){
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: height / 3,
                      width: double.infinity,
                      color: Colors.grey.shade100,
                      child: url != ""
                          ? CachedNetworkImage(
                              imageUrl: url,
                              fit: BoxFit.fill,
                            )
                          : Image.asset('assets/image/avatar.png'),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 20,
                        child: GestureDetector(
                          onTap: () {
                            selectImage(source: ImageSource.gallery);
                          },
                          child: Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.red,
                            ),
                            child: GestureDetector(
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                        )),
                    Positioned(
                      left: 20,
                      bottom: 30,
                      child: Text(widget.user.name ?? '',style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                        color: Colors.white,
                      ),),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'PhoneNumber',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5,),
                      Text(
                        widget.user.phoneNumber ?? '',
                        style: TextStyle(color: Colors.grey.shade700,fontSize: 15),
                      ),
                      const SizedBox(height: 5,),
                      const Text(
                        'Name',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextField(
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        textInputAction: TextInputAction.next,
                        controller: nameController,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const Text(
                        'DateOfBirth',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextField(
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        textInputAction: TextInputAction.next,
                        controller: birthController,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const Text(
                        'Address',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextField(
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        controller: addressController,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const Text(
                        'Gender',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextField(
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        controller: genderController,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const Text(
                        'Email',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextField(
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        controller: emailController,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                BuildButton(
                    text: 'Save',
                    enabled: true,
                    context: context,
                    onTap: () {
                      upProfile();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const NewsfeedPage()),
                          (route) => false);
                    }),
              ],
            ),
          ),
        ),
      ),
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
        upload(image);
      }
    } catch (e) {
      ToastOverlay(context)
          .showToastOverlay(message: e.toString(), type: ToastType.error);
    }
  }

  Future<void> upload(XFile f) async {
    await apiService.uploadAvatar(file: f).then((value) {
      setState(() {
        url = '$baseUrl${value.path}';
      });
    }).catchError((e) {
      ToastOverlay(context)
          .showToastOverlay(message: e.toString(), type: ToastType.error);
    });
  }

  Future<void> upProfile() async{
    await apiService
        .updateProfile(
            name: nameController.text,
            email: emailController.text,
            address: addressController.text,
            birth: birthController.text,
            gender: 'true',
            avatar: url)
        .then((value) {
      ToastOverlay(context).showToastOverlay(
          message: 'Đăng bài thành công', type: ToastType.success);
    }).catchError((e) {
      ToastOverlay(context)
          .showToastOverlay(message: e.toString(), type: ToastType.error);
    });
  }
}
