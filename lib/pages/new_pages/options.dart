import 'package:flutter/material.dart';
// import 'package:pay_or_save/pages/new_pages/invest_new.dart';
// import 'package:pay_or_save/pages/new_pages/save_new.dart';
import 'package:pay_or_save/pages/overdraft_notice.dart';
// import 'package:pay_or_save/pages/save.dart';

import '../invest_now.dart';
import '../save_now.dart';

class Options extends StatefulWidget {
  final String uid;
  const Options({Key key, this.uid}) : super(key: key);

  @override
  _OptionsState createState() => _OptionsState();
}

class _OptionsState extends State<Options> with SingleTickerProviderStateMixin {
  bool isFav = false;
  AnimationController _controller;
  Animation<Color> _colorAnimation;
  Animation<double> _sizeAnimation;
  Animation _curve;
  // double containerSize = 100.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _curve = CurvedAnimation(parent: _controller, curve: Curves.slowMiddle);

    // _colorAnimation = ColorTween(
    //   begin: Color(0xff11a858),
    //   end: Colors.lightGreen,
    // ).animate(_curve);
    // _colorAnimation = TweenSequence(<TweenSequenceItem<Color>>[
    //   TweenSequenceItem<Color>(
    //       tween: Tween<Color>(
    //         begin: Color(0xff11a858),
    //         end: Colors.lightGreen,
    //       ),
    //       weight: 50),
    //   TweenSequenceItem<Color>(
    //       tween: Tween<Color>(
    //         begin: Colors.lightGreen,
    //         end: Color(0xff11a858),
    //       ),
    //       weight: 50),
    // ]).animate(_curve);

    _sizeAnimation = TweenSequence(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
          tween: Tween<double>(
            begin: 100.0,
            end: 200.0,
          ),
          weight: 50.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(
            begin: 200.0,
            end: 100.0,
          ),
          weight: 50.0),
    ]).animate(_curve);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          isFav = true;
        });
      }
      if (status == AnimationStatus.dismissed) {
        setState(() {
          isFav = false;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        // title: Row(
        //   children: [
        //     SizedBox(
        //       width: 10,
        //     ),
        //     Image.asset(
        //       "assets/images/new/newlogo.png",
        //       height: 55.0,
        //       width: 220.0,
        //     ),
        //   ],
        // ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        // scrollDirection: Axis.horizontal,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 160.0, 0.0, 40.0),
            child: Column(
              children: [
                Text(
                  'Shopping',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 23.0,
                  ),
                ),
                SizedBox(
                  height: 250.0,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AnimatedBuilder(
                          animation: _controller,
                          builder: (BuildContext context, _) {
                            return GestureDetector(
                              onTap: () {
                                // isFav
                                //     ? _controller.reverse()
                                //     : _controller.forward();
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => MyOverdraft()));
                              },
                              child: Container(
                                width: 100.0,
                                height: 100.0,
                                decoration: BoxDecoration(
                                  color: Color(0xff3790ce),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.4),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Pay',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 23.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                // color: Color(0xff3790ce),
                              ),
                            );
                          }),
                      SizedBox(
                        width: 10.0,
                      ),
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (BuildContext context, _) {
                          return GestureDetector(
                            onTap: () {
                              // isFav
                              // ? _controller.reverse()
                              //     : _controller.forward();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SaveNow()));
                            },
                            child: Container(
                              width: 100.0,
                              // _sizeAnimation.value,
                              height: 100.0,
                              // _sizeAnimation.value,
                              decoration: BoxDecoration(
                                color: Color(0xff11a858),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.4),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Save',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 23.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              // color: Color(0xff11a858),
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => InvestNow()));
                        },
                        child: Container(
                          width: 100.0,
                          height: 100.0,
                          decoration: BoxDecoration(
                            color: Color(0xff11a858),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Invest',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 23.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          // color: Color(0xff11a858),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
