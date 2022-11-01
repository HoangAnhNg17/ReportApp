import 'package:flutter/material.dart';

class BuildTextField extends StatelessWidget {
  final TextEditingController controller;
  final IconData? iconData;
  final String hintText;
  final TextInputType inputType;
  final bool autoFocus;
  final bool isPassword;
  final TextInputAction action;
  final Function(String)? onChanged;

  const BuildTextField(
      {Key? key,
      required this.controller,
      this.iconData,
      required this.hintText,
      required this.inputType,
      required this.autoFocus,
      required this.isPassword,
      required this.action,
      this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF6CA8F1),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          hintText: hintText,
          hintStyle: TextStyle(
              color: Colors.white.withOpacity(0.5), fontFamily: 'Open_Sans'),
          icon: Icon(
            iconData,
            color: Colors.white,
          ),
          border: InputBorder.none,
        ),
        keyboardType: inputType,
        enableSuggestions: true,
        autocorrect: false,
        autofocus: autoFocus,
        obscureText: isPassword,
        textInputAction: action,
        onChanged: onChanged,
      ),
    );
  }
}

class BuildButton extends StatefulWidget {
  final String text;
  final bool? enabled;
  final BuildContext context;
  final Function onTap;

  const BuildButton(
      {Key? key,
      required this.text,
      required this.enabled,
      required this.context,
      required this.onTap})
      : super(key: key);

  @override
  State<BuildButton> createState() => _BuildButtonState();
}

class _BuildButtonState extends State<BuildButton> {
  var lock = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!lock && widget.enabled!) {
          setState(() {
            lock = true;
            widget.onTap();
          });
          Future.delayed(const Duration(milliseconds: 500), () {
            setState(() {
              lock = false;
            });
          });
        }
      },
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: (lock || !widget.enabled!)
              ? Colors.white.withOpacity(0.5)
              : Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10.0,
              offset: Offset(2, 5),
            ),
          ],
        ),
        child: Text(
          widget.text,
          style: TextStyle(
            color: Colors.blue.shade600,
            letterSpacing: 1.5,
            fontFamily: 'Open_Sans',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}

buildSocialBtn(AssetImage logo) {
  return GestureDetector(
    onTap: () {},
    child: Container(
        height: 60.0,
        width: 60.0,
        padding: const EdgeInsets.all(13),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Image(
          image: logo,
          height: 50,
        )),
  );
}

buildSocialBtnRow() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        buildSocialBtn(
          const AssetImage(
            'assets/logos/facebook.png',
          ),
        ),
        buildSocialBtn(
          const AssetImage(
            'assets/logos/google.png',
          ),
        ),
      ],
    ),
  );
}
