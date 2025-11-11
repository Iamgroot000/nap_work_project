import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nap_work_project/coudinaryImageUpload/bloc/image_upload_bloc.dart';
import 'package:nap_work_project/coudinaryImageUpload/bloc/image_upload_event.dart';
import 'package:nap_work_project/coudinaryImageUpload/bloc/image_upload_state.dart';
import 'upload_preview_screen.dart';

class UploadScreen extends StatelessWidget {
  const UploadScreen({super.key});

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

        if (state.selectedImage != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => UploadPreviewScreen(imageFile: state.selectedImage!),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.08,
                vertical: height * 0.04,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (state.isLoading)
                    const CircularProgressIndicator(color: Colors.green),
                  _dottedBoxButton(
                    title: "Browse Gallery",
                    icon: Icons.image,
                    onTap: () => context.read<UploadBloc>().add(PickImageFromGalleryEvent()),
                    width: width,
                    height: height * 0.2,
                    isHorizontal: false,
                  ),

                  /// --- OR Divider ---
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: height * 0.03),
                    child: Row(
                      children: const [
                        Expanded(child: Divider(color: Colors.black26, thickness: 1)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text('OR', style: TextStyle(color: Colors.black54)),
                        ),
                        Expanded(child: Divider(color: Colors.black26, thickness: 1)),
                      ],
                    ),
                  ),

                  /// --- Open Camera (Horizontal layout) ---
                  _dottedBoxButton(
                    title: "Open Camera",
                    icon: Icons.camera_alt,
                    onTap: () => context.read<UploadBloc>().add(PickImageFromCameraEvent()),
                    width: width,
                    height: height * 0.1,
                    isHorizontal: true,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _dottedBoxButton({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    required double width,
    required double height,
    required bool isHorizontal,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: DottedBorder(
        color: Colors.green,
        strokeWidth: 1.8,
        dashPattern: const [6, 4],
        borderType: BorderType.RRect,
        radius: const Radius.circular(10),
        child: Container(
          width: double.infinity,
          height: height,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(12),
          child: isHorizontal
              ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.green, size: width * 0.07),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ],
          )
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.green, size: width * 0.12),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
