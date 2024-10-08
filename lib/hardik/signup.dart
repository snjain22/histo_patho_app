import 'package:flutter/material.dart';
import 'package:kmc_app/login.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<SignupPage> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          // Main content
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 400,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        top: -40,
                        height: 400,
                        width: width,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/background.png'),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        height: 400,
                        width: width + 20,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/background-2.png'),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Color.fromRGBO(49, 39, 79, 1),
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      SizedBox(height: 30),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          border: Border.all(
                            color: Color.fromRGBO(196, 135, 198, .3),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(196, 135, 198, .3),
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color.fromRGBO(196, 135, 198, .3),
                                  ),
                                ),
                              ),
                              child: TextField(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Username",
                                  hintStyle: TextStyle(color: Colors.grey.shade700),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color.fromRGBO(196, 135, 198, .3),
                                  ),
                                ),
                              ),
                              child: TextField(
                                obscureText: true,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Password",
                                  hintStyle: TextStyle(color: Colors.grey.shade700),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              child: TextField(
                                obscureText: true,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Confirm Password",
                                  hintStyle: TextStyle(color: Colors.grey.shade700),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      MaterialButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                        },
                        color: Color.fromRGBO(49, 39, 79, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        height: 50,
                        child: Center(
                          child: Text(
                            "Sign Up",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Back Button
          Positioned(
            top: 60, // Adjusted value to position the button lower
            left: 20,
            child: IconButton(
              icon: Icon(Icons.arrow_back, size: 30),
              onPressed: () {
                Navigator.pop(context); // Pops the current route to go back
              },
            ),
          ),
        ],
      ),
    );
  }
}
