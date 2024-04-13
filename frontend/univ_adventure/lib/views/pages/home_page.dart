import 'package:flutter/material.dart';
import 'package:univ_adventure/views/pages/signup_page.dart';
import '../../models/user.dart';
import 'quest_page.dart';
import 'chat_page.dart';
import 'map_page.dart';
import 'news_page.dart';
import 'profile_page.dart';
import '../../services/user_manager.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 2;
  final List<Widget> _pages = [
    NewsPage(),
    QuestPage(),
    MapPage(),
    ChatPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: UserManager.userStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show loading indicator while waiting for user data
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // Show error message if there's an error
        } else {
          User? user = snapshot.data;
          if (user == null) {
            return SignupPage(); // Redirect to SignupPage if user is null
          } else {
            return Scaffold(
              body: Center(
                child: _pages.elementAt(_selectedIndex),
              ),
              bottomNavigationBar: BottomNavigationBar(
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.newspaper),
                    label: 'News',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.view_list_rounded),
                    label: 'Quests',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.map),
                    label: 'Map',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.sms),
                    label: 'Chat',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Profile',
                  ),
                ],
                currentIndex: _selectedIndex,
                selectedItemColor: Colors.amber[800],
                onTap: _onItemTapped,
                type: BottomNavigationBarType.fixed,
              ),
            );
          }
        }
      },
    );
  }
}