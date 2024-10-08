import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../screens/detailspage.dart';

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

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialTab;
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
              var doc = snapshot.data!.docs[index].data() as Map<String, dynamic>;
              List<String> imageLabelledList = List<String>.from(doc['image_labelled'] as List<dynamic>? ?? []);
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
                            doc['title'] ?? 'Untitled',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          trailing: firstImage.isNotEmpty
                              ? CachedNetworkImage(
                            imageUrl: firstImage,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => CircularProgressIndicator(),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                          )
                              : SizedBox(width: 100, height: 100, child: Icon(Icons.image_not_supported)),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailPage(slideData: doc),
                              ),
                            );
                          },
                        )
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
    );
  }
}