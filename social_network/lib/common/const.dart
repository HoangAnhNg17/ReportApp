import 'package:flutter/material.dart';

const baseUrl = 'http://api.quynhtao.com';

class Status extends StatelessWidget {
  const Status({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'Status',
      style: TextStyle(
          fontSize: 100,
          fontFamily: 'Status',
          color: Colors.white,
          fontWeight: FontWeight.bold
      ),
    );
  }
}
