
// Below is implementation of Zooming with Toggle Button

import 'package:flutter/material.dart';
import 'package:image_masking_flutter/image_masking_widget.dart';
import 'package:zoom_hover_pinch_image/zoom_hover_pinch_image.dart';

class ImageScreen extends StatelessWidget {
  const ImageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Image Masking',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ImageMaskingWidgetState> _imageMaskingKey =
  GlobalKey<ImageMaskingWidgetState>();
  bool isChecked = false; // Move this to be a class member

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          "SlideView",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),

      body: Stack(
        children: [
          Center(
            child: FittedBox(
              fit: BoxFit.contain,
              child:
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child:
                Zoom(
                  clipBehavior: true,
                  width: MediaQuery.of(context).size.width,
                  child:
                  Stack(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Image.asset(
                          "assets/Pathology/Renal_System/Slide2.PNG",
                          fit: BoxFit.contain,
                        ),
                      ),
                      if (isChecked)
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: Image.asset(
                            "assets/Pathology/Renal_System/Slide4.PNG",
                            fit: BoxFit.contain,
                          ),
                        ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: _buildCheckbox(),
                      ),
                    ],
                  ),
                ),
                ),
              ),
            ),
          ),
          // Positioned(
          //   top: 0,
          //   left: 0,
          //   right: 0,
          //   child: _buildTopBar(),
          // ),
          // Positioned(
          //   bottom: 80, // Moved up to make room for the checkbox
          //   left: 0,
          //   right: 0,
          //   child: _buildEraserButton(),
          // ),

        ],
      ),
    );
  }

  Widget _buildCheckbox() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Checkbox(
            value: isChecked,
            onChanged: (bool? newValue) {
              setState(() {
                isChecked = newValue ?? false;
              });
            },
          ),
          Text("Toggle Image", style: TextStyle(color: Colors.black)),
        ],
      ),
    );
  }


  // Widget _buildTopBar() {
  //   return Container(
  //     color: Colors.blue.withOpacity(0.7),
  //     width: double.infinity,
  //     height: 80,
  //     alignment: Alignment.center,
  //     child: const Text(
  //       "Image Masking with Zoom",
  //       style: TextStyle(
  //         fontWeight: FontWeight.w500,
  //         color: Colors.white,
  //         fontSize: 20,
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildEraserButton() {
  //   return Center(
  //     child: GestureDetector(
  //       onTap: () {
  //         _imageMaskingKey.currentState?.resetView();
  //       },
  //       child: Container(
  //         decoration: BoxDecoration(
  //           shape: BoxShape.circle,
  //           color: Colors.grey.shade200.withOpacity(0.7),
  //           border: Border.all(color: Colors.black, width: 1),
  //         ),
  //         padding: const EdgeInsets.all(10),
  //         child: const Icon(
  //           Icons.cleaning_services,
  //           size: 20,
  //         ),
  //       ),
  //     ),
  //   );
  // }
}

// Above is raw imlpementaion with sized bozes only
// import 'package:flutter/material.dart';
// import 'package:image_masking_flutter/image_masking_widget.dart';
// import 'package:zoom_hover_pinch_image/zoom_hover_pinch_image.dart';
//
// class ImageScreen extends StatelessWidget {
//   const ImageScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Image Masking',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const HomePage(),
//     );
//   }
// }
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   final GlobalKey<ImageMaskingWidgetState> _imageMaskingKey =
//       GlobalKey<ImageMaskingWidgetState>();
//
//   @override
//   Widget build(BuildContext context) {
//     bool isChecked = false;
//     return Scaffold(
//       body: Stack(
//         children: [
//           Center(
//             child: FittedBox(
//               fit: BoxFit.contain,
//               child: SizedBox(
//                 width: MediaQuery.of(context).size.width,
//                 height: MediaQuery.of(context).size.height,
//                 child: Zoom(
//                   clipBehavior: true,
//                   width: MediaQuery.of(context).size.width,
//                   child: Stack(
//                     children: [
//                       SizedBox(
//                         child: Image.asset("assets/Pathology/Renal_System/Slide4.jpg"),
//                         width: MediaQuery.of(context).size.width,
//                         height: MediaQuery.of(context).size.height,
//                       ),
//                       Checkbox(
//                         value: isChecked,
//                         onChanged: (bool? newValue) {
//                           setState(() {
//                             isChecked = newValue ?? false;
//                           });
//                         },
//                       ),
//                       if (isChecked)
//                         SizedBox(
//                           width: MediaQuery.of(context).size.width,
//                           height: MediaQuery.of(context).size.height,
//                           child: Image.asset(
//                               "assets/Pathology/Renal_System/Slide2.jpg"),
//                         ),
//                     ],
//                   ),
//                   //     child: ImageMaskingWidget(
//                   //       key: _imageMaskingKey,
//                   //       height: MediaQuery.of(context).size.height,
//                   //       width: MediaQuery.of(context).size.width,
//                   //       margin: EdgeInsets.zero,
//                   //       decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 2)),
//                   //       coloredImage: "assets/Pathology/Renal_System/Slide4.jpg",
//                   //       unColoredImage: "assets/Pathology/Renal_System/Slide2.jpg",
//                   //     ),
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             top: 0,
//             left: 0,
//             right: 0,
//             child: _buildTopBar(),
//           ),
//           Positioned(
//             bottom: 20,
//             left: 0,
//             right: 0,
//             child: _buildEraserButton(),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTopBar() {
//     return Container(
//       color: Colors.blue.withOpacity(0.7),
//       width: double.infinity,
//       height: 80,
//       alignment: Alignment.center,
//       child: const Text(
//         "Image Masking with Zoom",
//         style: TextStyle(
//           fontWeight: FontWeight.w500,
//           color: Colors.white,
//           fontSize: 20,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildEraserButton() {
//     return Center(
//       child: GestureDetector(
//         onTap: () {
//           _imageMaskingKey.currentState?.resetView();
//         },
//         child: Container(
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: Colors.grey.shade200.withOpacity(0.7),
//             border: Border.all(color: Colors.black, width: 1),
//           ),
//           padding: const EdgeInsets.all(10),
//           child: const Icon(
//             Icons.cleaning_services,
//             size: 20,
//           ),
//         ),
//       ),
//     );
//   }
// }

