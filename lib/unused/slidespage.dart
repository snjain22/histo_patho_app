import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SlideSearchPage extends StatefulWidget {
  @override
  _SlideSearchPageState createState() => _SlideSearchPageState();
}

class _SlideSearchPageState extends State<SlideSearchPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> _slides = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _searchSlides();
  }

  Future<void> _searchSlides() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('pathology_slides')
          .where('title', isGreaterThanOrEqualTo: 'Wilm')
          .where('title', isLessThan: 'Tumor' + '\uf8ff')
          .get();

      setState(() {
        _slides = querySnapshot.docs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching slides: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Slides containing "Wilm"'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(child: Text(_errorMessage));
    }

    if (_slides.isEmpty) {
      return Center(child: Text('No slides found containing "Wilm"'));
    }

    return ListView.builder(
      itemCount: _slides.length,
      itemBuilder: (context, index) {
        Map<String, dynamic> data = _slides[index].data() as Map<String, dynamic>;
        return ListTile(
          title: Text(data['title'] ?? 'No title'),
          subtitle: Text(data['description'] ?? 'No description'),
          onTap: () {
            // Navigate to a detailed view of the slide
            _navigateToSlideDetail(data);
          },
        );
      },
    );
  }

  void _navigateToSlideDetail(Map<String, dynamic> slideData) {
    // Implement navigation to a detailed view
    // For example:
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => SlideDetailPage(slideData: slideData)),
    // );
  }
}