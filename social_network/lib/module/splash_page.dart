import 'package:flutter/material.dart';
import 'package:social_network/common/const.dart';
import 'package:social_network/common/shared_preferences_manager.dart';
import 'package:social_network/module/login_page.dart';
import 'package:social_network/module/newsfeed_page.dart';
import 'package:social_network/service/api_service.dart';
import 'package:social_network/service/user_service.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () {
      initData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTextStyle(
        style: const TextStyle(fontFamily: 'Open_Sans', color: Colors.white),
        child: Container(
          height: double.infinity,
          width: double.infinity,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 40),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                alignment: Alignment.center,
                child: const Status(),
              ),
              const SizedBox(height: 150,),
              const Text(
                'Welcome!',
                style: TextStyle(
                  fontSize: 39,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'We are glad to see you',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 80,
              ),
              Container(
                alignment: Alignment.center,
                child: const CircularProgressIndicator(
                  backgroundColor: Colors.white,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                  alignment: Alignment.center,
                  child: const Text(
                    'Please wait...',
                    style: TextStyle(
                      fontSize: 19,
                    ),
                  )),
              const SizedBox(
                height: 150,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future initData() async {
    await sharedPrefs.init();
    final apiKey = await sharedPrefs.getString('APIToken');
    final phoneKey = await sharedPrefs.getString('phoneKey');
    final passwordKey = await sharedPrefs.getString('passwordKey');
    if (apiKey != null) {
      apiService.token = apiKey;
      apiService.getProfile();
      if(!mounted) return;
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const NewsfeedPage()));
    } else {
      if(!mounted) return;
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage(phone: phoneKey ?? '', password: passwordKey ?? '',)));
    }
  }
}
