import 'package:flutter/material.dart';

class CardListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool unlocked;

  CardListTile({this.title, this.subtitle, this.unlocked});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      color: unlocked ? Colors.deepPurple : Color.fromRGBO(64, 75, 96, .9),
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 10.0,
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 5.0,
        ),
        leading: Container(
          padding: EdgeInsets.only(right: 12.0),
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                width: 1.0,
                color: Colors.white24,
              ),
            ),
          ),
          child: IconButton(
            icon: unlocked
                ? Icon(Icons.lock_open, color: Colors.white)
                : Icon(Icons.lock, color: Colors.white),
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
        trailing: Icon(
          Icons.keyboard_arrow_right,
          color: Colors.white,
          size: 30.0,
        ),
      ),
    );
  }
}
