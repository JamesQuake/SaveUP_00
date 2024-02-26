import 'package:flutter/material.dart';

class Slide {
  final String imageUrl;
  final String title;
  final String description;

  Slide({
    @required this.imageUrl,
    @required this.title,
    @required this.description,
  });
}

final slideList = [
  Slide(
    imageUrl: 'assets/images/slide1.jpg',
    title: 'Black',
    description: '',
  ),
  Slide(
    imageUrl: 'assets/images/slide2.jpg',
    title: 'Lives',
    description: '',
  ),
  Slide(
    imageUrl: 'assets/images/slide3.jpg',
    title: 'Count',
    description: '',
  ),

];

