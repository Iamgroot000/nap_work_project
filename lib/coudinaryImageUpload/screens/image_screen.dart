import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nap_work_project/coudinaryImageUpload/bloc/image_upload_bloc.dart';
import 'package:nap_work_project/coudinaryImageUpload/bloc/image_upload_event.dart';
import 'package:nap_work_project/coudinaryImageUpload/bloc/image_upload_state.dart';
import 'package:shimmer/shimmer.dart';

class ImagesScreen extends StatefulWidget {
  const ImagesScreen({super.key});

  @override
  State<ImagesScreen> createState() => _ImagesScreenState();
}

class _ImagesScreenState extends State<ImagesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<UploadBloc>().add(FetchImagesEvent());
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return BlocBuilder<UploadBloc, UploadState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            automaticallyImplyLeading: false,
            toolbarHeight: 0,
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.04,
              vertical: height * 0.02,
            ),
            child: _buildContent(context, state, width, height),
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, UploadState state,
      double width, double height) {
    if (state.isLoading && state.uploadedImages.isEmpty) {
      return _buildShimmerGrid(width, height);
    }

    if (state.uploadedImages.isEmpty) {
      return const Center(
        child: Text(
          "No images uploaded yet.",
          style: TextStyle(color: Colors.black54, fontSize: 16),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<UploadBloc>().add(FetchImagesEvent());
      },
      child: GridView.builder(
        itemCount: state.uploadedImages.length,
        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.95,
        ),
        itemBuilder: (context, index) {
          final image = state.uploadedImages[index];
          return Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    image['imageUrl'],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    loadingBuilder:
                        (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          color: Colors.white,
                        ),
                      );
                    },
                    errorBuilder:
                        (context, error, stackTrace) => Container(
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.broken_image,
                          color: Colors.grey, size: 40),
                    ),
                  ),
                ),
              ),
              SizedBox(height: height * 0.008),
              Text(
                image['referenceName'] ?? '',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildShimmerGrid(double width, double height) {
    return GridView.builder(
      itemCount: 6,
      gridDelegate:
      const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.95,
      ),
      itemBuilder: (_, __) => Column(
        children: [
          Expanded(
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          SizedBox(height: height * 0.008),
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 12,
              width: width * 0.3,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
