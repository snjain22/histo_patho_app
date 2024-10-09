// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:histo_patho_app/reusable_widgets/reusable_widget.dart';
// import 'package:histo_patho_app/screens/signin_signup/signup_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:histo_patho_app/screens/dashboard.dart';
//
//
// class SignInScreen extends StatefulWidget {
//   const SignInScreen({Key? key}) : super(key: key);
//
//   @override
//   State<SignInScreen> createState() => _SignInScreenState();
// }
//
// class _SignInScreenState extends State<SignInScreen> {
//   final TextEditingController _passwordTextController = TextEditingController();
//   final TextEditingController _emailTextController = TextEditingController();
//
//   Future<void> _saveLoggedInState(String userId) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('isLoggedIn', true);
//     await prefs.setString('userId', userId);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage("assets/images/background-2.png"),
//             fit: BoxFit.cover,
//           )
//       ),
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         appBar: AppBar(
//           backgroundColor: Colors.transparent,
//           title: const Text(
//             "Sign In",
//             style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//           ),
//         ),
//         body: Container(
//           width: double.infinity,
//           height: double.infinity,
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: EdgeInsets.fromLTRB(
//                   20, MediaQuery.of(context).size.height * 0.1, 20, 0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: <Widget>[
//                   // Logo at the top
//                   Image.asset(
//                     'assets/images/SNJ.jpg',
//                     height: 100,
//                   ),
//                   const SizedBox(height: 100),
//                   // Welcome Text
//                   const Text(
//                     "Welcome to HistoPath!",
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                   // Email TextField
//                   reusableTextField(
//                     "Enter Email",
//                     Icons.verified_user,
//                     false,
//                     _emailTextController,
//                   ),
//                   const SizedBox(height: 20),
//                   // Password TextField
//                   reusableTextField(
//                     "Enter Password",
//                     Icons.lock_outline,
//                     true,
//                     _passwordTextController,
//                   ),
//                   const SizedBox(height: 20),
//                   // Sign In Button
//                   signInSignUpButton(context, true, () async {
//                     try {
//                       UserCredential userCredential = await FirebaseAuth.instance
//                           .signInWithEmailAndPassword(
//                         email: _emailTextController.text,
//                         password: _passwordTextController.text,
//                       );
//
//                       // Save logged in state
//                       await _saveLoggedInState(userCredential.user!.uid);
//
//                       // Fetch user profile
//                       DocumentSnapshot userProfile = await FirebaseFirestore.instance
//                           .collection('users')
//                           .doc(userCredential.user!.uid)
//                           .get();
//
//                       if (userProfile.exists) {
//                         // User profile exists, navigate to dashboard
//                         Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(builder: (context) => DashBoardPage()),
//                         );
//                       } else {
//                         // Handle case where user profile doesn't exist
//                         print("User profile not found");
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(content: Text("User profile not found. Please contact support.")),
//                         );
//                       }
//                     } catch (error) {
//                       print("ERROR ${error.toString()}");
//                       // Show error message to user
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text("Error: ${error.toString()}")),
//                       );
//                     }
//                   }),
//                   const SizedBox(height: 20),
//                   // Sign Up Option
//                   signUpOption(),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Row signUpOption() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         const Text("Don't have an account?",
//             style: TextStyle(color: Colors.white70)),
//         GestureDetector(
//           onTap: () {
//             Navigator.push(context,
//                 MaterialPageRoute(builder: (context) => SignUpScreen()));
//           },
//           child: const Text(
//             " Sign Up",
//             style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//           ),
//         ),
//       ],
//     );
//   }
// }

// //Hardik Implementation below
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:histo_patho_app/screens/dashboard.dart';
// import 'package:histo_patho_app/screens/signin_signup/home_screen.dart';
// import 'package:histo_patho_app/screens/imagescreen.dart';
// import 'package:histo_patho_app/screens/signin_signup/signup_screen.dart';
//
//
// class SignInScreen extends StatefulWidget {
//   const SignInScreen({super.key});
//
//   @override
//   State<SignInScreen> createState() => _SignInScreenState();
// }
//
// class _SignInScreenState extends State<SignInScreen> {
//   final TextEditingController _passwordTextController = TextEditingController();
//   final TextEditingController _emailTextController = TextEditingController();
//   final TextEditingController _additionalFieldController = TextEditingController();
//
//   @override
//   void dispose() {
//     _emailTextController.dispose();
//     _passwordTextController.dispose();
//     _additionalFieldController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Stack(
//         children: <Widget>[
//           // Main content
//           SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Container(
//                   height: 400,
//                   child: Stack(
//                     children: <Widget>[
//                       Positioned(
//                         top: -40,
//                         height: 400,
//                         width: width,
//                         child: Container(
//                           decoration: BoxDecoration(
//                             image: DecorationImage(
//                               image: AssetImage('assets/background.png'),
//                               fit: BoxFit.fill,
//                             ),
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         height: 400,
//                         width: width + 20,
//                         child: Container(
//                           decoration: BoxDecoration(
//                             image: DecorationImage(
//                               image: AssetImage('assets/background-2.png'),
//                               fit: BoxFit.fill,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 40),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       Text(
//                         "Login",
//                         style: TextStyle(
//                           color: Color.fromRGBO(49, 39, 79, 1),
//                           fontWeight: FontWeight.bold,
//                           fontSize: 30,
//                         ),
//                       ),
//                       SizedBox(height: 30),
//                       Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           color: Colors.white,
//                           border: Border.all(
//                             color: Color.fromRGBO(196, 135, 198, .3),
//                           ),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Color.fromRGBO(196, 135, 198, .3),
//                               blurRadius: 20,
//                               offset: Offset(0, 10),
//                             ),
//                           ],
//                         ),
//                         child: Column(
//                           children: <Widget>[
//                             Container(
//                               padding: EdgeInsets.all(10),
//                               decoration: BoxDecoration(
//                                 border: Border(
//                                   bottom: BorderSide(
//                                     color: Color.fromRGBO(196, 135, 198, .3),
//                                   ),
//                                 ),
//                               ),
//                               child: TextField(
//                                 controller: _emailTextController,
//                                 decoration: InputDecoration(
//                                   border: InputBorder.none,
//                                   hintText: "Username",
//                                   hintStyle: TextStyle(color: Colors.grey.shade700),
//                                 ),
//                               ),
//                             ),
//                             Container(
//                               padding: EdgeInsets.all(10),
//                               child: TextField(
//                                 controller: _passwordTextController,
//                                 obscureText: true,
//                                 decoration: InputDecoration(
//                                   border: InputBorder.none,
//                                   hintText: "Password",
//                                   hintStyle: TextStyle(color: Colors.grey.shade700),
//                                 ),
//                               ),
//                             ),
//                             // New TextField below the password
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//
//                       // Forgot Password
//                       Center(
//                         child: TextButton(
//                           onPressed: () {},
//                           child: Text(
//                             "Forgot Password?",
//                             style: TextStyle(
//                               color: Color.fromRGBO(196, 135, 198, 1),
//                             ),
//                           ),
//                         ),
//                       ),
//
//                       // Sign In Button
//                       MaterialButton(
//                         minWidth: double.infinity,
//                         height: 60,
//                         onPressed: () async {
//                           try {
//                             UserCredential userCredential = await FirebaseAuth.instance
//                                 .signInWithEmailAndPassword(
//                               email: _emailTextController.text,
//                               password: _passwordTextController.text,
//                             );
//
//                             // Fetch user profile
//                             DocumentSnapshot userProfile = await FirebaseFirestore.instance
//                                 .collection('users')
//                                 .doc(userCredential.user!.uid)
//                                 .get();
//
//                             if (userProfile.exists) {
//                               // Navigate to dashboard
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(builder: (context) => DashBoardPage()),
//                               );
//                             } else {
//                               print("User profile not found");
//                             }
//                           } catch (error) {
//                             print("ERROR ${error.toString()}");
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(content: Text("Error: ${error.toString()}")),
//                             );
//                           }
//                         },
//                         color: Colors.deepPurple, // Color added to the button
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(50),
//                         ),
//                         child: const Text(
//                           "Login",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.w600,
//                             fontSize: 18,
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 30),
//                       Center(
//                         child: TextButton(
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(builder: (context) => SignUpScreen()),
//                             );
//                           },
//                           child: Text(
//                             "Create Account",
//                             style: TextStyle(
//                               color: Color.fromRGBO(49, 39, 79, .6),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           // Back Button
//           Positioned(
//             top: 60, // Adjusted value to position the button lower
//             left: 20,
//             child: IconButton(
//               icon: Icon(Icons.arrow_back, size: 30),
//               onPressed: () {
//                 Navigator.pop(context); // Pops the current route to go back
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:histo_patho_app/screens/dashboard.dart';
import 'package:histo_patho_app/screens/signin_signup/signup_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();

  Future<void> _saveLoggedInState(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userId', userId);
  }

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
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
                        "Login",
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
                                textAlign: TextAlign.start,
                                controller: _emailTextController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Email",
                                  hintStyle: TextStyle(color: Color.fromRGBO(158,158,158, 0.5)),
                                  prefixIcon: Icon(Icons.email, color: Colors.grey),
                                  alignLabelWithHint: true,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              child: TextField(
                                controller: _passwordTextController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Password",
                                  hintStyle: TextStyle(color: Color.fromRGBO(158,158,158, 0.5)),
                                    prefixIcon: Icon(Icons.lock, color: Colors.grey),
                                  alignLabelWithHint: true,

                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                              color: Color.fromRGBO(196, 135, 198, 1),
                            ),
                          ),
                        ),
                      ),
                      MaterialButton(
                        minWidth: double.infinity,
                        height: 60,
                        onPressed: () async {
                          try {
                            UserCredential userCredential = await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                              email: _emailTextController.text,
                              password: _passwordTextController.text,
                            );

                            await _saveLoggedInState(userCredential.user!.uid);

                            DocumentSnapshot userProfile = await FirebaseFirestore.instance
                                .collection('users')
                                .doc(userCredential.user!.uid)
                                .get();

                            if (userProfile.exists) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => DashBoardPage()),
                              );
                            } else {
                              print("User profile not found");
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("User profile not found. Please contact support.")),
                              );
                            }
                          } catch (error) {
                            print("ERROR ${error.toString()}");
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Error: ${error.toString()}")),
                            );
                          }
                        },
                        color: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SignUpScreen()),
                            );
                          },
                          child: Text(
                            "Create Account",
                            style: TextStyle(
                              color: Color.fromRGBO(49, 39, 79, .6),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 60,
            left: 20,
            child: IconButton(
              icon: Icon(Icons.arrow_back, size: 30),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}