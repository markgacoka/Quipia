import 'package:flutter/material.dart';
import 'widgets.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final Color color;
  final Color color2;

  const CustomButton({
    Key key,
    @required this.title,
    @required this.onTap,
    @required this.color,
    @required this.color2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(20.0),
        height: 50.0,
        width: double.infinity,
        decoration: BoxDecoration(
          color: color,
          boxShadow: boxShadow,
          borderRadius: BorderRadius.circular(25.0),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            color: color2,
          ),
        ),
      ),
    );
  }
}
