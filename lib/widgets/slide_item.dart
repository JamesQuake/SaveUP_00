import 'package:flutter/material.dart';

import '../models/slide.dart';

class SlideItem extends StatelessWidget {

  final int index;
  SlideItem(this.index);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
//            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage(slideList[index].imageUrl),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
                color: Color(0xFF000000).withOpacity(0.4)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  height: 40,
                ),
                Text(
                  slideList[index].title,
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                  ),
                ),
//              SizedBox(
//                height: 10,
//              ),
                Text(
                  slideList[index].description,
                  style: TextStyle(color: Colors.white, fontSize: 18, height: 1.2),
                  textAlign: TextAlign.center,

                ),

                SizedBox(
                  height: 120,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
