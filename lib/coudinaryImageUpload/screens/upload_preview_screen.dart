import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nap_work_project/coudinaryImageUpload/bloc/image_upload_bloc.dart';

class UploadPreviewScreen extends StatefulWidget {
  final String imagePath;
  const UploadPreviewScreen({super.key, required this.imagePath});

  @override
  State<UploadPreviewScreen> createState() => _UploadPreviewScreenState();
}

class _UploadPreviewScreenState extends State<UploadPreviewScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<ImageUploadBloc, ImageUploadState>(
        listener: (context, state) {
          if (state is ImageUploadSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Image ''${state.referenceName}'' uploaded successfully!')),
            );
            Navigator.pop(context);
          } else if (state is ImageUploadFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Upload failed: ${state.error}')),
            );
          }
        },
        child: SafeArea(
          child: Column(
            children: [
              /// --- Image Preview ---
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: height * 0.5,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(File(widget.imagePath)),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(5),
                        child: const Icon(Icons.close, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.03),

              /// --- Reference Name Input ---
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.08),
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Reference Name',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(color: Colors.black26),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(color: Colors.green),
                    ),
                  ),
                ),
              ),
              SizedBox(height: height * 0.03),

              /// --- Submit Button ---
              BlocBuilder<ImageUploadBloc, ImageUploadState>(
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: state is ImageUploadLoading
                        ? null
                        : () {
                            if (_nameController.text.isNotEmpty) {
                              context.read<ImageUploadBloc>().add(
                                    UploadImage(
                                        widget.imagePath, _nameController.text),
                                  );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Please enter a reference name.')),
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.2,
                        vertical: height * 0.02,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: state is ImageUploadLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Submit',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                  );
                },
              ),
            ],
          ),
        ),
      ),

      /// --- Bottom Navigation Bar ---
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
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
        onTap: (index) {},
      ),
    );
  }
}
