import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:histo_patho_app/screens/logoutpage.dart';
import 'package:histo_patho_app/screens/profilepage.dart';
import 'package:histo_patho_app/screens/quiz/quiz_list_screen.dart';
import 'package:histo_patho_app/utils/coursecard.dart';
import 'package:histo_patho_app/screens/systemdetailpage.dart';
import 'package:histo_patho_app/screens/quiz/quiz_management_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DashBoardPage extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoardPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 2) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        FirebaseFirestore.instance.collection('users').doc(user.uid).get().then((docSnapshot) {
          if (docSnapshot.exists) {
            String userType = docSnapshot.data()?['userType'] ?? '';
            if (["admin"].contains(userType.toLowerCase())) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => QuizManagementScreen(isAdmin: true)),
              );
            } else if (['teacher'].contains(userType.toLowerCase())) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QuizManagementScreen()),
              );
            } else if (userType.toLowerCase() == 'student') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QuizListScreen()),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Invalid user type. Please contact support.')),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('User profile not found. Please update your profile.')),
            );
          }
        }).catchError((error) {
          print("Error fetching user data: $error");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('An error occurred. Please try again later.')),
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please log in to access this feature.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SlideScholar'),
        centerTitle: true,
        backgroundColor: Colors.greenAccent,
      ),
      drawer: _buildDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _buildBanner(),
          ),
          SliverPadding(
            padding: EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.5,
              ),
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SystemDetailPage(systemIndex: index, initialTab: _selectedIndex),
                        ),
                      );
                    },
                    child: CourseCard(
                      icon: _getIconForIndex(index),
                      title: _getTitleForIndex(index),
                      color: _getColorForIndex(index),
                    ),
                  );
                },
                childCount: 9,
              ),
            ),
          ),
        ],
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
          BottomNavigationBarItem(
            icon: Icon(Icons.quiz),
            label: 'Quiz',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.greenAccent,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_getGreeting()},',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                FutureBuilder(
                  future: _getUserName(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text('Loading...');
                    }
                    return Text(
                      snapshot.data ?? 'User',
                      style: TextStyle(fontSize: 16),
                    );
                  },
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
            child: Icon(Icons.person, size: 50, color: Colors.black),
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  Future<String> _getUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      return userData['name'] ?? 'User';
    }
    return 'User';
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.greenAccent,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LogoutPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  IconData _getIconForIndex(int index) {
    List<IconData> icons = [
      Icons.biotech,
      Icons.female,
      Icons.lunch_dining,
      Icons.face,
      Icons.water_drop,
      Icons.male,
      Icons.water,
      Icons.accessibility_new,
      Icons.favorite
    ];
    return icons[index];
  }

  String _getTitleForIndex(int index) {
    List<String> titles = [
      "ENDOCRINE SYSTEM", "FEMALE REPRODUCTIVE SYSTEM", "GASTROINTESTINAL SYSTEM",
      "INTEGUMENTARY SYSTEM", "LYMPHATIC SYSTEM", "MALE REPRODUCTIVE SYSTEM", "RENAL SYSTEM",
      "SKELETAL SYSTEM", "VASCULAR SYSTEM"
    ];
    titles.sort((a,b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return titles[index];
  }

  Color _getColorForIndex(int index) {
    List<Color> colors = [
      Color.fromRGBO(138, 43, 226, 1.0),
      Color.fromRGBO(255, 105, 180, 1.0),
      Color.fromRGBO(50, 205, 50, 1.0),
      Color.fromRGBO(210, 105, 30, 1.0),
      Color.fromRGBO(135, 206, 250, 1.0),
      Color.fromRGBO(220, 20, 60, 1.0),
      Color.fromRGBO(0, 128, 128, 1.0),
      Color.fromRGBO(0, 0, 0, 1.0),
      Color.fromRGBO(0, 0, 139, 1.0),
    ];
    return colors[index];
  }
}