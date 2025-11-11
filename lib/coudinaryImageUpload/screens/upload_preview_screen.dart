import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nap_work_project/coudinaryImageUpload/bloc/image_upload_bloc.dart';
import 'package:nap_work_project/coudinaryImageUpload/bloc/image_upload_event.dart';
import 'package:nap_work_project/coudinaryImageUpload/bloc/image_upload_state.dart';

class UploadPreviewScreen extends StatefulWidget {
  final File imageFile;
  const UploadPreviewScreen({super.key, required this.imageFile});

  @override
  State<UploadPreviewScreen> createState() => _UploadPreviewScreenState();
}

class _UploadPreviewScreenState extends State<UploadPreviewScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return BlocConsumer<UploadBloc, UploadState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }

        if (state.uploadSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Image uploaded successfully!")),
          );
          Navigator.pop(context); // back to upload screen
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  /// --- Image Preview ---
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: height * 0.7,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: FileImage(widget.imageFile),
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
                            child: const Icon(Icons.close,
                                color: Colors.white, size: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.03),
              
                  /// --- Reference Name Input ---
                  Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: width * 0.08),
                    child: TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Reference Name',
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide:
                          const BorderSide(color: Colors.black26),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide:
                          const BorderSide(color: Colors.green),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.03),
              
                  /// --- Submit Button ---
                  ElevatedButton(
                    onPressed: state.isLoading
                        ? null
                        : () {
                      final name = _nameController.text.trim();
                      if (name.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  "Please enter a reference name")),
                        );
                        return;
                      }
              
                      context.read<UploadBloc>().add(
                        UploadImageEvent(
                          imageFile: widget.imageFile,
                          referenceName: name,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(
                          horizontal: width * 0.2,
                          vertical: height * 0.02),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: state.isLoading
                        ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : const Text(
                      'Submit',
                      style:
                      TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
