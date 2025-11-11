import 'dart:io';
import 'dart:typed_data';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:nap_work_project/config/cloudinaryConfig.dart';
import 'package:path_provider/path_provider.dart';

class CloudinaryImageUploadService {
  final CloudinaryPublic _cloudinary = CloudinaryPublic(
    CloudinaryConfig.cloudName,
    CloudinaryConfig.uploadPreset,
    cache: false,
  );

  /// Compress and upload image to Cloudinary
  Future<String?> uploadImage(String imagePath) async {
    try {
      debugPrint('Starting image upload for: $imagePath');

      // Read the image file
      final File imageFile = File(imagePath);
      if (!await imageFile.exists()) {
        debugPrint('Image file does not exist: $imagePath');
        return null;
      }

      // Compress the image
      final Uint8List compressedImageData = await _compressImage(imageFile);

      // Create a temporary file for upload
      final tempDir = await getTemporaryDirectory();
      final tempFile = File(
        '${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      await tempFile.writeAsBytes(compressedImageData);

      // Upload to Cloudinary
      final CloudinaryResponse response = await _cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          tempFile.path,
          publicId: 'profile_${DateTime.now().millisecondsSinceEpoch}',
        ),
      );

      // Clean up temporary file
      await tempFile.delete();

      debugPrint('Image uploaded successfully: ${response.secureUrl}');
      return response.secureUrl;
    } catch (e) {
      debugPrint('Error uploading image: $e');
      return null;
    }
  }

  /// Compress image to reasonable size while maintaining quality
  Future<Uint8List> _compressImage(File imageFile) async {
    try {
      // Read the original image
      final Uint8List originalBytes = await imageFile.readAsBytes();
      final img.Image? originalImage = img.decodeImage(originalBytes);

      if (originalImage == null) {
        throw Exception('Failed to decode image');
      }

      // Calculate new dimensions (max width: 800px, maintain aspect ratio)
      int newWidth = originalImage.width;
      int newHeight = originalImage.height;

      if (newWidth > 800) {
        final double aspectRatio = newWidth / newHeight;
        newWidth = 800;
        newHeight = (newWidth / aspectRatio).round();
      }

      // Resize the image
      final img.Image resizedImage = img.copyResize(
        originalImage,
        width: newWidth,
        height: newHeight,
        interpolation: img.Interpolation.linear,
      );

      // Encode as JPEG with 85% quality
      final Uint8List compressedBytes = Uint8List.fromList(
        img.encodeJpg(resizedImage, quality: 85),
      );

      debugPrint(
        'Image compressed: ${originalBytes.length} -> ${compressedBytes.length} bytes',
      );
      return compressedBytes;
    } catch (e) {
      debugPrint('Error compressing image: $e');
      // Return original image if compression fails
      return await imageFile.readAsBytes();
    }
  }

  /// Upload multiple images and return list of URLs
  Future<List<String>> uploadImages(List<String> imagePaths) async {
    final List<String> uploadedUrls = [];

    for (String imagePath in imagePaths) {
      if (!imagePath.startsWith("http")) {
        final String? url = await uploadImage(imagePath);
        if (url != null) {
          uploadedUrls.add(url);
        }
      } else {
        uploadedUrls.add(imagePath);
      }
    }
    return uploadedUrls;
  }
}
