import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FirebaseListView extends StatelessWidget {
  final int systemIndex;
  final bool isHistology; // true for Histology, false for Pathology

  const FirebaseListView({
    Key? key,
    required this.systemIndex,
    required this.isHistology
  }) : super(key: key);

  String _getSystemName(int index) {
    List<String> systems = [
      "ENDOCRINE SYSTEM", "FEMALE REPRODUCTIVE SYSTEM", "GASTROINTESTINAL SYSTEM",
      "INTEGUMENTARY SYSTEM", "LYMPHATIC SYSTEM", "MALE REPRODUCTIVE SYSTEM", "RENAL SYSTEM",
      "SKELETAL SYSTEM", "VASCULAR SYSTEM"
    ];
    systems.sort((a,b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return systems[index];
  }

  @override
  Widget build(BuildContext context) {
    String systemName = _getSystemName(systemIndex);
    String subjectType = isHistology ? "Histology" : "Pathology";
    String subString = subjectType.substring(0,4);
    print('$subjectType.lower()''_slides');
    return Scaffold(
      appBar: AppBar(
        title: Text("$systemName"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('$subjectType.lower()''_slides')
            // .where('system', isEqualTo: systemName)
            // .where('type', isEqualTo: subjectType)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            // print();
            return Center(child: Text('No $subjectType data available for $systemName \n $subjectType.lower()''_slides'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs[index];
              return ListTile(
                title: Text(doc['title']),
                subtitle: Text(doc['description'] ?? ''),
                trailing: CachedNetworkImage(
                  imageUrl: doc['image_labelled'],
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              );
            },
          );
        },
      ),
    );
  }
}