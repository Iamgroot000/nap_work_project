part of 'image_upload_bloc.dart';

@immutable
sealed class ImageUploadState {}

final class ImageUploadInitial extends ImageUploadState {}

class ImageUploadLoading extends ImageUploadState {}

class ImageUploadSuccess extends ImageUploadState {
  final String imageUrl;
  final String referenceName;

  ImageUploadSuccess(this.imageUrl, this.referenceName);
}

class ImageUploadFailure extends ImageUploadState {
  final String error;

  ImageUploadFailure(this.error);
}

class ImagePickedSuccess extends ImageUploadState {
  final String imagePath;

  ImagePickedSuccess(this.imagePath);
}

class ImagesLoaded extends ImageUploadState {
  final List<ImageModel> images;

  ImagesLoaded(this.images);
}