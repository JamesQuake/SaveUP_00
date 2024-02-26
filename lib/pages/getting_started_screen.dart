import 'dart:async';

import 'package:pay_or_save/pages/sign_in.dart';
import 'package:pay_or_save/widgets/slide_dots.dart';
import 'package:flutter/material.dart';

import '../widgets/slide_item.dart';
import '../models/slide.dart';

class GettingStartedScreen extends StatefulWidget {
  @override
  _GettingStartedScreenState createState() => _GettingStartedScreenState();
}

class _GettingStartedScreenState extends State<GettingStartedScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
//    Timer.periodic(Duration(seconds: 10), (Timer timer) {
//      if (_currentPage < 2) {
//        _currentPage++;
//      } else {
//        _currentPage = 0;
//      }
//
//      _pageController.animateToPage(
//        _currentPage,
//        duration: Duration(milliseconds: 300),
//        curve: Curves.easeIn,
//      );
//    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        color: Colors.white,
//          padding: const EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: <Widget>[
                    PageView.builder(
                      scrollDirection: Axis.horizontal,
//                      controller: _pageController,
                      onPageChanged: _onPageChanged,
                      itemCount: slideList.length,
                      itemBuilder: (ctx, i) => SlideItem(i),
                    ),
                    Stack(
                      alignment: AlignmentDirectional.topStart,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(bottom: 35),
                          height: 30,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              for(int i = 0; i<slideList.length; i++)
                                if( i == _currentPage )
                                  SlideDots(true)
                                else
                                  SlideDots(false)
                            ],
                          ),
                        ),
                        Positioned(
                          right: 35,
                          bottom: 25,
                          child: (_currentPage == 2)?Container(
                            child: GestureDetector(
                                onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => SignInRegistrationPage()));
                                },
                                child: Icon(Icons.arrow_forward, color: Colors.white, size: 42,)),
                          ):Container(),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
      ),
    );
  }
}
