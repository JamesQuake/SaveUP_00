import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pay_or_save/pages/about_investment.dart';
import 'package:pay_or_save/pages/about_savings.dart';
import 'package:pay_or_save/pages/alt_loading_page.dart';
import 'package:pay_or_save/pages/dashboard.dart';
// import 'package:pay_or_save/pages/edit_investment_goal.dart';
import 'package:pay_or_save/pages/new_pages/current_balances.dart';
import 'package:pay_or_save/pages/new_pages/acquire_reward_points.dart';
import 'package:pay_or_save/pages/new_pages/add_to_account.dart';
import 'package:pay_or_save/pages/new_pages/forgot_password.dart';
import 'package:pay_or_save/pages/heard_from.dart';
// import 'package:pay_or_save/pages/home_video.dart';
import 'package:pay_or_save/pages/introduction/introductory.dart';
import 'package:pay_or_save/pages/introduction/introductory0.dart';
import 'package:pay_or_save/pages/introduction/introductory1.dart';
import 'package:pay_or_save/pages/introduction/introductory2.dart';
import 'package:pay_or_save/pages/investment_goal.dart';
import 'package:pay_or_save/pages/loading_page.dart';
import 'package:pay_or_save/pages/new_pages/overdraft_reminder.dart';
import 'package:pay_or_save/pages/new_pages/plan1.dart';
// import 'package:pay_or_save/pages/new_pages/save_new.dart';
import 'package:pay_or_save/pages/new_pages/select_store.dart';
import 'package:pay_or_save/pages/new_pages/win.dart';
// import 'package:pay_or_save/pages/overdraft_notice.dart';
// import 'package:pay_or_save/pages/reset_password.dart';
import 'package:pay_or_save/pages/saving_goals.dart';
import 'package:pay_or_save/pages/select_mode.dart';
import 'package:pay_or_save/pages/sign_in.dart';
import 'package:pay_or_save/pages/splash.dart';
import 'package:pay_or_save/pages/starting_balances.dart';
import 'package:pay_or_save/pages/virtual_closet.dart';
import 'package:pay_or_save/pages/new_pages/welcome_back.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pay_or_save/providers/auth_provider.dart';
import 'package:pay_or_save/providers/registry.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:pay_or_save/providers/total_provider.dart';
import 'package:provider/provider.dart';
import 'pages/invest_now.dart';
// import 'pages/new_pages/invest_new.dart';
import 'pages/new_pages/reset_password.dart';
import 'pages/new_pages/reward_points.dart';
import 'pages/save_now.dart';
// import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await MobileAds.instance.initialize();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp());
  });
}

// await Firebase.initializeApp();
final FirebaseAuth auth = FirebaseAuth.instance;

class MyApp extends StatelessWidget {
  // String uid;

  // This widget is the root of your application.
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  // final _totalValues = TotalValues();
  Map<int, Color> color = {
    50: Color.fromRGBO(136, 14, 79, .1),
    100: Color.fromRGBO(136, 14, 79, .2),
    200: Color.fromRGBO(136, 14, 79, .3),
    300: Color.fromRGBO(136, 14, 79, .4),
    400: Color.fromRGBO(136, 14, 79, .5),
    500: Color.fromRGBO(136, 14, 79, .6),
    600: Color.fromRGBO(136, 14, 79, .7),
    700: Color.fromRGBO(136, 14, 79, .8),
    800: Color.fromRGBO(136, 14, 79, .9),
    900: Color.fromRGBO(136, 14, 79, 1),
  };

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // key: ObjectKey(uid),
      providers: registry,
      child: ScreenUtilInit(
          designSize: const Size(375, 815),
          minTextAdapt: true,
          // splitScreenMode: true,
          builder: (context, snapshot) {
            return Consumer<AuthProvider>(
            builder: (context, provider, child){
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'SaveUp',
                theme: ThemeData(
                  primarySwatch: MaterialColor(0xff0070c0, color),
                ),
                //  navigatorObservers: [
                //    routeObserver.route
                //  ],
                home: FutureBuilder(
                  // Initialize FlutterFire:
                  future: _initialization,
                  builder: (context, snapshot) {
                    // Check for errors

                    // Once complete, show your application
                    if (snapshot.connectionState == ConnectionState.done) {
                      return new StreamBuilder(
                        stream: auth.authStateChanges(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return AltLoadingPage(
                              uid: snapshot.data.uid,
                            );
                          } else if (snapshot.hasError) {
                            return LoadingPage(
                              isUser: false,
                              uid: '',
                            );
                          } else {
                            if (snapshot.connectionState ==
                                ConnectionState.active) {
                              return LoadingPage(
                                isUser: snapshot.hasData,
                                uid: snapshot.data,
                              );
                            }
                            return Container();
                          }
                        },
                      );
                    } else {
                      // Otherwise, show something whilst waiting for initialization to complete
                      return Container();
                    }
                  },
                ),
                //initialRoute: '/Introductory0',
                routes: <String, WidgetBuilder>{
                  // When navigating to the "/second" route, build the SecondScreen widget.

                  '/Intoductory': (context) => Introductory(),
                  '/Introductory0': (context) => Introductory0(),
                  '/Introductory1': (context) => Introductory1(),
                  '/Introductory2': (context) => Introductory2(),
                  '/signin': (context) => SignInRegistrationPage(),
                  '/forgot_password': (context) => ForgotPassword(),
                  '/reset_password': (context) => ResetPassword(),
                  '/AboutSavings': (context) => AboutSavings(),
                  '/AboutInvestment': (context) => AboutInvestment(),
                  '/welcomeback': (context) => WelcomeBack(),
                  '/starting': (context) => StartingBalances(uid: provider.user.uid),
                  '/HeardFrom': (context) => HeardFrom(),
                  '/saving': (context) => SavingGoals(uid: provider.user.uid),
                  '/investment': (context) => InvestmentGoals(uid: provider.user.uid),
                  '/dashboard': (context) => DashBoard(uid: provider.user.uid),
                  '/select_mode': (context) => SelectMode(uid: provider.user.uid),
                  '/DashBoard': (context) => DashBoard(uid: provider.user.uid),
                  '/virtual_closet': (context) => VirtualCloset(uid: provider.user.uid),
                  // '/myoverdraft': (context) => MyOverdraft(),
                  '/winprizes': (context) => WinPrizes(),
                  '/save_now': (context) => SaveNow(),
                  '/invest_now': (context) => InvestNow(),
                  'acquire_points': (context) => AcquirePoints(),
                  '/add_to_account': (context) => AddToAccount(),
                  '/plan1': (context) => Plan1(),
                  'overdraft_reminder': (context) => OverdraftReminder(),
                  'select_Store': (context) => SelectStore(),
                  'AccountBalances': (context) => AccountBalance(),
                  '/RewardPoints': (context) => RewardPoints(uid: provider.user.uid),
                  // '/EditInvestment': (context) => EditInvestmentGoal(uid: uid, route: route)
                },
              );
            },
            );
          }),
    );
  }
}
