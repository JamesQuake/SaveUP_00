import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:logger/logger.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../pages/starting_balances.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class AuthProvider extends ChangeNotifier {
  var logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      // Number of method calls to be displayed
      errorMethodCount: 8,
      // Number of method calls if stacktrace is provided
      lineLength: 1000,
      // Width of the output
      colors: true,
      // Colorful log messages
      printEmojis: true, // Print an emoji for each log message
      // Should each log print contain a timestamp
      // dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  // AuthProvider(){}
  FirebaseAuth _auth = FirebaseAuth.instance;

  // UserCredential _user;
  String _uid = '';
  Status _status = Status.Uninitialized;

  // User user;

  User _user; // Holds the current user

  User get user => _user;

  // AuthService _authService = AuthService();

  AuthProvider() {
    // Listen for auth state changes and update the user
    _auth.authStateChanges().listen((User user) {
      _user = user;
      notifyListeners();
    });
  }

  // Stream<User> get authStateChanges => _auth.authStateChanges();

  // AuthProvider.instance() : _auth = FirebaseAuth.instance {
  //   _auth.authStateChanges().listen((event) {
  //     user = event;
  //     _uid = user.uid;
  //   });
  // }

  String _userIdFirebaseUser(User user) {
    return user != null ? _uid = user.uid : null;
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return _userIdFirebaseUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Status get status => _status;

  // UserCredential get user => _user;
  // String get uid => _uid;

  var selectedPlan = 1;

  changeSelectedPlan(int plan) {
    selectedPlan = plan;
    notifyListeners();
  }

  Offerings offerings;

  Future getOfferingsDetails() async {
    await Purchases.setDebugLogsEnabled(true);

    PurchasesConfiguration configuration;
    if (Platform.isAndroid) {
      configuration =
          PurchasesConfiguration("goog_ROKUqNPFksWwfOPyvIcvyZKDPvC");
    } else if (Platform.isIOS) {
      configuration =
          PurchasesConfiguration("appl_TyEUZYmaqrFBvyvETDxAnSatMwM");
    }
    await Purchases.configure(configuration);
    offerings = await Purchases.getOfferings();
    // Purchases.addCustomerInfoUpdateListener((customerInfo) {
    //   // Handle the updated customer info
    //   print('Purchases.addCustomerInfoUpdateListener ->');
    //   print(customerInfo.toJson());
    //   debugPrint('${customerInfo.toJson()}');
    //   logger.d(customerInfo.toJson());
    // });
  }

  ConfettiController controllerTopRight;
  ConfettiController controllerTopLeft;

  Future purchasePlan(BuildContext context) async {
    try {
      EasyLoading.show(
          status: 'loading...', maskType: EasyLoadingMaskType.black);
      final desiredPackageId =
          'Plan $selectedPlan'; // Replace with your offering ID

      // Find the specific offering
      final specificPackage = offerings.current?.availablePackages.firstWhere(
        (package) => package.identifier == desiredPackageId,
        orElse: () => null,
      );

      print('identifies -> -> ${specificPackage.identifier}');
      print(
          'identifies - storeProduct -> -> ${specificPackage.storeProduct.identifier}');

      final customerInfo = await Purchases.purchasePackage(specificPackage);
      print('purchase.toJson -> ${customerInfo.toJson}');

      if (customerInfo.entitlements.active
          .containsKey(specificPackage.storeProduct.identifier)) {
        print(
            'Successfully purchased ${specificPackage.storeProduct.identifier} -1');

        logger.i(customerInfo.entitlements.active);
        logger.i(customerInfo
            .entitlements.active[specificPackage.storeProduct.identifier]);

        logger.i(customerInfo
            .entitlements
            .active[specificPackage.storeProduct.identifier]
            .latestPurchaseDate);
        logger.i(customerInfo
            .entitlements
            .active[specificPackage.storeProduct.identifier]
            .originalPurchaseDate);

        String timestamp =
            '${customerInfo.entitlements.active[specificPackage.storeProduct.identifier].latestPurchaseDate}';
        DateTime dateTime = DateTime.parse(timestamp);
        // Print the original DateTime (in UTC)
        print('Original DateTime (UTC): ${DateTime.now()}');
        print('Original DateTime (UTC): $dateTime');
        // Print in local time zone
        print('Local time: ${dateTime.toLocal()}');

        if (dateTime
            .toLocal()
            .isAfter(DateTime.now().subtract(Duration(minutes: 5)))) {
          logger.wtf('TRANSACTION APPROVED');
          EasyLoading.showSuccess('Great Success!');
          controllerTopRight.play();
          controllerTopLeft.play();
          await upgradeAccountBalance(context, selectedPlan);
        }

        // await processConsumablePurchase(specificPackage.storeProduct.identifier);
      } else {
        // Check if the product is in the non-subscription transactions
        // List<StoreTransaction> transactions =
        //     customerInfo.nonSubscriptionTransactions;
        // StoreTransaction matchingTransaction = transactions.firstWhere(
        //   (t) =>
        //       t.productIdentifier == specificPackage.storeProduct.identifier,
        //   orElse: () => null,
        // );

        // if (matchingTransaction != null) {
        //   print(
        //       'Successfully purchased ${specificPackage.storeProduct.identifier}');
        //   logger.i(matchingTransaction.productIdentifier);
        //   logger.i(matchingTransaction.purchaseDate);
        //   String timestamp = matchingTransaction.purchaseDate;
        //   DateTime dateTime = DateTime.parse(timestamp);
        //   // Print the original DateTime (in UTC)
        //   print('Original DateTime (UTC): ${DateTime.now()}');
        //   print('Original DateTime (UTC): $dateTime');
        //   // Print in local time zone
        //   print('Local time: ${dateTime.toLocal()}');
        //   // await processConsumablePurchase(matchingTransaction.productIdentifier);
        // } else {
        //   print(
        //       'Purchase failed or not found for ${specificPackage.storeProduct.identifier}');
        // }
      }
    } on PlatformException catch (e) {
      EasyLoading.dismiss();
      if (e.code == '3' ||
          e.details['readableErrorCode'] == 'PurchaseNotAllowedError') {
        // Handle the specific "purchase not allowed" error
        print('Purchase not allowed: ${e.message}');

        // Check if it's due to billing being unavailable
        if (e.details['underlyingErrorMessage']
                ?.contains('BILLING_UNAVAILABLE') ??
            false) {
          print('Billing is currently unavailable on this device');
          // Inform the user that billing is not available
        } else {
          print('The device or user is not allowed to make the purchase');
          // Inform the user that they're not allowed to make the purchase
        }

        // You might want to guide the user on how to resolve this issue
        // For example, checking their device settings or account status
      } else {
        // Handle other types of PlatformExceptions
        print('An error occurred during purchase: ${e.message}');
      }
    } catch (e) {
      EasyLoading.dismiss();
      // Handle any other unexpected errors
      print('Unexpected error: $e');
    }
  }

  num checking, rewardPoints;

  Future getBalances(String uid) async {
    print('I am in get bacl');
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get()
        .then((value) {
      if (value.data != null) {
        checking = value.data()['checking'].round();
        rewardPoints = value.data()['reward_points'].round();
      }
    });
  }

  Future upgradeAccountBalance(BuildContext context, selectedPlan) async {
    try {
      EasyLoading.show(status: 'Upgrading...');
      int points = getPointsAgainstPlan(selectedPlan);
      logger.i('points -> $points');
      int rewardsMultiple = 1;
      if (selectedPlan < 7) {
        rewardsMultiple = 2;
      }
      logger.i('reward_points -> ${points*rewardsMultiple}');
      logger.i('after points -> ${points+checking}');
      logger.i('after reward_points -> ${rewardPoints + (points*rewardsMultiple)}');
      await FirebaseFirestore.instance
          .collection("users")
          .doc(_user.uid)
          .update({
        'checking': checking + points,
        'reward_points': rewardPoints + (points * rewardsMultiple),
      });
      EasyLoading.showSuccess('Account credited');

      Future.delayed(Duration(seconds: 1)).then((_) {
        Navigator.pushAndRemoveUntil<void>(
          context,
          MaterialPageRoute<void>(
              builder: (BuildContext context) =>
                  StartingBalances(uid: _user.uid)),
          ModalRoute.withName('/'),
        );
        // Navigator.of(context, rootNavigator: true).popUntil(ModalRoute.withName('/starting'));
      });
    } catch (e) {
      EasyLoading.showError('Something went wrong\nContact Support');
    }
  }

  int getPointsAgainstPlan(int selectedPlan) {
    int points = 500;
    switch (selectedPlan) {
      case 1:
        points = 500;
        break;
      case 2:
        points = 1000;
        break;
      case 3:
        points = 2500;
        break;
      case 4:
        points = 5000;
        break;
      case 5:
        points = 7500;
        break;
      case 6:
        points = 10000;
        break;
      default:
        points = 500;
        break;
    }
    return points;
  }
}

// onAuthStateChanged.listen(_onAuthStateChanged)
