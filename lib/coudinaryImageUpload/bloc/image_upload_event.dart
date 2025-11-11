import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class UploadEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class PickImageFromGalleryEvent extends UploadEvent {}
class PickImageFromCameraEvent extends UploadEvent {}

class UploadImageEvent extends UploadEvent {
  final File imageFile;
  final String referenceName;
  UploadImageEvent({required this.imageFile, required this.referenceName});
  @override
  List<Object?> get props => [imageFile, referenceName];
}

class FetchImagesEvent extends UploadEvent {}
