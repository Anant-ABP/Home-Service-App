import 'package:flutter/material.dart';
import 'package:home_service_app/Profile/Profile.dart';

class HomeScreem extends StatefulWidget {
  const HomeScreem({super.key});

  @override
  State<HomeScreem> createState() => _HomeScreemState();
}

class _HomeScreemState extends State<HomeScreem> {
  int myindex = 0;
  List<Widget> widgetList = [
    HomeScreem(),
    UserProfilePage(),
    //Screen3(),

    //const Center(child: Text('Home Page')),
    //const Center(child: Text('Search Page')),
    //const Center(child: Text('Profile Page')),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(children: widgetList, index: myindex),
      appBar: AppBar(title: const Text('Home Screen')),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            myindex = index;
          });
        },
        currentIndex: myindex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          //BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
