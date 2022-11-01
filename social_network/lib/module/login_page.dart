import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:social_network/common/shared_preferences_manager.dart';
import 'package:social_network/common/widgets/progressDialog.dart';
import 'package:social_network/common/widgets/toastOverlay.dart';
import 'package:social_network/module/newsfeed_page.dart';
import 'package:social_network/module/register_page.dart';
import 'package:social_network/service/api_service.dart';
import 'package:social_network/service/user_service.dart';
import '../common/widgets/widgets.dart';

class LoginPage extends StatefulWidget {
  final String phone;
  final String password;

  const LoginPage({
    Key? key,
    required this.phone,
    required this.password,
  }) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  var isChecked = false;
  bool isEnabled = false;

  @override
  void initState() {
    _phoneController.text = widget.phone;
    _passwordController.text = widget.password;
    validate();
    super.initState();
  }

  @override
  void dispose() {
    _phoneController.dispose();
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
            resizeToAvoidBottomInset: false,
            body: Column(
              children: [
                const Text(
                  'Sign In',
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
                Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Phone',
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
                          hintText: 'Phone Number',
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
                          'Password',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Open_Sans',
                          ),
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        BuildTextField(
                          controller: _passwordController,
                          iconData: Icons.key,
                          hintText: 'Password',
                          inputType: TextInputType.text,
                          autoFocus: false,
                          isPassword: true,
                          action: TextInputAction.done,
                          onChanged: (_) => validate(),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: [
                            Checkbox(
                              fillColor: MaterialStateProperty.resolveWith(
                                (states) {
                                  if (states.contains(MaterialState.disabled)) {
                                    return Colors.white;
                                  }
                                  return Colors.white;
                                },
                              ),
                              checkColor: Colors.blue,
                              visualDensity:
                                  const VisualDensity(horizontal: -4),
                              value: isChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  isChecked = value!;
                                });
                              },
                            ),
                            const Text(
                              'Remember me',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Open_Sans',
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        )
                      ],
                    ),
                    const Positioned(
                      right: 0,
                      bottom: 60,
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Open_Sans',
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                BuildButton(
                  text: 'LOGIN',
                  enabled: isEnabled,
                  context: context,
                  onTap: () {
                    login();
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  '-OR-',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 15,
                      fontFamily: 'Open_Sans'),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  'Sign in with',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Open_Sans',
                      fontWeight: FontWeight.w500),
                ),
                // SizedBox(height: 20),
                buildSocialBtnRow(),
                const SizedBox(
                  height: 40,
                ),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontFamily: 'Open_Sans'),
                    children: [
                      TextSpan(
                        text: ("Don't have an Account ? "),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                      TextSpan(
                        text: 'Sign up',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const RegisterPage()));
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> login() async {
    final progress = ProgressDialog(context);

    progress.show();

    apiService
        .login(
      phone: _phoneController.text,
      password: _passwordController.text,
    )
        .then((value) async {
      progress.hide();
      if(await sharedPrefs.getString('phoneKey') != null && await sharedPrefs.getString('passwordKey') != null){
        sharedPrefs.remove('phoneKey');
        sharedPrefs.remove('passwordKey');
      }
      apiService.token = value.token ?? '';
      if (isChecked) {
        await sharedPrefs.setString("APIToken", apiService.token);
        await sharedPrefs.setString("phoneKey", _phoneController.text);
        await sharedPrefs.setString("passwordKey", _phoneController.text);
      }
      if(!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const NewsfeedPage()),
          (route) => false);
    }).catchError((e) {
      progress.hide();
      ToastOverlay(context)
          .showToastOverlay(message: e.toString(), type: ToastType.error);
    });
  }

  void validate() {
    final phone = _phoneController.text;
    final password = _passwordController.text;
    if (phone.isNotEmpty && password.isNotEmpty) {
      isEnabled = true;
    } else {
      isEnabled = false;
    }
    setState(() {});
  }
}
