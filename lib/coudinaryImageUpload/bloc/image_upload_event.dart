part of 'image_upload_bloc.dart';

@immutable
sealed class ImageUploadEvent {}

class PickImage extends ImageUploadEvent {
  final ImageSource source;

  PickImage(this.source);
}

class UploadImage extends ImageUploadEvent {
  final String imagePath;
  final String referenceName;

  UploadImage(this.imagePath, this.referenceName);
}

class DeleteImage extends ImageUploadEvent {
  final String imageId;

  DeleteImage(this.imageId);
}

class LoadImages extends ImageUploadEvent {}