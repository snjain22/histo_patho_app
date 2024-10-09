// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cached_network_image/cached_network_image.dart';
//
// import 'detailspage.dart';
//
// class SystemDetailPage extends StatefulWidget {
//   final int systemIndex;
//   final int initialTab;
//
//   const SystemDetailPage({
//     Key? key,
//     required this.systemIndex,
//     required this.initialTab
//   }) : super(key: key);
//
//   @override
//   _SystemDetailPageState createState() => _SystemDetailPageState();
// }
//
// class _SystemDetailPageState extends State<SystemDetailPage> {
//   late int _selectedIndex;
//   final FirebaseFirestore db = FirebaseFirestore.instance;
//
//   @override
//   void initState() {
//     super.initState();
//     _selectedIndex = widget.initialTab;
//   }
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   String _getSystemName(int index) {
//     List<String> systems = [
//       "ENDOCRINE SYSTEM", "FEMALE REPRODUCTIVE SYSTEM", "GASTROINTESTINAL SYSTEM",
//       "INTEGUMENTARY SYSTEM", "LYMPHATIC SYSTEM", "MALE REPRODUCTIVE SYSTEM", "RENAL SYSTEM",
//       "SKELETAL SYSTEM", "VASCULAR SYSTEM"
//     ];
//     systems.sort((a,b) => a.toLowerCase().compareTo(b.toLowerCase()));
//     return systems[index];
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     String systemName = _getSystemName(widget.systemIndex);
//     String subjectType = _selectedIndex == 0 ? "Histology" : "Pathology";
//     String dbCollection = '${subjectType.toLowerCase()}_slides';
//     List<String> sysNameshort = systemName.split(" ");
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("$systemName - $subjectType"),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: db.collection(dbCollection)
//             .doc(sysNameshort.first.toLowerCase())
//             .collection('slides')
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }
//
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text('No $subjectType data available for $systemName'));
//           }
//
//           return ListView.builder(
//             itemCount: snapshot.data!.docs.length,
//             itemBuilder: (context, index) {
//               var doc = snapshot.data!.docs[index].data() as Map<String, dynamic>;
//               List<String> imageLabelledList = List<String>.from(doc['image_labelled'] as List<dynamic>? ?? []);
//               String firstImage = imageLabelledList.isNotEmpty ? imageLabelledList.first : '';
//
//               return Card(
//                 margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                 child: Row(
//                   children: [
//                     Container(
//                       width: 40,
//                       height: 100,
//                       alignment: Alignment.center,
//                       color: Colors.cyan,
//                       child: Text(
//                         '${index + 1}',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 18,
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                         child: ListTile(
//                           title: Text(
//                             doc['title'] ?? 'Untitled',
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                             textAlign: TextAlign.center,
//                           ),
//                           trailing: firstImage.isNotEmpty
//                               ? CachedNetworkImage(
//                             imageUrl: firstImage,
//                             width: 100,
//                             height: 100,
//                             fit: BoxFit.cover,
//                             placeholder: (context, url) => CircularProgressIndicator(),
//                             errorWidget: (context, url, error) => Icon(Icons.error),
//                           )
//                               : SizedBox(width: 100, height: 100, child: Icon(Icons.image_not_supported)),
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => DetailPage(slideData: doc),
//                               ),
//                             );
//                           },
//                         )
//                     ),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.science),
//             label: 'Histology',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.local_hospital),
//             label: 'Pathology',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: Colors.cyan,
//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }

//LAST WORKING CODE
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
//
// import 'detailspage.dart';
//
// class SystemDetailPage extends StatefulWidget {
//   final int systemIndex;
//   final int initialTab;
//
//   const SystemDetailPage({
//     Key? key,
//     required this.systemIndex,
//     required this.initialTab
//   }) : super(key: key);
//
//   @override
//   _SystemDetailPageState createState() => _SystemDetailPageState();
// }
//
// class _SystemDetailPageState extends State<SystemDetailPage> {
//   late int _selectedIndex;
//   final FirebaseFirestore db = FirebaseFirestore.instance;
//
//   @override
//   void initState() {
//     super.initState();
//     _selectedIndex = widget.initialTab;
//   }
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   String _getSystemName(int index) {
//     List<String> systems = [
//       "ENDOCRINE SYSTEM", "FEMALE REPRODUCTIVE SYSTEM", "GASTROINTESTINAL SYSTEM",
//       "INTEGUMENTARY SYSTEM", "LYMPHATIC SYSTEM", "MALE REPRODUCTIVE SYSTEM", "RENAL SYSTEM",
//       "SKELETAL SYSTEM", "VASCULAR SYSTEM"
//     ];
//     systems.sort((a,b) => a.toLowerCase().compareTo(b.toLowerCase()));
//     return systems[index];
//   }
//
//   void _addNewContent() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => AddContentScreen(
//           systemName: _getSystemName(widget.systemIndex),
//           subjectType: _selectedIndex == 0 ? "Histology" : "Pathology",
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     String systemName = _getSystemName(widget.systemIndex);
//     String subjectType = _selectedIndex == 0 ? "Histology" : "Pathology";
//     String dbCollection = '${subjectType.toLowerCase()}_slides';
//     List<String> sysNameshort = systemName.split(" ");
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("$systemName - $subjectType"),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: db.collection(dbCollection)
//             .doc(sysNameshort.first.toLowerCase())
//             .collection('slides')
//             .snapshots(),
//     builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }
//
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text('No $subjectType data available for $systemName'));
//           }
//
//           return ListView.builder(
//             itemCount: snapshot.data!.docs.length,
//             itemBuilder: (context, index) {
//               var doc = snapshot.data!.docs[index].data() as Map<String, dynamic>;
//               List<String> imageLabelledList = List<String>.from(doc['image_labelled'] as List<dynamic>? ?? []);
//               String firstImage = imageLabelledList.isNotEmpty ? imageLabelledList.first : '';
//
//               return Card(
//                 margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                 child: Row(
//                   children: [
//                     Container(
//                       width: 40,
//                       height: 100,
//                       alignment: Alignment.center,
//                       color: Colors.cyan,
//                       child: Text(
//                         '${index + 1}',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 18,
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                         child: ListTile(
//                           title: Text(
//                             doc['title'] ?? 'Untitled',
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                             textAlign: TextAlign.center,
//                           ),
//                           trailing: firstImage.isNotEmpty
//                               ? CachedNetworkImage(
//                             imageUrl: firstImage,
//                             width: 100,
//                             height: 100,
//                             fit: BoxFit.cover,
//                             placeholder: (context, url) => CircularProgressIndicator(),
//                             errorWidget: (context, url, error) => Icon(Icons.error),
//                           )
//                               : SizedBox(width: 100, height: 100, child: Icon(Icons.image_not_supported)),
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => DetailPage(slideData: doc),
//                               ),
//                             );
//                           },
//                         )
//                     ),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.science),
//             label: 'Histology',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.local_hospital),
//             label: 'Pathology',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: Colors.cyan,
//         onTap: _onItemTapped,
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _addNewContent,
//         child: Icon(Icons.add),
//         backgroundColor: Colors.cyan,
//       ),
//     );
//   }
// }
//
// class AddContentScreen extends StatefulWidget {
//   final String systemName;
//   final String subjectType;
//
//   AddContentScreen({required this.systemName, required this.subjectType});
//
//   @override
//   _AddContentScreenState createState() => _AddContentScreenState();
// }
//
// class _AddContentScreenState extends State<AddContentScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _titleController = TextEditingController();
//   final _descriptionController = TextEditingController();
//   List<File> _labelledImages = [];
//   List<File> _unlabelledImages = [];
//
//   Future<void> _pickImage(bool isLabelled) async {
//     final ImagePicker _picker = ImagePicker();
//     final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
//
//     if (image != null) {
//       setState(() {
//         if (isLabelled) {
//           _labelledImages.add(File(image.path));
//         } else {
//           _unlabelledImages.add(File(image.path));
//         }
//       });
//     }
//   }
//
//   Future<void> _submitForm() async {
//     if (_formKey.currentState!.validate()) {
//       try {
//         List<String> labelledUrls = await _uploadImages(_labelledImages, true);
//         List<String> unlabelledUrls = await _uploadImages(_unlabelledImages, false);
//
//         await FirebaseFirestore.instance
//             .collection('${widget.subjectType.toLowerCase()}_slides')
//             .doc(widget.systemName.split(" ").first.toLowerCase())
//             .collection('slides')
//             .add({
//           'title': _titleController.text,
//           'description': _descriptionController.text,
//           'image_labelled': labelledUrls,
//           'image_unlabelled': unlabelledUrls,
//           'createdOn': FieldValue.serverTimestamp(),
//         });
//
//         Navigator.pop(context);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Content added successfully')),
//         );
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error adding content: $e')),
//         );
//       }
//     }
//   }
//
//   Future<List<String>> _uploadImages(List<File> images, bool isLabelled) async {
//     List<String> urls = [];
//     for (var image in images) {
//       String fileName = DateTime.now().millisecondsSinceEpoch.toString();
//       Reference storageRef = FirebaseStorage.instance.ref().child(
//           '${widget.subjectType.toLowerCase()}_slides/${widget.systemName}/${isLabelled ? 'labelled' : 'unlabelled'}/$fileName');
//       await storageRef.putFile(image);
//       String downloadUrl = await storageRef.getDownloadURL();
//       urls.add(downloadUrl);
//     }
//     return urls;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Add New Content'),
//       ),
//       body: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//           padding: EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               TextFormField(
//                 controller: _titleController,
//                 decoration: InputDecoration(labelText: 'Title'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a title';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _descriptionController,
//                 decoration: InputDecoration(labelText: 'Description'),
//                 maxLines: 3,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a description';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 20),
//               Text('Labelled Images:'),
//               ElevatedButton(
//                 onPressed: () => _pickImage(true),
//                 child: Text('Add Labelled Image'),
//               ),
//               _buildImageList(_labelledImages),
//               SizedBox(height: 20),
//               Text('Unlabelled Images:'),
//               ElevatedButton(
//                 onPressed: () => _pickImage(false),
//                 child: Text('Add Unlabelled Image'),
//               ),
//               _buildImageList(_unlabelledImages),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _submitForm,
//                 child: Text('Submit'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildImageList(List<File> images) {
//     return Container(
//       height: 100,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: images.length,
//         itemBuilder: (context, index) {
//           return Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Image.file(images[index], width: 80, height: 80, fit: BoxFit.cover),
//           );
//         },
//       ),
//     );
//   }
// }



import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'detailspage.dart';

class SystemDetailPage extends StatefulWidget {
  final int systemIndex;
  final int initialTab;

  const SystemDetailPage({
    Key? key,
    required this.systemIndex,
    required this.initialTab
  }) : super(key: key);

  @override
  _SystemDetailPageState createState() => _SystemDetailPageState();
}

class _SystemDetailPageState extends State<SystemDetailPage> {
  late int _selectedIndex;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  bool isAdminOrTeacher = false;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialTab;
    _checkUserRole();
  }

  Future<void> _checkUserRole() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        String userType = (userDoc.data() as Map<String, dynamic>)['userType'] ?? '';
        setState(() {
          isAdminOrTeacher = userType == 'admin' || userType == 'teacher';
        });
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String _getSystemName(int index) {
    List<String> systems = [
      "ENDOCRINE SYSTEM", "FEMALE REPRODUCTIVE SYSTEM", "GASTROINTESTINAL SYSTEM",
      "INTEGUMENTARY SYSTEM", "LYMPHATIC SYSTEM", "MALE REPRODUCTIVE SYSTEM", "RENAL SYSTEM",
      "SKELETAL SYSTEM", "VASCULAR SYSTEM"
    ];
    systems.sort((a,b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return systems[index];
  }

  void _addNewContent() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddContentScreen(
          systemName: _getSystemName(widget.systemIndex),
          subjectType: _selectedIndex == 0 ? "Histology" : "Pathology",
        ),
      ),
    );
  }

  void _editContent(String slideId, Map<String, dynamic> slideData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddContentScreen(
          systemName: _getSystemName(widget.systemIndex),
          subjectType: _selectedIndex == 0 ? "Histology" : "Pathology",
          slideId: slideId,
          existingData: slideData,
        ),
      ),
    );
  }

  void _deleteContent(String slideId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Content"),
          content: Text("Are you sure you want to delete this content?"),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("Delete"),
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await FirebaseFirestore.instance
                      .collection('${_selectedIndex == 0 ? "histology" : "pathology"}_slides')
                      .doc(_getSystemName(widget.systemIndex).split(" ").first.toLowerCase())
                      .collection('slides')
                      .doc(slideId)
                      .delete();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Content deleted successfully')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error deleting content: $e')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String systemName = _getSystemName(widget.systemIndex);
    String subjectType = _selectedIndex == 0 ? "Histology" : "Pathology";
    String dbCollection = '${subjectType.toLowerCase()}_slides';
    List<String> sysNameshort = systemName.split(" ");

    return Scaffold(
      appBar: AppBar(
        title: Text("$systemName - $subjectType"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: db.collection(dbCollection)
            .doc(sysNameshort.first.toLowerCase())
            .collection('slides')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No $subjectType data available for $systemName'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs[index];
              var slideData = doc.data() as Map<String, dynamic>;
              List<String> imageLabelledList = List<String>.from(slideData['image_labelled'] as List<dynamic>? ?? []);
              String firstImage = imageLabelledList.isNotEmpty ? imageLabelledList.first : '';

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 100,
                      alignment: Alignment.center,
                      color: Colors.cyan,
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: Text(
                          slideData['title'] ?? 'Untitled',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        // subtitle: Text(slideData['description'].toString().substring(0,50)+"..." ?? ''),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isAdminOrTeacher) ...[
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () => _editContent(doc.id, slideData),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => _deleteContent(doc.id),
                              ),
                            ],
                            if (firstImage.isNotEmpty)
                              CachedNetworkImage(
                                imageUrl: firstImage,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => CircularProgressIndicator(),
                                errorWidget: (context, url, error) => Icon(Icons.error),
                              )
                            else
                              SizedBox(width: 60, height: 60, child: Icon(Icons.image_not_supported)),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPage(slideData: slideData),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.science),
            label: 'Histology',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_hospital),
            label: 'Pathology',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.cyan,
        onTap: _onItemTapped,
      ),
      floatingActionButton: isAdminOrTeacher ? FloatingActionButton(
        onPressed: _addNewContent,
        child: Icon(Icons.add),
        backgroundColor: Colors.cyan,
      ) : null,
    );
  }
}

class AddContentScreen extends StatefulWidget {
  final String systemName;
  final String subjectType;
  final String? slideId;
  final Map<String, dynamic>? existingData;

  AddContentScreen({
    required this.systemName,
    required this.subjectType,
    this.slideId,
    this.existingData,
  });

  @override
  _AddContentScreenState createState() => _AddContentScreenState();
}

class _AddContentScreenState extends State<AddContentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  List<File> _labelledImages = [];
  List<File> _unlabelledImages = [];
  List<Map<String, dynamic>> _questions = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingData != null) {
      _titleController.text = widget.existingData!['title'];
      _descriptionController.text = widget.existingData!['description'];
      // Load existing images if needed
      _questions = List<Map<String, dynamic>>.from(widget.existingData!['questions'] ?? []);
    }
  }

  Future<void> _pickMultipleImages(bool isLabelled) async {
    final ImagePicker _picker = ImagePicker();
    final List<XFile>? images = await _picker.pickMultiImage();

    if (images != null) {
      setState(() {
        if (isLabelled) {
          _labelledImages.addAll(images.map((image) => File(image.path)));
        } else {
          _unlabelledImages.addAll(images.map((image) => File(image.path)));
        }
      });
    }
  }

  void _addQuestion() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController questionController = TextEditingController();
        TextEditingController correctAnswerController = TextEditingController();
        List<TextEditingController> optionControllers = List.generate(4, (i) => TextEditingController());
        File? questionImage;

        return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text('Add Question'),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextField(
                        controller: questionController,
                        decoration: InputDecoration(labelText: 'Question'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final ImagePicker _picker = ImagePicker();
                          final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                          if (image != null) {
                            setState(() {
                              questionImage = File(image.path);
                            });
                          }
                        },
                        child: Text('Add Question Image'),
                      ),
                      if (questionImage != null)
                        Image.file(questionImage!, height: 100, width: 100, fit: BoxFit.cover),
                      ...optionControllers.map((controller) => TextField(
                        controller: controller,
                        decoration: InputDecoration(labelText: 'Option'),
                      )).toList(),
                      TextField(
                        controller: correctAnswerController,
                        decoration: InputDecoration(labelText: 'Correct Answer'),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    child: Text('Cancel'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  TextButton(
                    child: Text('Add'),
                    onPressed: () {
                      if (_validateQuestion(questionController.text, optionControllers.map((c) => c.text).toList(), correctAnswerController.text)) {
                        setState(() {
                          _questions.add({
                            'text': questionController.text,
                            'options': optionControllers.map((c) => c.text).toList(),
                            'correctAnswer': correctAnswerController.text,
                            'image': questionImage != null ? questionImage!.path : null,
                          });
                        });
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              );
            }
        );
      },
    ).then((_) => setState(() {})); // Refresh the screen after adding a question
  }

  bool _validateQuestion(String question, List<String> options, String correctAnswer) {
    if (question.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Question cannot be empty')));
      return false;
    }
    if (options.any((option) => option.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('All options must be filled')));
      return false;
    }
    if (!options.contains(correctAnswer)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Correct answer must be one of the options')));
      return false;
    }
    return true;
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        List<String> labelledUrls = await _uploadImages(_labelledImages, true);
        List<String> unlabelledUrls = await _uploadImages(_unlabelledImages, false);
        List<Map<String, dynamic>> processedQuestions = await _processQuestions();

        await FirebaseFirestore.instance
            .collection('${widget.subjectType.toLowerCase()}_slides')
            .doc(widget.systemName.split(" ").first.toLowerCase())
            .collection('slides')
            .add({
          'title': _titleController.text,
          'description': _descriptionController.text,
          'image_labelled': labelledUrls,
          'image_unlabelled': unlabelledUrls,
          'questions': processedQuestions,
          'createdOn': FieldValue.serverTimestamp(),
        });

        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Content added successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding content: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<List<Map<String, dynamic>>> _processQuestions() async {
    List<Map<String, dynamic>> processedQuestions = [];
    for (var question in _questions) {
      String? imageUrl;
      if (question['image'] != null) {
        File imageFile = File(question['image']);
        imageUrl = await _uploadSingleImage(imageFile, 'questions');
      }
      processedQuestions.add({
        'text': question['text'],
        'options': question['options'],
        'correctAnswer': question['correctAnswer'],
        'image': imageUrl,
      });
    }
    return processedQuestions;
  }

  Future<List<String>> _uploadImages(List<File> images, bool isLabelled) async {
    List<String> urls = [];
    for (var image in images) {
      String url = await _uploadSingleImage(image, isLabelled ? 'labelled' : 'unlabelled');
      urls.add(url);
    }
    return urls;
  }

  Future<String> _uploadSingleImage(File image, String folder) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageRef = FirebaseStorage.instance.ref().child(
        '${widget.subjectType.toLowerCase()}_slides/${widget.systemName}/$folder/$fileName');
    await storageRef.putFile(image);
    return await storageRef.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Content'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Text('Labelled Images:'),
              ElevatedButton(
                onPressed: () => _pickMultipleImages(true),
                child: Text('Add Labelled Images'),
              ),
              _buildImageList(_labelledImages),
              SizedBox(height: 20),
              Text('Unlabelled Images:'),
              ElevatedButton(
                onPressed: () => _pickMultipleImages(false),
                child: Text('Add Unlabelled Images'),
              ),
              _buildImageList(_unlabelledImages),
              SizedBox(height: 20),
              Text('Questions:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ElevatedButton(
                onPressed: _addQuestion,
                child: Text('Add Question'),
              ),
              _buildQuestionList(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageList(List<File> images) {
    return Container(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.file(images[index], width: 80, height: 80, fit: BoxFit.cover),
          );
        },
      ),
    );
  }

  Widget _buildQuestionList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _questions.length,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            title: Text(_questions[index]['text']),
            subtitle: Text('Correct Answer: ${_questions[index]['correctAnswer']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_questions[index]['image'] != null)
                  Icon(Icons.image),
                // IconButton(
                //   icon: Icon(Icons.edit),
                //   onPressed: () => _editQuestion(index),
                // ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      _questions.removeAt(index);
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

















// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'dart:io';
//
// import 'detailspage.dart';
//
// class SystemDetailPage extends StatefulWidget {
//   final int systemIndex;
//   final int initialTab;
//
//   const SystemDetailPage({
//     Key? key,
//     required this.systemIndex,
//     required this.initialTab
//   }) : super(key: key);
//
//   @override
//   _SystemDetailPageState createState() => _SystemDetailPageState();
// }
//
// class _SystemDetailPageState extends State<SystemDetailPage> {
//   late int _selectedIndex;
//   final FirebaseFirestore db = FirebaseFirestore.instance;
//   bool isAdminOrTeacher = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _selectedIndex = widget.initialTab;
//     _checkUserRole();
//   }
//
//   void _checkUserRole() async {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
//       if (userDoc.exists) {
//         String userType = (userDoc.data() as Map<String, dynamic>)['userType'] ?? '';
//         setState(() {
//           isAdminOrTeacher = userType == 'admin' || userType == 'teacher';
//         });
//       }
//     }
//   }
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   String _getSystemName(int index) {
//     List<String> systems = [
//       "ENDOCRINE SYSTEM", "FEMALE REPRODUCTIVE SYSTEM", "GASTROINTESTINAL SYSTEM",
//       "INTEGUMENTARY SYSTEM", "LYMPHATIC SYSTEM", "MALE REPRODUCTIVE SYSTEM", "RENAL SYSTEM",
//       "SKELETAL SYSTEM", "VASCULAR SYSTEM"
//     ];
//     systems.sort((a,b) => a.toLowerCase().compareTo(b.toLowerCase()));
//     return systems[index];
//   }
//
//   void _addNewContent() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => AddContentScreen(
//           systemName: _getSystemName(widget.systemIndex),
//           subjectType: _selectedIndex == 0 ? "Histology" : "Pathology",
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     String systemName = _getSystemName(widget.systemIndex);
//     String subjectType = _selectedIndex == 0 ? "Histology" : "Pathology";
//     String dbCollection = '${subjectType.toLowerCase()}_slides';
//     List<String> sysNameshort = systemName.split(" ");
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("$systemName - $subjectType"),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: db.collection(dbCollection)
//             .doc(sysNameshort.first.toLowerCase())
//             .collection('slides')
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }
//
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text('No $subjectType data available for $systemName'));
//           }
//
//           return ListView.builder(
//             itemCount: snapshot.data!.docs.length,
//             itemBuilder: (context, index) {
//               var doc = snapshot.data!.docs[index].data() as Map<String, dynamic>;
//               List<String> imageLabelledList = List<String>.from(doc['image_labelled'] as List<dynamic>? ?? []);
//               String firstImage = imageLabelledList.isNotEmpty ? imageLabelledList.first : '';
//
//               return Card(
//                 margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                 child: Row(
//                   children: [
//                     Container(
//                       width: 40,
//                       height: 100,
//                       alignment: Alignment.center,
//                       color: Colors.cyan,
//                       child: Text(
//                         '${index + 1}',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 18,
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                         child: ListTile(
//                           title: Text(
//                             doc['title'] ?? 'Untitled',
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                             textAlign: TextAlign.center,
//                           ),
//                           trailing: firstImage.isNotEmpty
//                               ? CachedNetworkImage(
//                             imageUrl: firstImage,
//                             width: 100,
//                             height: 100,
//                             fit: BoxFit.cover,
//                             placeholder: (context, url) => CircularProgressIndicator(),
//                             errorWidget: (context, url, error) => Icon(Icons.error),
//                           )
//                               : SizedBox(width: 100, height: 100, child: Icon(Icons.image_not_supported)),
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => DetailPage(slideData: doc),
//                               ),
//                             );
//                           },
//                         )
//                     ),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.science),
//             label: 'Histology',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.local_hospital),
//             label: 'Pathology',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: Colors.cyan,
//         onTap: _onItemTapped,
//       ),
//       floatingActionButton: isAdminOrTeacher ? FloatingActionButton(
//         onPressed: _addNewContent,
//         child: Icon(Icons.add),
//         backgroundColor: Colors.cyan,
//       ) : null,
//     );
//   }
// }
//
// class AddContentScreen extends StatefulWidget {
//   final String systemName;
//   final String subjectType;
//
//   AddContentScreen({required this.systemName, required this.subjectType});
//
//   @override
//   _AddContentScreenState createState() => _AddContentScreenState();
// }
//
// class _AddContentScreenState extends State<AddContentScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _titleController = TextEditingController();
//   final _descriptionController = TextEditingController();
//   List<File> _labelledImages = [];
//   List<File> _unlabelledImages = [];
//   List<Map<String, dynamic>> _questions = [];
//
//   Future<void> _pickImages(bool isLabelled) async {
//     final ImagePicker _picker = ImagePicker();
//     final List<XFile>? images = await _picker.pickMultiImage();
//
//     if (images != null) {
//       setState(() {
//         if (isLabelled) {
//           _labelledImages.addAll(images.map((image) => File(image.path)));
//         } else {
//           _unlabelledImages.addAll(images.map((image) => File(image.path)));
//         }
//       });
//     }
//   }
//
//   void _addQuestion() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         TextEditingController questionController = TextEditingController();
//         TextEditingController correctAnswerController = TextEditingController();
//         List<TextEditingController> optionControllers = List.generate(4, (i) => TextEditingController());
//         File? questionImage;
//
//         return StatefulBuilder(
//             builder: (context, setState) {
//               return AlertDialog(
//                 title: Text('Add Question'),
//                 content: SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       TextField(
//                         controller: questionController,
//                         decoration: InputDecoration(labelText: 'Question'),
//                       ),
//                       ...optionControllers.map((controller) => TextField(
//                         controller: controller,
//                         decoration: InputDecoration(labelText: 'Option'),
//                       )).toList(),
//                       TextField(
//                         controller: correctAnswerController,
//                         decoration: InputDecoration(labelText: 'Correct Answer'),
//                       ),
//                       ElevatedButton(
//                         child: Text('Add Question Image'),
//                         onPressed: () async {
//                           final ImagePicker _picker = ImagePicker();
//                           final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
//                           if (image != null) {
//                             setState(() {
//                               questionImage = File(image.path);
//                             });
//                           }
//                         },
//                       ),
//                       if (questionImage != null)
//                         Image.file(questionImage!, height: 100, width: 100),
//                     ],
//                   ),
//                 ),
//                 actions: [
//                   TextButton(
//                     child: Text('Cancel'),
//                     onPressed: () => Navigator.of(context).pop(),
//                   ),
//                   TextButton(
//                     child: Text('Add'),
//                     onPressed: () async {
//                       String? imageUrl;
//                       if (questionImage != null) {
//                         imageUrl = await _uploadImage(questionImage!, 'question_images');
//                       }
//                       setState(() {
//                         _questions.add({
//                           'text': questionController.text,
//                           'options': optionControllers.map((c) => c.text).toList(),
//                           'correctAnswer': correctAnswerController.text,
//                           if (imageUrl != null) 'image': imageUrl,
//                         });
//                       });
//                       Navigator.of(context).pop();
//                     },
//                   ),
//                 ],
//               );
//             }
//         );
//       },
//     );
//   }
//
//   Future<void> _submitForm() async {
//     if (_formKey.currentState!.validate()) {
//       try {
//         List<String> labelledUrls = await _uploadImages(_labelledImages, 'labelled');
//         List<String> unlabelledUrls = await _uploadImages(_unlabelledImages, 'unlabelled');
//
//         await FirebaseFirestore.instance
//             .collection('${widget.subjectType.toLowerCase()}_slides')
//             .doc(widget.systemName.split(" ").first.toLowerCase())
//             .collection('slides')
//             .add({
//           'title': _titleController.text,
//           'description': _descriptionController.text,
//           'image_labelled': labelledUrls,
//           'image_unlabelled': unlabelledUrls,
//           'questions': _questions,
//           'createdOn': FieldValue.serverTimestamp(),
//         });
//
//         Navigator.pop(context);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Content added successfully')),
//         );
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error adding content: $e')),
//         );
//       }
//     }
//   }
//
//   Future<List<String>> _uploadImages(List<File> images, String folder) async {
//     List<String> urls = [];
//     for (var image in images) {
//       String url = await _uploadImage(image, folder);
//       urls.add(url);
//     }
//     return urls;
//   }
//
//   Future<String> _uploadImage(File image, String folder) async {
//     String fileName = DateTime.now().millisecondsSinceEpoch.toString();
//     Reference storageRef = FirebaseStorage.instance.ref().child(
//         '${widget.subjectType.toLowerCase()}_slides/${widget.systemName}/$folder/$fileName');
//     await storageRef.putFile(image);
//     return await storageRef.getDownloadURL();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Add New Content'),
//       ),
//       body: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//           padding: EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               TextFormField(
//                 controller: _titleController,
//                 decoration: InputDecoration(labelText: 'Title'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a title';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _descriptionController,
//                 decoration: InputDecoration(labelText: 'Description'),
//                 maxLines: 3,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a description';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 20),
//               Text('Labelled Images:'),
//               ElevatedButton(
//                 onPressed: () => _pickImages(true),
//                 child: Text('Add Labelled Images'),
//               ),
//               _buildImageList(_labelledImages),
//               SizedBox(height: 20),
//               Text('Unlabelled Images:'),
//               ElevatedButton(
//                 onPressed: () => _pickImages(false),
//                 child: Text('Add Unlabelled Images'),
//               ),
//               _buildImageList(_unlabelledImages),
//               SizedBox(height: 20),
//               Text('Questions:'),
//               ElevatedButton(
//                 onPressed: _addQuestion,
//                 child: Text('Add Question'),
//               ),
//               _buildQuestionList(),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _submitForm,
//                 child: Text('Submit'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildImageList(List<File> images) {
//     return Container(
//       height: 100,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: images.length,
//         itemBuilder: (context, index) {
//           return Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Image.file(images[index], width: 80, height: 80, fit: BoxFit.cover),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildQuestionList() {
//     return ListView.builder(
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       itemCount: _questions.length,
//       itemBuilder: (context, index) {
//         return ListTile(
//           title: Text(_questions[index]['text']),
//           subtitle: Text('Correct Answer: ${_questions[index]['correctAnswer']}'),
//           trailing: IconButton(
//             icon: Icon(Icons.delete),
//             onPressed: () {
//               setState(() {
//                 _questions.removeAt(index);
//               });
//             },
//           ),
//         );
//       },
//     );
//   }
// }