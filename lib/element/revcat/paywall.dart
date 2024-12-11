import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
// import 'package:magic_weather_flutter/src/constant.dart';
// import 'package:magic_weather_flutter/src/model/singletons_data.dart';
// import 'package:magic_weather_flutter/src/model/styles.dart';

class Paywall extends StatefulWidget {
  final Offering offering;
  final String uid;

  const Paywall({Key key, @required this.offering, this.uid}) : super(key: key);

  @override
  _PaywallState createState() => _PaywallState();
}

class _PaywallState extends State<Paywall> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  final firestoreInstance = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _animationController.repeat();
  }

  _updateClient() async {
    await firestoreInstance
        .collection("users")
        .doc(widget.uid)
        .update({"ads_status": 1});
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Wrap(
          children: <Widget>[
            Container(
              height: 70.0,
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: Colors.grey,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(25.0))),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/posmob.png",
                    height: 33.0,
                  ),
                  Text(
                    '  SaveUp Premium',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )),
            ),
            // SizedBox(
            //   height: 50.0,
            // ),
            Padding(
              padding:
                  EdgeInsets.only(top: 32, bottom: 16, left: 16.0, right: 16.0),
              child: SizedBox(
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'STOP ADS ',
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold),
                    ),
                    Image.asset(
                      "assets/images/Reward-Points1.png",
                      height: 30.0,
                    ),
                  ],
                ),
                width: double.infinity,
              ),
            ),
            ListView.builder(
              itemCount: widget.offering.availablePackages.length,
              itemBuilder: (BuildContext context, int index) {
                var myProductList = widget.offering.availablePackages;
                return Card(
                  color: Color(0xff11a858),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  child: ListTile(
                      onTap: () async {
                        var isPro;
                        try {

                          CustomerInfo customerInfo1 = await Purchases.purchasePackage(myProductList[index]);
                          var isPro = customerInfo1.entitlements.all["reward_points"].isActive;
                          if (isPro) {
                            // Unlock that great "pro" content
                            print("client is pro");
                          } else {
                            print("this man is not pro");
                          }

                          // Offerings offerings = await Purchases.getOfferings();
                          // if (offerings.current != null && offerings.current.availablePackages.isNotEmpty) {
                          //   // Display packages for sale
                          // }
                          CustomerInfo customerInfo = await Purchases.purchasePackage(myProductList[index]);
                          print('customerInfo : ${customerInfo.entitlements.all}');
                          if (customerInfo.entitlements.all["reward_points"].isActive) {
                            // Unlock that great "pro" content
                          }
                          isPro = customerInfo.entitlements.all["reward_points"].isActive;

                          // CustomerInfo customerInfo =
                          //     await Purchases.purchasePackage(
                          //         myProductList[index]);

                          // CustomerInfo customerInfo;
                          // Purchases.purchaseProduct("points");
                          print("wagmi");

                          // CustomerInfo restoredInfo =
                          //     await Purchases.restorePurchases();



                          // print(restoredInfo);
                          // if (customerInfo
                          //     .entitlements.all["points"].isActive) {
                          // Grant user "pro" access


                          // isPro =
                          //     restoredInfo.entitlements.all["points"].isActive;


                          // var isP = customerInfo
                          //     .entitlements.all["reward_points"].isActive;
                          print("tingss *********");
                          print(isPro);
                          // print(isP);
                          if (isPro == true) {
                            _updateClient();
                          }
                          // }
                        } catch (e) {
                          print(e);
                        }
                        setState(() {});
                        Navigator.pop(context, isPro);
                      },
                      leading: Image.asset(
                        "assets/images/Coin.png",
                        height: 38.0,
                      ),
                      title: Text(
                        myProductList[index].storeProduct.title,
                        style: TextStyle(fontSize: 15.0, color: Colors.white),
                      ),
                      subtitle: Text(
                          myProductList[index].storeProduct.description,
                          style:
                              TextStyle(fontSize: 15.0, color: Colors.white)),
                      trailing: Text(
                          myProductList[index].storeProduct.priceString,
                          style:
                              TextStyle(fontSize: 15.0, color: Colors.white))),
                );
              },
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
            ),
            const Padding(
              padding:
                  EdgeInsets.only(top: 32, bottom: 16, left: 16.0, right: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
