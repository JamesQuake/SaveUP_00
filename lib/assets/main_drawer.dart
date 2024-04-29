import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pay_or_save/pages/dashboard.dart';
import 'package:pay_or_save/pages/introduction/introductory.dart';
import 'package:pay_or_save/pages/login.dart';
import 'package:pay_or_save/pages/saving_goals.dart';
import 'package:pay_or_save/pages/starting_instructions.dart';

class MainDrawer extends StatefulWidget {
  final String uid;
  final String incomingRoute;

  const MainDrawer({Key key, this.uid, this.incomingRoute}) : super(key: key);
  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  String route = "drawer";
  Future navigateSignOut(context) async {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => LoginPage()), (route) => false);
  }

  _logOut() async {
    // final googleAcc = GoogleSignIn(scopes: ["email"]);
    // bool isGoogleActive = await googleAcc.isSignedIn();
    // if (isGoogleActive == true) {
    //   print('Signing google out');
    //   await googleAcc.signOut();
    //   print('google signed out');
    // }
    await FacebookAuth.instance.logOut();
    // print('facebook signed out');
    await FirebaseAuth.instance.signOut().then((_) {
      navigateSignOut(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.0),
            color: Colors.white,
            child: Center(
              child: Column(
                children: [
                  Container(
                    width: 150.0.w,
                    height: 150.0.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('assets/images/posmob.png'),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  RichText(
                    textAlign: TextAlign.justify,
                    // overflow: TextOverflow.visible,
                    text: TextSpan(
                      style: TextStyle(
                        color: Colors.black,
                        // height: 1.2,
                        fontSize: 25.h,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: 'e',
                          // style: TextStyle(
                          //   color: Colors.black,
                          // ),
                        ),
                        TextSpan(
                          text: 'Wzyly',
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Text(
                  //   'eWyzly',
                  //   style: TextStyle(
                  //     fontSize: 20.0,
                  //     color: Colors.grey,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.video_collection),
            title: Text(
              'Intro Videos',
              style: TextStyle(
                fontSize: 15.0.h,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Introductory(
                            uid: widget.uid,
                          )));
              // Navigator.pushReplacementNamed(context, '/Introductory');
            },
          ),
          ListTile(
            leading: Icon(Icons.account_balance_wallet),
            title: Text(
              'Savings Goal',
              style: TextStyle(
                fontSize: 15.0.h,
              ),
            ),
            onTap: () {
              if (widget.uid != null){
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SavingGoals(
                              uid: widget.uid,
                              incomingRoute: route,
                            )));
              }

              // Navigator.pushNamed(context, '/saving');
            },
          ),
          ListTile(
            leading: Icon(Icons.monetization_on),
            title: Text(
              'Investment Goal',
              style: TextStyle(
                fontSize: 15.0.h,
              ),
            ),
            onTap: () {
              if (widget.uid != null){
                Navigator.pop(context);
                Navigator.pushNamed(context, '/investment');
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.add_shopping_cart),
            title: Text(
              'Shop',
              style: TextStyle(
                fontSize: 15.0.h,
              ),
            ),
            onTap: () {
              // if (widget.incomingRoute != '/select_mode')
              if (widget.uid != null) {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/select_mode');
              }
            },
          ),
          // ListTile(
          //   leading: Icon(Icons.local_atm),
          //   title: Text(
          //     'Add to Checking Account',
          //     style: TextStyle(
          //       fontSize: 15.0.h,
          //     ),
          //   ),
          //   onTap: () {
          //     Navigator.pushNamed(context, '');
          //   },
          // ),
          ListTile(
            leading: Icon(Icons.wallet_giftcard),
            title: Text(
              'Add Reward Points',
              style: TextStyle(
                fontSize: 15.0.h,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/RewardPoints');
            },
          ),
          ListTile(
            leading: Icon(Icons.store_outlined),
            title: Text(
              'Virtual Closet',
              style: TextStyle(
                fontSize: 15.0.h,
              ),
            ),
            onTap: () {
              if (widget.uid != null) if (widget.incomingRoute != '/virtual_closet'){
                Navigator.pop(context);
                Navigator.pushNamed(context, '/virtual_closet');
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.dvr_outlined),
            title: Text(
              'Dashboard',
              style: TextStyle(
                fontSize: 15.0.h,
              ),
            ),
            onTap: () async {
              if (widget.uid != null) if (widget.incomingRoute != '/DashBoard'){
                Navigator.pop(context);
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DashBoard(
                              uid: widget.uid,
                              incomingRoute: widget.incomingRoute,
                            )));
              }
              setState(() {});
            },
          ),
          if(widget.uid != null)...[
            if (widget.incomingRoute != '/virtual_closet')
              ListTile(
                leading: Icon(Icons.logout_outlined),
                title: Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 15.0.h,
                  ),
                ),
                onTap: () {
                  // Navigator.pushReplacementNamed(context, '/signin');
                  if (widget.uid != null) _logOut();
                },
              ),
          ],
        ],
      ),
    );
  }
}
