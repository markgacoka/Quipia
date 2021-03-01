import 'package:flutter/material.dart';

class TextInputField extends StatelessWidget {
  const TextInputField({
    Key key,
    @required this.icon,
    @required this.hint,
    this.inputType,
    this.inputAction,
    this.obscure,
  }) : super(key: key);

  final IconData icon;
  final String hint;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final bool obscure;

  @override
  Widget build(BuildContext context) {
    const TextStyle kBodyText = TextStyle(
        fontSize: 17, color: Colors.white, height: 1.5, fontFamily: "Roboto");

    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        height: size.height * 0.07,
        width: size.width * 0.85,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Icon(
                  icon,
                  size: 22,
                  color: Colors.white,
                ),
              ),
              hintText: hint,
              hintStyle: kBodyText,
            ),
            obscureText: obscure,
            style: kBodyText,
            keyboardType: inputType,
            textInputAction: inputAction,
          ),
        ),
      ),
    );
  }
}
