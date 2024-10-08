import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:kmc_app/pathology/Slide_pages/renal/wilms.dart';

import '../screens/dashboard.dart';
import 'Slide_pages/renal/wilms.dart';

class RenalPage extends StatefulWidget {
  _RenalState createState() => _RenalState();
}

class _RenalState extends State<RenalPage> {
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
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => DashBoardPage()));
          },
        ),
        title: Text('Renal system'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  MaterialButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WilmsPage()),
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
                      'WILMS TUMOUR',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                  SizedBox(height: 40),
                  MaterialButton(
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   // MaterialPageRoute(builder: (context) => Page2()),
                      // );
                    },
                    padding: EdgeInsets.symmetric(vertical: 20),
                    color: Colors.white24,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    minWidth: double.infinity,
                    height: 100,
                    child: Text(
                      'Renal Cell CARCINOMA',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                  SizedBox(height: 40),
                  MaterialButton(
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => Page3()),
                      // );
                    },
                    padding: EdgeInsets.symmetric(vertical: 20),
                    color: Colors.white24,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    minWidth: double.infinity,
                    height: 100,
                    child: Text(
                      'Transistion Cell Carcinoma',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                  SizedBox(height: 40),
                  MaterialButton(
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => Page4()),
                      // );
                    },
                    padding: EdgeInsets.symmetric(vertical: 20),
                    color: Colors.white24,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    minWidth: double.infinity,
                    height: 100,
                    child: Text(
                      'Chronic Pyelonephritis',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
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
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
