import 'package:flutter/material.dart';

class ResultsTile extends StatelessWidget {
  ResultsTile({this.title, this.subtitle, this.icon});
  final String title, subtitle;
  final IconButton icon;
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      color: Colors.deepPurple,
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(
        vertical: 10.0,
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 5.0,
          vertical: 5.0,
        ),
        leading: Container(
          padding: EdgeInsets.only(right: 5.0),
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                width: 1.0,
                color: Colors.white24,
              ),
            ),
          ),
          child: IconButton(
            icon: icon,
            iconSize: 24,
            onPressed: null,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Row(
          children: [
            Text(
              subtitle,
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
