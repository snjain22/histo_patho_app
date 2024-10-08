// import 'package:flutter/material.dart';
//
// class WilmsPage extends StatefulWidget {
//   @override
//   _WilmsPageState createState() => _WilmsPageState();
// }
//
// class _WilmsPageState extends State<WilmsPage> {
//   Map<String, bool> isChecked = {};
//
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('WILMS TUMOUR'),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(
//               child: ListView(
//                 children: [
//                   _buildImageCard(
//                     context,
//                     'assets/Pathology/Renal_System/Slide2.PNG',
//                     'Nephroblastoma',
//                     'The renal cortex contains sections of renal corpuslces made of glomerulus in the center and coveredby the Bownman’s capsule. The sections of renal tubules those are proximal and distal convolutedtubules are seen abundantly. The extension of the medulla into the cortex is called medullary rayswhich contain parts of the collecting tubules and the loop of Henle',
//                   ),
//                   _buildImageCard(
//                     context,
//                     'assets/image2.png', // Add your image assets here
//                     'Title 2',
//                     'This is a description for image 2. It provides more details.',
//                   ),
//                   _buildImageCard(
//                     context,
//                     'assets/image3.png', // Add your image assets here
//                     'Title 3',
//                     'This is a description for image 3. It provides more details.',
//                   ),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(top: 20),
//               child: MaterialButton(
//                 onPressed: () {
//                   // Handle quiz button press
//                 },
//                 padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
//                 color: Colors.blue,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 minWidth: double.infinity,
//                 height: 50,
//                 child: Text(
//                   'Take a Quiz',
//                   style: TextStyle(fontSize: 18, color: Colors.white),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildImageCard(BuildContext context, String imagePath, String title, String description) {
//     return Card(
//       elevation: 5,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15),
//       ),
//       margin: EdgeInsets.symmetric(vertical: 10),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
//             child: Image.asset(
//               imagePath,
//               fit: BoxFit.cover,
//               width: double.infinity,
//               height: 200,
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 Text(
//                   description,
//                   style: TextStyle(fontSize: 16),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
// }


import 'package:flutter/material.dart';
import 'package:zoom_hover_pinch_image/zoom_hover_pinch_image.dart';

class WilmsPage extends StatefulWidget {
  @override
  _WilmsPageState createState() => _WilmsPageState();
}

class _WilmsPageState extends State<WilmsPage> {
  Map<String, bool> isChecked = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WILMS TUMOUR'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildImageCard(
                      context,
                      'assets/Pathology/Renal_System/Slide2.PNG',
                      'Nephroblastoma',
                      "The renal cortex contains sections of renal corpuscles made of glomerulus in the center and covered by the Bowman's capsule. The sections of renal tubules those are proximal and distal convoluted tubules are seen abundantly. The extension of the medulla into the cortex is called medullary rays which contain parts of the collecting tubules and the loop of Henle",
                  ),
                  // Add more _buildImageCard calls here for additional images
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: MaterialButton(
                onPressed: () {
                  // Handle quiz button press
                },
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                minWidth: double.infinity,
                height: 50,
                child: Text(
                  'Take a Quiz',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCard(BuildContext context, String imagePath, String title, String description) {
    if (!isChecked.containsKey(title)) {
      isChecked[title] = false;
    }

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            child: SizedBox(
              height: 300,
              child: Zoom(
                clipBehavior: true,
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  isChecked[title]! ? imagePath.replaceAll('Slide2', 'Slide4') : imagePath,
                  fit: BoxFit.contain,
                  width: double.infinity,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  description,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Checkbox(
                      value: isChecked[title],
                      onChanged: (bool? newValue) {
                        setState(() {
                          isChecked[title] = newValue ?? false;
                        });
                      },
                    ),
                    Text("Toggle Image", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}