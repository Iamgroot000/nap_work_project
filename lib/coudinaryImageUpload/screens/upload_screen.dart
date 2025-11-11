import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nap_work_project/coudinaryImageUpload/bloc/image_upload_bloc.dart';
import 'package:nap_work_project/coudinaryImageUpload/screens/upload_preview_screen.dart';

class UploadScreen extends StatelessWidget {
  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.08, vertical: height * 0.04),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// --- Browse Gallery Box ---
            Container(
              width: double.infinity,
              height: height * 0.2,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.green.withOpacity(0.7),
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: InkWell(
                onTap: () => context.read<ImageUploadBloc>().add(PickImage(ImageSource.gallery)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image, color: Colors.green, size: width * 0.12),
                    const SizedBox(height: 10),
                    const Text(
                      'Browse Gallery',
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ),

            /// --- OR Divider ---
            Padding(
              padding: EdgeInsets.symmetric(vertical: height * 0.03),
              child: Row(
                children: const [
                  Expanded(child: Divider(thickness: 1, color: Colors.black26)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('OR', style: TextStyle(color: Colors.black54)),
                  ),
                  Expanded(child: Divider(thickness: 1, color: Colors.black26)),
                ],
              ),
            ),

            /// --- Open Camera Box ---
            Container(
              width: double.infinity,
              height: height * 0.08,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.green.withOpacity(0.7),
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: InkWell(
                onTap: () => context.read<ImageUploadBloc>().add(PickImage(ImageSource.camera)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt, color: Colors.green),
                    const SizedBox(width: 8),
                    const Text(
                      'Open Camera',
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
