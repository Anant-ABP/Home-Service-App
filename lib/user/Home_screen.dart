import 'package:flutter/material.dart';
import 'package:home_service_app/user/Carpenter_screen.dart';
import 'package:home_service_app/user/Cleaner_screen.dart';
import 'package:home_service_app/user/Electrician_screen.dart';
import 'package:home_service_app/user/Mechanic_screen.dart';
import 'package:home_service_app/user/Ac_screen.dart';
import 'package:home_service_app/user/Plumber_screen.dart';
import 'package:home_service_app/Profile/Profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int myIndex = 0;

  final List<Widget> widgetList = [CategoriesScreen(), UserProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: myIndex, children: widgetList),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: myIndex,
        onTap: (index) {
          setState(() {
            myIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
//  ✅ CATEGORY SCREEN (Navigation FIXED, No Get.to required)
// ------------------------------------------------------------
class CategoriesScreen extends StatelessWidget {
  CategoriesScreen({super.key});

  final List<Map<String, dynamic>> categories = [
    {"title": "Carpenter", "services": "11 Services", "icon": Icons.handyman},
    {
      "title": "Cleaner",
      "services": "11 Services",
      "icon": Icons.cleaning_services,
    },
    {
      "title": "Electrician",
      "services": "11 Services",
      "icon": Icons.electrical_services,
    },
    {"title": "Mechanic", "services": "11 Services", "icon": Icons.build},
    {"title": "Ac repair", "services": "11 Services", "icon": Icons.ac_unit},
    {"title": "Plumber", "services": "11 Services", "icon": Icons.plumbing},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "All Categories",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];

          return InkWell(
            onTap: () {
              print("➡️ Navigating to Category: ${category["title"]}");

              switch (category["title"]) {
                case "Carpenter":
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CarpenterScreen()),
                  );
                  break;

                case "Cleaner":
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CleanerScreen()),
                  );
                  break;

                case "Electrician":
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ElectricianScreen(),
                    ),
                  );
                  break;

                case "Mechanic":
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MechanicScreen()),
                  );
                  break;

                case "Ac repair":
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AcScreen()),
                  );
                  break;

                case "Plumber":
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PlumberScreen()),
                  );
                  break;
              }
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: ListTile(
                leading: Icon(category["icon"], size: 40, color: Colors.blue),
                title: Text(
                  category["title"],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
