import 'package:flutter/material.dart';
import 'package:homeservice/Profile/Profile.dart';

class HomeScreem extends StatefulWidget {
  const HomeScreem({super.key});

  @override
  State<HomeScreem> createState() => _HomeScreemState();
}

class _HomeScreemState extends State<HomeScreem> {
  int MYindex = 0;
  List<Widget> WidgetList = [
    HomeScreem(),
    ProfileScreen(),
    //Screen3(),

    //const Center(child: Text('Home Page')),
    //const Center(child: Text('Search Page')),
    //const Center(child: Text('Profile Page')),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(children: WidgetList, index: MYindex),
      appBar: AppBar(title: const Text('Home Screen')),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            MYindex = index;
          });
        },
        currentIndex: MYindex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          //BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
