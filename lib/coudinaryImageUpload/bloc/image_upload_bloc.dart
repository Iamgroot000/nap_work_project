import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nap_work_project/coudinaryImageUpload/bloc/image_upload_event.dart';
import 'package:nap_work_project/coudinaryImageUpload/bloc/image_upload_state.dart';
import 'package:nap_work_project/coudinaryImageUpload/services/cloudinaryImageUploadService.dart';


class UploadBloc extends Bloc<UploadEvent, UploadState> {
  final ImagePicker _picker = ImagePicker();
  final CloudinaryImageUploadService _cloudinary = CloudinaryImageUploadService();

  UploadBloc() : super(const UploadState()) {
    on<PickImageFromGalleryEvent>(_onPickGallery);
    on<PickImageFromCameraEvent>(_onPickCamera);
    on<UploadImageEvent>(_onUploadImage);
    on<FetchImagesEvent>(_onFetchImages);
  }

  Future<void> _onPickGallery(
      PickImageFromGalleryEvent event, Emitter<UploadState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );
      emit(state.copyWith(
        isLoading: false,
        selectedImage: picked != null ? File(picked.path) : null,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onPickCamera(
      PickImageFromCameraEvent event, Emitter<UploadState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );
      emit(state.copyWith(
        isLoading: false,
        selectedImage: photo != null ? File(photo.path) : null,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onUploadImage(
      UploadImageEvent event, Emitter<UploadState> emit) async {
    emit(state.copyWith(isLoading: true, uploadSuccess: false));
    try {
      final url = await _cloudinary.uploadImage(event.imageFile.path);
      if (url == null) throw Exception("Upload failed");

      await FirebaseFirestore.instance.collection("uploaded_images").add({
        "referenceName": event.referenceName,
        "imageUrl": url,
        "uploadedAt": FieldValue.serverTimestamp(),
      });

      emit(state.copyWith(isLoading: false, uploadSuccess: true));
      add(FetchImagesEvent());
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onFetchImages(
      FetchImagesEvent event, Emitter<UploadState> emit) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("uploaded_images")
          .orderBy("uploadedAt", descending: true)
          .get();

      final List<Map<String, dynamic>> data = snapshot.docs.map((e) {
        final d = e.data();
        return {
          "referenceName": d["referenceName"],
          "imageUrl": d["imageUrl"],
        };
      }).toList();

      emit(state.copyWith(uploadedImages: data, isLoading: false));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }
}
