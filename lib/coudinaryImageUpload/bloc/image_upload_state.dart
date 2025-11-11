import 'dart:io';
import 'package:equatable/equatable.dart';

class UploadState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final File? selectedImage;
  final List<Map<String, dynamic>> uploadedImages;
  final bool uploadSuccess;

  const UploadState({
    this.isLoading = false,
    this.errorMessage,
    this.selectedImage,
    this.uploadedImages = const [],
    this.uploadSuccess = false,
  });

  UploadState copyWith({
    bool? isLoading,
    String? errorMessage,
    File? selectedImage,
    List<Map<String, dynamic>>? uploadedImages,
    bool? uploadSuccess,
  }) {
    return UploadState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      selectedImage: selectedImage,
      uploadedImages: uploadedImages ?? this.uploadedImages,
      uploadSuccess: uploadSuccess ?? false,
    );
  }

  @override
  List<Object?> get props =>
      [isLoading, errorMessage, selectedImage, uploadedImages, uploadSuccess];
}
