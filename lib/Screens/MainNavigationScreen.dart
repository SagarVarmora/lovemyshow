import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lovemyshow/Controller/NavigationController.dart';
import 'package:lovemyshow/Screens/HomeScreen.dart';

class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Coming Soon',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }
}

class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NavigationController navController = Get.put(NavigationController());
    final List<Widget> pages = [
      const HomeScreen(),
      const ComingSoonScreen(),
      const ComingSoonScreen(),
      const ComingSoonScreen(),
    ];

    return Scaffold(
      body: Obx(() => pages[navController.currentIndex.value]),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
        currentIndex: navController.currentIndex.value,
        onTap: (index) {
          if (index == 0) {
            navController.changeIndex(index);
          } else {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Coming Soon'),
                content: const Text('This feature is under development!'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK', style: TextStyle(color: Colors.black)),
                  ),
                ],
              ),
            );
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFE91E63),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'List Show',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      )),
    );
  }
}