import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;

  const CourseCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: Colors.white),
          SizedBox(height: 15),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}