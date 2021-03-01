import 'package:Quipia/screens/levels.dart';
import 'package:flutter/material.dart';

class CategoryTile extends StatelessWidget {
  final String imageUrl, title, description;
  final int noOfQuestions, id;

  CategoryTile(
      {@required this.title,
      @required this.imageUrl,
      @required this.description,
      @required this.id,
      @required this.noOfQuestions});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LevelsPage(id, noOfQuestions)),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        height: MediaQuery.of(context).size.height * 0.15,
        child: ShaderMask(
          shaderCallback: (rect) => LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.grey[200], Colors.grey[100]],
          ).createShader(rect),
          blendMode: BlendMode.darken,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              children: [
                Image.network(imageUrl,
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width),
                Container(
                  color: Colors.black26,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          description,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
