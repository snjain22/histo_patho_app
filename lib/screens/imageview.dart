import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:histo_patho_app/unused/dblinkedpage.dart';
import 'package:histo_patho_app/unused/slide.dart';
import 'package:zoom_hover_pinch_image/zoom_hover_pinch_image.dart';

class ImageViewPage extends StatefulWidget {
  final Slide slide;

  const ImageViewPage({Key? key, required this.slide}) : super(key: key);

  @override
  _ImageViewPageState createState() => _ImageViewPageState();
}

class _ImageViewPageState extends State<ImageViewPage> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double appBarHeight = AppBar().preferredSize.height;
    final double totalTopPadding = statusBarHeight + appBarHeight;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.slide.title,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: (MediaQuery.of(context).size.height - totalTopPadding) / 2,
              child: Stack(
                children: [
                  Zoom(
                    clipBehavior: true,
                    width: MediaQuery.of(context).size.width,
                    minScale: 1.0,
                    maxScale: 7.0,
                    height: (MediaQuery.of(context).size.height - totalTopPadding) / 2,
                    child: Stack(
                      children: [
                        CachedNetworkImage(
                          imageUrl: "https://" + widget.slide.imageUnlabelledUrl,
                          fit: BoxFit.contain,
                          placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                        if (isChecked)
                          CachedNetworkImage(
                            imageUrl: "https://" + widget.slide.imageLabelledUrl,
                            fit: BoxFit.contain,
                            placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                          ),
                      ],
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Description:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(widget.slide.description),
                  SizedBox(height: 16),
                  Text('Questions:', style: TextStyle(fontWeight: FontWeight.bold)),
                  ...widget.slide.questions.map((question) => QuestionWidget(question: question)).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckbox() {
    return Container(
      color: Colors.white.withOpacity(0.7),
      child: Center(
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
      ),
    );
  }
}