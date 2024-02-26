import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pay_or_save/pages/sign_in.dart';

class MyManue {


 static Widget childPopup(context) => PopupMenuButton<String>(
    itemBuilder: (context) => [
      PopupMenuItem(
        value: 'select_mode',
        child: Text(
          "Star Again",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w700),
        ),
      ),
      PopupMenuItem(
        value: 'virtual_closet',
        child: Text(
          "Virtual Closet",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w700),
        ),
      ),
      PopupMenuItem(
        value: 'dashboard',
        child: Text(
          "Dashboard",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w700),
        ),
      ),
    ],
    onSelected: (val){
        Navigator.pushNamed(context, '/'+val);
    },
    child: Container(
      height: 32,
      width: 32,
      child: Icon(Icons.more_vert),
    ),
  );


}