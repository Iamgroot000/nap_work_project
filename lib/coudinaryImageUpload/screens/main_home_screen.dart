import 'package:flutter/material.dart';
import 'package:nap_work_project/coudinaryImageUpload/screens/image_screen.dart';
import 'package:nap_work_project/coudinaryImageUpload/screens/upload_screen.dart';

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _index = 0;
  final screens = const [UploadScreen(), ImagesScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_index],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _index,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.upload), label: "Upload"),
          BottomNavigationBarItem(icon: Icon(Icons.image), label: "Images"),
        ],
      ),
    );
  }
}
