// import 'package:flutter/material.dart';
// import 'package:pay_or_save/providers/info_provider.dart';
// import 'package:provider/provider.dart';

// class FadingText extends StatefulWidget {
//   final String text;
//   final Color color;

//   const FadingText(this.text, this.color);

//   @override
//   _FadingTextState createState() => _FadingTextState();
// }

// class _FadingTextState extends State<FadingText>
//     with SingleTickerProviderStateMixin {
//   AnimationController _animationController;
//   Tween _tween;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: const Duration(seconds: 1),
//       vsync: this,
//     );
//     _animationController.forward();
//     _tween = Tween(begin: Offset(-1, 0), end: Offset.zero);
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<InfoProvider>(
//       builder: (context, info, child) {
//         return AnimatedBuilder(
//           animation: _animationController,
//           builder: (context, child) {
//             return SlideTransition(
//               position: _tween.animate(_animationController.view),
//               child: Text(
//                 widget.text,
//                 style: TextStyle(
//                   color: widget.color ?? Color(0xff0070c0),
//                   fontSize: 35,
//                   fontWeight: FontWeight.w400,
//                 ),
//               ),
//             );
//           },
//           // child: Text(
//           //   widget.text,
//           //   style: TextStyle(
//           //     color: widget.color ?? Color(0xff0070c0),
//           //     fontSize: 35,
//           //     fontWeight: FontWeight.w400,
//           //   ),
//           // ),
//         );
//       },
//     );
//   }
// }
