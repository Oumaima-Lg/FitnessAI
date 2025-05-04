// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// // import 'package:gif/gif.dart';

// // Widget go() {
// //   return GoPage();
// // }

// class GoPage extends StatefulWidget {
//   const GoPage({super.key});

//   @override
//   State<GoPage> createState() => _GoPageState();
// }

// class _GoPageState extends State<GoPage> with SingleTickerProviderStateMixin {
//   bool isRunning = false;
//   int timeLeft = 160;
//   Timer? timer;
//   // late GifController _controller;

//   @override
//   void initState() {
//     super.initState();
//     // _controller = GifController(vsync: this);
//   }

//   void toggleTimer() {
//     setState(() {
//       if (isRunning) {
//         timer?.cancel();
//       } else {
//         timer = Timer.periodic(Duration(seconds: 1), (timer) {
//           setState(() {
//             if (timeLeft > 0) {
//               timeLeft--;
//             } else {
//               timer.cancel();
//               isRunning = false;
//             }
//           });
//         });
//       }
//       isRunning = !isRunning;
//     });
//   }

//   String formatTime(int seconds) {
//     int minutes = seconds ~/ 60;
//     int remainingSeconds = seconds % 60;
//     return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
//   }

//   // @override
//   // void dispose() {
//   //   _controller.dispose();
//   //   timer?.cancel();
//   //   super.dispose();
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 Color(0xFF2E2F55),
//                 Color(0xFF23253C),
//               ],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//         title: Text('Titre de la page',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             )),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back_ios),
//           onPressed: () {},
//         ),
//       ),
//       body: Container(
//         padding: EdgeInsets.only(bottom: 10, top: 10),
//         width: double.infinity,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               Color(0xFF2E2F55),
//               Color(0xFF23253C),
//             ],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: Column(
//           children: [
//             Container(
//               width: MediaQuery.of(context).size.width * 0.7,
//               height: MediaQuery.of(context).size.height * 0.45,
//               child: Stack(
//                 children: [
//                   // Cercle rose/rouge en haut à gauche
//                   GradientComponent.gradientCircle(
//                     0,
//                     35,
//                     Color.fromARGB(255, 255, 2, 225),
//                     Color(0xFFFFB19A),
//                   ),
//                   GradientComponent.gradientCircle(
//                     MediaQuery.of(context).size.width * 0.55,
//                     35,
//                     Color(0xFF23253C),
//                     Color.fromARGB(255, 7, 6, 54),
//                   ),
//                   GradientComponent.gradientCircle(
//                     22,
//                     MediaQuery.of(context).size.height * 0.4,
//                     Color(0xFF23253C),
//                     Color.fromARGB(255, 7, 6, 54),
//                   ),
//                   // Cercle violet en bas à droite
//                   GradientComponent.gradientCircle(
//                     MediaQuery.of(context).size.width * 0.55,
//                     MediaQuery.of(context).size.height * 0.4,
//                     Color(0xFFE8ACFF),
//                     Color(0xFF7800FF),
//                   ),

//                   // Container principal avec l'image
//                   Container(
//                     margin: EdgeInsets.only(top: 75, left: 35, right: 35),
//                     decoration: BoxDecoration(
//                       border: Border.all(
//                         color: Color(0xFFE8ACFF).withAlpha(51),
//                         width: 2,
//                       ),
//                       borderRadius: BorderRadius.circular(41),
//                       color: const Color.fromARGB(255, 203, 200, 200),
//                     ),
//                     // child: Padding(
//                     //   padding: const EdgeInsets.all(20.0),
//                     //   child: Gif(
//                     //     image:
//                     //         Image.asset('lib/assets/imgs/gif/fents.gif').image,
//                     //     // controller: _controller,
//                     //     // autostart: Autostart.loop,
//                     //     repeat: ImageRepeat.noRepeat,
//                     //     fit: BoxFit.contain,
//                     //     placeholder: (context) => Center(
//                     //       child: Column(
//                     //         mainAxisAlignment: MainAxisAlignment.center,
//                     //         children: [
//                     //           CircularProgressIndicator(
//                     //             valueColor: AlwaysStoppedAnimation<Color>(
//                     //                 Color(0xFFE8ACFF)),
//                     //           ),
//                     //           SizedBox(height: 10),
//                     //           Text(
//                     //             'Chargement...',
//                     //             style: TextStyle(color: Colors.white),
//                     //           ),
//                     //         ],
//                     //       ),
//                     //     ),
//                     //     onFetchCompleted: () {
//                     //       print("GIF chargé avec succès");
//                     //       // _controller.reset();
//                     //       // _controller.forward();
//                     //     },
//                     //   ),
//                     // ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: 60,
//             ),
//             GradientComponent.gradientIconButton(
//               isRunning ? Icons.pause : Icons.play_arrow,
//               Color(0xFFE8ACFF),
//               Color(0xFF7800FF),
//               80,
//               30,
//               onPressed: toggleTimer,
//             ),
//             SizedBox(height: 40),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Column(
//                   children: [
//                     ShaderMask(
//                       shaderCallback: (Rect bounds) {
//                         return LinearGradient(
//                           colors: [Color(0xFFE8ACFF), Color(0xFF7800FF)],
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                         ).createShader(bounds);
//                       },
//                       child: Icon(
//                         Icons.history,
//                         color: Colors.white,
//                         size: 40,
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     Text(
//                       formatTime(timeLeft),
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 25,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class GradientComponent {
//   static ElevatedButton gradientButton(
//       String text, double maxWidth, double maxHeight) {
//     return ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.transparent,
//         shadowColor: Colors.transparent,
//       ),
//       onPressed: () {
//         // Action when button is pressed
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Color(0xFF4023D7), Color(0xFF983BCB)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           borderRadius: BorderRadius.circular(30),
//         ),
//         constraints: BoxConstraints(
//           maxWidth: maxWidth,
//           maxHeight: maxHeight,
//         ),
//         alignment: Alignment.center,
//         child: Text(
//           text,
//           style: TextStyle(
//             // fontSize: 18,
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }

//   static Widget gradientCircle(
//       double left, double top, Color color1, Color color2) {
//     return Positioned(
//       left: left,
//       top: top,
//       child: Container(
//         width: 60,
//         height: 60,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           gradient: LinearGradient(
//             colors: [color1, color2],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//       ),
//     );
//   }

//   static Widget gradientIconButton(
//       IconData icon, Color color1, Color color2, double width, double height,
//       {VoidCallback? onPressed}) {
//     return Container(
//       width: width,
//       height: height,
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [color1, color2],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: MaterialButton(
//         onPressed: onPressed ?? () {},
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(15),
//         ),
//         child: Icon(
//           icon,
//           color: Colors.white,
//           size: 24,
//         ),
//       ),
//     );
//   }
// }
