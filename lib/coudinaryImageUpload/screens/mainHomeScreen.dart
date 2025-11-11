import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nap_work_project/coudinaryImageUpload/bloc/image_upload_bloc.dart';
import 'package:nap_work_project/coudinaryImageUpload/screens/image_screen.dart';
import 'package:nap_work_project/coudinaryImageUpload/screens/upload_preview_screen.dart';
import 'package:nap_work_project/coudinaryImageUpload/screens/upload_screen.dart';

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (context) => ImageUploadBloc()..add(LoadImages()),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: BlocListener<ImageUploadBloc, ImageUploadState>(
              listener: (context, state) {
                if (state is ImagePickedSuccess && mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => UploadPreviewScreen(imagePath: state.imagePath),
                    ),
                  );
                } else if (state is ImageUploadFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${state.error}')),
                  );
                }
              },
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                children: [
                  const UploadScreen(),
                  const ImageScreen(),
                ],
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.white,
              selectedItemColor: Colors.green,
              unselectedItemColor: Colors.grey,
              currentIndex: _currentIndex,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Upload',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.image),
                  label: 'Images',
                ),
              ],
              onTap: (index) {
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
