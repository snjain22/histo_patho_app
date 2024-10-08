import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:histo_patho_app/unused/slide.dart';


class SlidesPage extends StatelessWidget {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pathology Slides'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: db.collection("pathology_slides").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          List<Slide> slides = snapshot.data!.docs
              .map((doc) => Slide.fromFirestore(doc))
              .where((slide) => slide.title.contains("oma"))
              .toList();

          if (slides.isEmpty) {
            return Center(child: Text('No matching slides found'));
          }

          return ListView.builder(
            itemCount: slides.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  // Text(slides[index].title + index.toString()),
                  // Text("https://" + slides[index].imageLabelledUrl),
                  Text(slides[index].title),
                  Text(slides[index].questions.toString()),
                  Text(slides[index].description),
                  Image.network("https://" + slides[index].imageLabelledUrl),

                ],
              );
            },
          );
        },
      ),
    );
  }
}

class SlideCard extends StatelessWidget {
  final Slide slide;

  const SlideCard({Key? key, required this.slide}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: ExpansionTile(
        title: Text(slide.title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Created on: ${slide.createdOn.toString()}'),
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Description:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(slide.description),
                SizedBox(height: 16),
                Text('Images:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Labelled: ${slide.imageLabelledUrl}'),
                Text('Unlabelled: ${slide.imageUnlabelledUrl}'),
                SizedBox(height: 16),
                Text('Questions:', style: TextStyle(fontWeight: FontWeight.bold)),
                ...slide.questions.map((question) => QuestionWidget(question: question)).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class QuestionWidget extends StatelessWidget {
  final Question question;

  const QuestionWidget({Key? key, required this.question}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(question.text, style: TextStyle(fontWeight: FontWeight.bold)),
          if (question.photoUrl != null)
            Text('Photo URL: ${question.photoUrl}'),
          Text('Options:'),
          ...question.options.map((option) => Text('- $option')).toList(),
          Text('Answer: ${question.answer.values.first}'),
        ],
      ),
    );
  }
}