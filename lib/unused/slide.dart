// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class Question {
//   final String text;
//   final Map<String, String> answer;
//   final List<String> options;
//   final String? photoUrl;
//
//   Question({
//     required this.text,
//     required this.answer,
//     required this.options,
//     this.photoUrl,
//   });
//
//   factory Question.fromMap(Map<String, dynamic> map) {
//     return Question(
//       text: map['text'] ?? '',
//       answer: Map<String, String>.from(map['answer'] ?? {}),
//       options: List<String>.from(map['options'] ?? []),
//       photoUrl: map['photoUrl'],
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'text': text,
//       'answer': answer,
//       'options': options,
//       if (photoUrl != null) 'photoUrl': photoUrl,
//     };
//   }
// }
//
// class Slide {
//   final String title;
//   final String description;
//   final String imageLabelledUrl;
//   final String imageUnlabelledUrl;
//   final List<Question> questions;
//   final Timestamp createdOn;
//
//   Slide({
//     required this.title,
//     required this.description,
//     required this.imageLabelledUrl,
//     required this.imageUnlabelledUrl,
//     required this.questions,
//     required this.createdOn,
//   });
//
//   factory Slide.fromFirestore(DocumentSnapshot doc) {
//     Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//     return Slide(
//       title: data['title'] ?? '',
//       description: data['description'] ?? '',
//       imageLabelledUrl: data['image_labelled'] ?? '',
//       imageUnlabelledUrl: data['image_unlabelled'] ?? '',
//       questions: (data['question'] as List<dynamic>?)
//           ?.map((q) => Question.fromMap(q))
//           .toList() ?? [],
//       createdOn: data['createdOn'] ?? Timestamp.now(),
//     );
//   }
//
//   Map<String, dynamic> toFirestore() {
//     return {
//       'title': title,
//       'description': description,
//       'image_labelled': imageLabelledUrl,
//       'image_unlabelled': imageUnlabelledUrl,
//       'question': questions.map((q) => q.toMap()).toList(),
//       'createdOn': createdOn,
//     };
//   }
//
//   // static Future<Slide?> getSlideById(String slideId) async {
//   //   try {
//   //     DocumentSnapshot doc = await FirebaseFirestore.instance
//   //         .collection('pathology_slides')
//   //         .doc(slideId)
//   //         .get();
//   //     if (doc.exists) {
//   //       return Slide.fromFirestore(doc);
//   //     }
//   //   } catch (e) {
//   //     print('Error fetching slide: $e');
//   //   }
//   //   return null;
//   // }
//   //
//   // Future<void> saveSlide() async {
//   //   try {
//   //     await FirebaseFirestore.instance
//   //         .collection('pathology_slides')
//   //         .add(toFirestore());
//   //   } catch (e) {
//   //     print('Error saving slide: $e');
//   //   }
//   // }
//
//   static Stream<List<Slide>> getAllSlides() {
//     return FirebaseFirestore.instance
//         .collection('pathology_slides/')
//         .snapshots()
//         .map((snapshot) =>
//         snapshot.docs.map((doc) => Slide.fromFirestore(doc)).toList());
//   }
// }
//


import 'package:cloud_firestore/cloud_firestore.dart';

class Slide {
  final DateTime createdOn;
  final String description;
  final String imageLabelledUrl;
  final String imageUnlabelledUrl;
  final String title;
  final List<Question> questions;

  Slide({
    required this.createdOn,
    required this.description,
    required this.imageLabelledUrl,
    required this.imageUnlabelledUrl,
    required this.title,
    required this.questions,
  });

  factory Slide.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Slide(
      createdOn: (data['createdOn'] as Timestamp).toDate(),
      description: data['description'] ?? '',
      imageLabelledUrl: data['image_labelled'] ?? '',
      imageUnlabelledUrl: data['image_unlabelled'] ?? '',
      title: data['title'] ?? '',
      questions: (data['question'] as List<dynamic>?)
          ?.map((q) => Question.fromMap(q))
          .toList() ?? [],
    );
  }

  static Future<Slide> getSlideFromFirestore(String documentId) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('slides')
        .doc(documentId)
        .get();
    return Slide.fromFirestore(doc);
  }
}

class Question {
  final String text;
  final String? photoUrl;  // Make photoUrl nullable
  final List<String> options;
  final Map<String, String> answer;

  Question({
    required this.text,
    this.photoUrl,  // Remove 'required' keyword
    required this.options,
    required this.answer,
  });

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      text: map['text'] ?? '',
      photoUrl: map['photoUrl'],  // No need for null coalescing here
      options: List<String>.from(map['options'] ?? []),
      answer: Map<String, String>.from(map['answer'] ?? {}),
    );
  }
}