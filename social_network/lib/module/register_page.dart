import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:social_network/common/widgets/toastOverlay.dart';
import 'package:social_network/module/login_page.dart';
import 'package:social_network/service/api_service.dart';
import 'package:social_network/service/user_service.dart';
import '../common/widgets/widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isEnabled = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          height: double.infinity,
          width: double.infinity,
          alignment: Alignment.center,
          padding:
              const EdgeInsets.only(right: 40, top: 100, left: 40, bottom: 20),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color(0xFF73AEF5),
                Color(0xFF61A4F1),
                Color(0xFF478DE0),
                Color(0xFF398AE5),
              ],
              stops: [0.1, 0.4, 0.7, 0.9],
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            // resizeToAvoidBottomInset: false,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Open_Sans',
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Full Name',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Open_Sans',
                        ),
                      ),
                      const SizedBox(height: 7),
                      BuildTextField(
                        controller: _nameController,
                        iconData: Icons.account_balance,
                        hintText: 'Enter your Name',
                        inputType: TextInputType.text,
                        autoFocus: false,
                        isPassword: false,
                        action: TextInputAction.next,
                        onChanged: (_) => validate(),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Phone No',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Open_Sans',
                        ),
                      ),
                      const SizedBox(height: 7),
                      BuildTextField(
                        controller: _phoneController,
                        iconData: Icons.phone_android_rounded,
                        hintText: 'Enter your Phone no',
                        inputType: TextInputType.number,
                        autoFocus: false,
                        isPassword: false,
                        action: TextInputAction.next,
                        onChanged: (_) => validate(),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Email',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Open_Sans',
                        ),
                      ),
                      const SizedBox(height: 7),
                      BuildTextField(
                        controller: _emailController,
                        iconData: Icons.email_outlined,
                        hintText: 'Enter your Email',
                        inputType: TextInputType.emailAddress,
                        autoFocus: false,
                        isPassword: false,
                        action: TextInputAction.next,
                        onChanged: (_) => validate(),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Password',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Open_Sans',
                        ),
                      ),
                      const SizedBox(height: 7),
                      BuildTextField(
                        controller: _passwordController,
                        iconData: Icons.key,
                        hintText: 'Enter your Password',
                        inputType: TextInputType.text,
                        autoFocus: false,
                        isPassword: true,
                        action: TextInputAction.done,
                        onChanged: (_) => validate(),
                      ),
                      const SizedBox(
                        height: 45,
                      ),
                    ],
                  ),
                  BuildButton(
                      text: 'REGISTER',
                      enabled: isEnabled,
                      context: context,
                      onTap: () {
                        register();
                      }),
                  const SizedBox(
                    height: 30,
                  ),
                  RichText(
                    text: TextSpan(
                        style: const TextStyle(fontFamily: 'Open_Sans'),
                        children: [
                          TextSpan(
                              text: ("Have an Account ? "),
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                              )),
                          TextSpan(
                              text: 'Sign in',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.of(context).pop();
                                }),
                        ]),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> register() async {
    apiService
        .register(
      name: _nameController.text,
      phone: _phoneController.text,
      email: _emailController.text,
      password: _passwordController.text,
    )
        .then((value) {
      ToastOverlay(context).showToastOverlay(
          message: 'Đăng ký thành công', type: ToastType.success);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => LoginPage(
                  phone: _phoneController.text,
                  password: '')),
          (route) => false);
    }).catchError((e) {
      ToastOverlay(context)
          .showToastOverlay(message: e.toString(), type: ToastType.error);
    });
  }

  void validate() {
    if (_phoneController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _nameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty) {
      isEnabled = true;
    } else {
      isEnabled = false;
    }
    setState(() {});
  }
}
