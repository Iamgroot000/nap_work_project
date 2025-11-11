import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nap_work_project/coudinaryImageUpload/models/image_model.dart';
import 'package:nap_work_project/coudinaryImageUpload/services/cloudinaryImageUploadService.dart';

part 'image_upload_event.dart';
part 'image_upload_state.dart';

class ImageUploadBloc extends Bloc<ImageUploadEvent, ImageUploadState> {
  final ImagePicker _picker = ImagePicker();
  final CloudinaryImageUploadService _cloudinaryService = CloudinaryImageUploadService();

  ImageUploadBloc() : super(ImageUploadInitial()) {
    on<PickImage>(_onPickImage);
    on<UploadImage>(_onUploadImage);
    on<DeleteImage>(_onDeleteImage);
    on<LoadImages>(_onLoadImages);
  }

  Future<void> _onPickImage(PickImage event, Emitter<ImageUploadState> emit) async {
    try {
      final XFile? image = await _picker.pickImage(source: event.source);
      if (image != null) {
        emit(ImagePickedSuccess(image.path));
      }
    } catch (e) {
      emit(ImageUploadFailure('Failed to pick image: $e'));
    }
  }

  Future<void> _onUploadImage(UploadImage event, Emitter<ImageUploadState> emit) async {
    emit(ImageUploadLoading());
    try {
      final String? imageUrl = await _cloudinaryService.uploadImage(event.imagePath);
      if (imageUrl != null) {
        await _cloudinaryService.saveImageUrlToFirestore(
            imageUrl, event.referenceName);
        emit(ImageUploadSuccess(imageUrl, event.referenceName));
        add(LoadImages()); // Reload images after successful upload
      } else {
        emit(ImageUploadFailure('Image upload to Cloudinary failed.'));
      }
    } catch (e) {
      emit(ImageUploadFailure('Error uploading image: $e'));
    }
  }

  Future<void> _onDeleteImage(DeleteImage event, Emitter<ImageUploadState> emit) async {
    emit(ImageUploadLoading());
    try {
      await _cloudinaryService.deleteImageFromFirestore(event.imageId);
      add(LoadImages()); // Reload images after successful deletion
    } catch (e) {
      emit(ImageUploadFailure('Error deleting image: $e'));
    }
  }

  Future<void> _onLoadImages(LoadImages event, Emitter<ImageUploadState> emit) async {
    emit(ImageUploadLoading());
    await emit.forEach(
      _cloudinaryService.streamImagesFromFirestore(),
      onData: (List<Map<String, dynamic>> data) {
        final List<ImageModel> images = data.map((json) => ImageModel.fromJson(json, json['id'] as String)).toList();
        return ImagesLoaded(images);
      },
      onError: (error, stacktrace) => ImageUploadFailure('Failed to load images: $error'),
    );
  }
}
