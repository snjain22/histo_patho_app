import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screens/dashboard.dart';

class Femalerepro extends StatefulWidget {
  _FemalereproState createState() => _FemalereproState();
}

class _FemalereproState extends State<Femalerepro>{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SexyButtonsPage(),
    );
  }
}

class SexyButtonsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context,MaterialPageRoute(builder: (context) => DashBoardPage()));
          },
        ),
        title: Text('Organs'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Replacing custom buttons with MaterialButtons
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  MaterialButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Page1()),
                      );
                    },
                    padding: EdgeInsets.symmetric(vertical: 20),
                    color: Colors.white24,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    minWidth: double.infinity,
                    height: 100,
                    child: Text(
                      'organ 1',
                      style: TextStyle(fontSize: 24, color: Colors.black),
                    ),
                  ),
                  SizedBox(height: 30),
                  MaterialButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Page2()),
                      );
                    },
                    padding: EdgeInsets.symmetric(vertical: 20),
                    color: Colors.white24,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    minWidth: double.infinity,
                    height: 100,
                    child: Text(
                      'organ 2',
                      style: TextStyle(fontSize: 24, color: Colors.black),
                    ),
                  ),
                  SizedBox(height: 30),
                  MaterialButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Page3()),
                      );
                    },
                    padding: EdgeInsets.symmetric(vertical: 20),
                    color: Colors.white24,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    minWidth: double.infinity,
                    height: 100,
                    child: Text(
                      'organ 3',
                      style: TextStyle(fontSize: 24, color: Colors.black),
                    ),
                  ),
                  SizedBox(height: 30),
                  MaterialButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Page4()),
                      );
                    },
                    padding: EdgeInsets.symmetric(vertical: 20),
                    color: Colors.white24,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    minWidth: double.infinity,
                    height: 100,
                    child: Text(
                      'organ 4',
                      style: TextStyle(fontSize: 24, color: Colors.black),
                    ),
                  ),
                  SizedBox(height: 30),
                  MaterialButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Page5()),
                      );
                    },
                    padding: EdgeInsets.symmetric(vertical: 20),
                    color: Colors.white24,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    minWidth: double.infinity,
                    height: 100,
                    child: Text(
                      'organ 5',
                      style: TextStyle(fontSize: 24, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            // Single "Take a Quiz" button at the bottom
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: MaterialButton(
                onPressed: () {
                  // Handle quiz button press
                },
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                color: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                minWidth: double.infinity,
                height: 50,
                child: Text(
                  'Take a Quiz',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Dummy Pages for Navigation
class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Page 1')),
      body: Center(child: Text('This is Page 1')),
    );
  }
}

class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Page 2')),
      body: Center(child: Text('This is Page 2')),
    );
  }
}

class Page3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Page 3')),
      body: Center(child: Text('This is Page 3')),
    );
  }
}

class Page4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Page 4')),
      body: Center(child: Text('This is Page 4')),
    );
  }
}

class Page5 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Page 5')),
      body: Center(child: Text('This is Page 5')),
    );
  }
}

