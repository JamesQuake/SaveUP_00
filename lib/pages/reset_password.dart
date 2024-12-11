// import 'package:flutter/material.dart';

// class ResetPassword extends StatefulWidget {
//   const ResetPassword({Key key}) : super(key: key);

//   @override
//   _ResetPasswordState createState() => _ResetPasswordState();
// }

// class _ResetPasswordState extends State<ResetPassword> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: BackButton(
//           color: Colors.black,
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         centerTitle: true,
//         elevation: 0.0,
//         backgroundColor: Colors.white,
//         title: Row(
//           children: [
//             Image.asset(
//               "assets/images/new/newlogo.png",
//               height: 50.0,
//               width: 220.0,
//             ),
//           ],
//         ),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(20.0, 60.0, 20.0, 0.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 Text('Reset Password'),
//                 SizedBox(height: 40.0),
//                 TextField(
//                   style: TextStyle(
//                     color: Colors.grey,
//                   ),
//                   decoration: InputDecoration(
//                     fillColor: Colors.black,
//                     focusColor: Colors.black,
//                     labelText: 'Password',
//                     labelStyle: TextStyle(color: Colors.black),
//                     hintStyle: TextStyle(fontSize: 20.0, color: Colors.white),
//                     border: OutlineInputBorder(
//                       borderSide:
//                           const BorderSide(color: Colors.white, width: 2.0),
//                       borderRadius: BorderRadius.circular(10.0),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide:
//                           const BorderSide(color: Colors.black, width: 2.0),
//                       borderRadius: BorderRadius.circular(10.0),
//                     ),
//                   ),
//                   obscureText: true,
//                 ),
//                 SizedBox(
//                   height: 10.0,
//                 ),
//                 SizedBox(height: 30.0),
//                 TextField(
//                   style: TextStyle(
//                     color: Colors.grey,
//                   ),
//                   decoration: InputDecoration(
//                     fillColor: Colors.black,
//                     focusColor: Colors.black,
//                     labelText: 'Verify Password',
//                     labelStyle: TextStyle(color: Colors.black),
//                     hintStyle: TextStyle(fontSize: 20.0, color: Colors.white),
//                     border: OutlineInputBorder(
//                       borderSide:
//                           const BorderSide(color: Colors.white, width: 2.0),
//                       borderRadius: BorderRadius.circular(10.0),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide:
//                           const BorderSide(color: Colors.black, width: 2.0),
//                       borderRadius: BorderRadius.circular(10.0),
//                     ),
//                   ),
//                   obscureText: true,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
