import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:social_network/common/shared_preferences_manager.dart';
import 'package:social_network/model/user.dart';
import 'package:social_network/module/change_password_page.dart';
import 'package:social_network/module/login_page.dart';
import 'package:social_network/module/profile_page.dart';
import 'package:social_network/module/report_page.dart';
import 'package:social_network/module/web_view.dart';

class DrawerPage extends StatefulWidget {
  final User user;
  const DrawerPage({super.key, required this.user});

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/image/background_drawer.jpg'),
                fit: BoxFit.fill,
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(user: widget.user,)));
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 20),
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: widget.user.avatar != null ? CachedNetworkImageProvider(widget.user.avatar ?? ''):
                            const AssetImage('assets/image/avatar.png') as ImageProvider,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.user.name ?? '',
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Open_Sans'),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          ListTile(
            iconColor: Colors.black,
            leading: const Icon(Icons.format_list_bulleted),
            title: const Text(
              'Sự cố',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontFamily: 'Open_Sans'),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          Divider(
            height: 10,
            color: Colors.grey.shade300,
          ),
          ListTile(
            iconColor: Colors.black,
            leading: const Icon(Icons.warning_amber),
            title: const Text(
              'Báo cáo',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontFamily: 'Open_Sans'),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ReportPage()));
            },
          ),
          Divider(
            height: 10,
            color: Colors.grey.shade300,
          ),
          ListTile(
            iconColor: Colors.black,
            leading: const Icon(Icons.shield_outlined),
            title: const Text(
              'Đổi mật khẩu',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontFamily: 'Open_Sans'),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ChangePasswordPage()));
            },
          ),
          Divider(
            height: 10,
            color: Colors.grey.shade300,
          ),
          ListTile(
            iconColor: Colors.black,
            leading: const Icon(Icons.ad_units_outlined),
            title: const Text(
              'Điều khoản',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontFamily: 'Open_Sans'),
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const WebViewContainer()));
            },
          ),
          Divider(
            height: 10,
            color: Colors.grey.shade300,
          ),
          ListTile(
            iconColor: Colors.black,
            leading: const Icon(Icons.account_box_outlined),
            title: const Text(
              'Liên hệ',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontFamily: 'Open_Sans'),
            ),
            onTap: () {},
          ),
          Divider(
            height: 10,
            color: Colors.grey.shade300,
          ),
          ListTile(
            iconColor: Colors.black,
            leading: const Icon(Icons.logout_outlined),
            title: const Text(
              'Đăng xuất',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontFamily: 'Open_Sans'),
            ),
            onTap: () {
              AlertDialog logout = AlertDialog(
                title: const Text('Log out from Status?'),
                actions: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              logOut();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.blue,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              alignment: Alignment.center,
                              child: const Text(
                                'Yes, log out',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            int count = 0;
                            Navigator.of(context).popUntil((_) => count++ >= 2);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            alignment: Alignment.center,
                            child: const Text(
                              'Cancel',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              );
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return logout;
                },
              );
            },
          ),
        ],
      ),
    );
  }
  Future<void> logOut() async{
    sharedPrefs.remove('APIToken');
    final phoneKey = await sharedPrefs.getString('phoneKey');
    final passwordKey = await sharedPrefs.getString('passwordKey');
    if(!mounted) return;
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage(phone: phoneKey ?? '',password: passwordKey ?? '',)), (route) => false);
  }
}
