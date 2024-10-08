import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DetailPage extends StatefulWidget {
  final Map<String, dynamic> slideData;

  const DetailPage({Key? key, required this.slideData}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool _showQuiz = false;
  int _currentImageIndex = 0;
  List<String?> _selectedAnswers = [];
  bool _isSubmitted = false;
  late List<String> images;

  @override
  void initState() {
    super.initState();
    images = List<String>.from(widget.slideData['image_labelled'] as List<dynamic>? ?? []);
    List<dynamic> questions = widget.slideData['questions'] as List<dynamic>? ?? [];
    _selectedAnswers = List.filled(questions.length, null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.slideData['title'] ?? 'Detail'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 300, // Adjust this value as needed
              child: Stack(
                children: [
                  GestureDetector(
                    onHorizontalDragEnd: (details) {
                      if (details.primaryVelocity! > 0 && _currentImageIndex > 0) {
                        setState(() {
                          _currentImageIndex--;
                        });
                      } else if (details.primaryVelocity! < 0 && _currentImageIndex < images.length - 1) {
                        setState(() {
                          _currentImageIndex++;
                        });
                      }
                    },
                    child: InteractiveViewer(
                      minScale: 0.5,
                      maxScale: 4.0,
                      child: images.isNotEmpty
                          ? CachedNetworkImage(
                        imageUrl: images[_currentImageIndex],
                        fit: BoxFit.contain,
                      )
                          : Center(child: Text('No image available')),
                    ),
                  ),
                  _buildFullScreenButton(),
                ],
              ),
            ),
            PageIndicator(
              currentIndex: _currentImageIndex,
              itemCount: images.length,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(widget.slideData['description'] ?? 'No description available'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _showQuiz = !_showQuiz;
                  _isSubmitted = false;
                });
              },
              child: Text(_showQuiz ? 'Hide Quiz' : 'Quiz Yourself'),
            ),
            if (_showQuiz) _buildQuizSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildFullScreenButton() {
    return Positioned(
      top: 8,
      right: 8,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withOpacity(0.3),
        ),
        child: IconButton(
          icon: Icon(Icons.fullscreen, color: Colors.white, size: 18),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FullScreenImageViewer(
                  imageUrl: images[_currentImageIndex],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildQuizSection() {
    List<dynamic> questions = widget.slideData['questions'] as List<dynamic>? ?? [];

    if (questions.isEmpty) {
      return Text('No questions available');
    }

    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ...questions.asMap().entries.map((entry) {
              int index = entry.key;
              Map<String, dynamic> question = entry.value as Map<String, dynamic>;

              return Card(
                margin: EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Question ${index + 1}: ${question['text']}',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      if (question['image'] != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: CachedNetworkImage(
                            imageUrl: question['image'],
                            fit: BoxFit.contain,
                          ),
                        ),
                      ...(question['options'] as List<dynamic>).map((option) {
                        return RadioListTile<String>(
                          title: Text(option),
                          value: option,
                          groupValue: _selectedAnswers[index],
                          onChanged: _isSubmitted ? null : (value) {
                            setState(() {
                              _selectedAnswers[index] = value;
                            });
                          },
                        );
                      }).toList(),
                      if (_isSubmitted)
                        Container(
                          padding: EdgeInsets.all(8),
                          color: _selectedAnswers[index] == question['correctAnswer']
                              ? Colors.green.withOpacity(0.1)
                              : Colors.red.withOpacity(0.1),
                          child: Text(
                            _selectedAnswers[index] == question['correctAnswer']
                                ? 'Correct!'
                                : 'Incorrect. The correct answer is: ${question['correctAnswer']}',
                            style: TextStyle(
                              color: _selectedAnswers[index] == question['correctAnswer']
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isSubmitted ? null : () {
                setState(() {
                  _isSubmitted = true;
                });
              },
              child: Text('Submit'),
            ),
            SizedBox(height: 8),
            OutlinedButton(
              onPressed: () {
                setState(() {
                  _selectedAnswers = List.filled(questions.length, null);
                  _isSubmitted = false;
                });
              },
              child: Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }
}


class PageIndicator extends StatelessWidget {
  final int currentIndex;
  final int itemCount;

  const PageIndicator({
    Key? key,
    required this.currentIndex,
    required this.itemCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          itemCount,
              (index) => Container(
            margin: EdgeInsets.symmetric(horizontal: 4),
            width: index == currentIndex ? 10 : 8,
            height: index == currentIndex ? 10 : 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: index == currentIndex
                  ? Theme.of(context).primaryColor
                  : Colors.grey.withOpacity(0.5),
            ),
          ),
        ),
      ),
    );
  }
}

class FullScreenImageViewer extends StatelessWidget {
  final String imageUrl;

  const FullScreenImageViewer({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Center(
          child: InteractiveViewer(
            minScale: 1.0,
            maxScale: 4.0,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.contain,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
          ),
        ),
      ),
    );
  }
}