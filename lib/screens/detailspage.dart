import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:zoom_hover_pinch_image/zoom_hover_pinch_image.dart';

class DetailPage extends StatefulWidget {
  final Map<String, dynamic> slideData;

  DetailPage({required this.slideData});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool isChecked = false;
  int currentImageIndex = 0;
  int currentQuestionIndex = 0;
  Map<String, String> userAnswers = {};

  @override
  Widget build(BuildContext context) {
    List<String> imageLabelledList = List<String>.from(widget.slideData['image_labelled'] as List<dynamic>? ?? []);
    List<String> imageUnlabelledList = List<String>.from(widget.slideData['image_unlabelled'] as List<dynamic>? ?? []);
    List<Map<String, dynamic>> questions = List<Map<String, dynamic>>.from(widget.slideData['questions'] ?? []);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.slideData['title'] ?? 'Detail'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                widget.slideData['description'] ?? 'No description available',
                style: TextStyle(fontSize: 16),
              ),
            ),
            Stack(
              children: [
                Center(
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: Zoom(
                          clipBehavior: true,
                          width: MediaQuery.of(context).size.width,
                          child: Stack(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height * 0.6,
                                child: CachedNetworkImage(
                                  imageUrl: imageLabelledList[currentImageIndex],
                                  fit: BoxFit.contain,
                                  placeholder: (context, url) => CircularProgressIndicator(),
                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                ),
                              ),
                              if (!isChecked)
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height * 0.6,
                                  child: CachedNetworkImage(
                                    imageUrl: imageUnlabelledList[currentImageIndex],
                                    fit: BoxFit.contain,
                                    placeholder: (context, url) => CircularProgressIndicator(),
                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 50,
                  left: 0,
                  right: 0,
                  child: _buildCheckbox(),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _buildImageControls(imageLabelledList.length),
                ),
              ],
            ),
            if (questions.isNotEmpty) ...[
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Quiz',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              _buildQuizQuestion(questions[currentQuestionIndex]),
              _buildQuizControls(questions.length),
            ],
          ],
        ),
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
          Text("Toggle Labels", style: TextStyle(color: Colors.black)),
        ],
      ),
    );
  }

  Widget _buildImageControls(int imageCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: currentImageIndex > 0
              ? () {
            setState(() {
              currentImageIndex--;
            });
          }
              : null,
        ),
        Text("${currentImageIndex + 1}/$imageCount"),
        IconButton(
          icon: Icon(Icons.arrow_forward_ios),
          onPressed: currentImageIndex < imageCount - 1
              ? () {
            setState(() {
              currentImageIndex++;
            });
          }
              : null,
        ),
      ],
    );
  }

  Widget _buildQuizQuestion(Map<String, dynamic> question) {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question['text'],
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            if (question['image'] != null)
              CachedNetworkImage(
                imageUrl: question['image'],
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            SizedBox(height: 16),
            ...question['options'].map<Widget>((option) {
              return RadioListTile<String>(
                title: Text(option),
                value: option,
                groupValue: userAnswers[question['text']],
                onChanged: (value) {
                  setState(() {
                    userAnswers[question['text']] = value!;
                  });
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizControls(int questionCount) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: currentQuestionIndex > 0
                ? () {
              setState(() {
                currentQuestionIndex--;
              });
            }
                : null,
            child: Text('Previous'),
          ),
          Text('${currentQuestionIndex + 1}/$questionCount'),
          ElevatedButton(
            onPressed: currentQuestionIndex < questionCount - 1
                ? () {
              setState(() {
                currentQuestionIndex++;
              });
            }
                : () {
              _submitQuiz();
            },
            child: Text(currentQuestionIndex < questionCount - 1 ? 'Next' : 'Submit'),
          ),
        ],
      ),
    );
  }

  void _submitQuiz() {
    // Calculate score
    int score = 0;
    List<Map<String, dynamic>> questions = List<Map<String, dynamic>>.from(widget.slideData['questions'] ?? []);
    for (var question in questions) {
      if (userAnswers[question['text']] == question['correctAnswer']) {
        score++;
      }
    }

    // Show result dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Quiz Result'),
          content: Text('Your score: $score/${questions.length}'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}