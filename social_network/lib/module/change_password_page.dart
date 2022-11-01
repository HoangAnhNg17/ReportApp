import 'package:flutter/material.dart';
import 'package:social_network/common/widgets/toastOverlay.dart';
import 'package:social_network/module/login_page.dart';
import 'package:social_network/service/api_service.dart';
import 'package:social_network/service/user_service.dart';
import '../common/shared_preferences_manager.dart';
import '../common/widgets/widgets.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    controller: oldPasswordController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Old Password',
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
                  TextField(
                    controller: newPasswordController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'New Password',
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
                ],
              ),
            ),
            BuildButton(
              text: 'Save',
              enabled: true,
              context: context,
              onTap: () {
                changePassword();
              },
            ),
            const SizedBox(height: 40,)
          ],
        ),
      ),
    );
  }

  Future<void> changePassword() async {
    final phoneKey = await sharedPrefs.getString('phoneKey');
    sharedPrefs.remove('phoneKey');
    sharedPrefs.remove('passwordKey');
    sharedPrefs.remove('APIToken');
    apiService
        .changePassword(
      oldPassword: oldPasswordController.text,
      newPassword: newPasswordController.text,
    )
        .then((value) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => LoginPage(
                    phone: phoneKey ?? '',
                    password: '',
                  )),
          (route) => false);
    }).catchError((e) {
      ToastOverlay(context)
          .showToastOverlay(message: e.toString(), type: ToastType.error);
    });
  }
}
