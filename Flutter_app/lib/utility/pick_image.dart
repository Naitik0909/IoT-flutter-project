import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter/material.dart';

class FilePickCrop {
  static Future<File> pickMedia({
    Future<File> Function(File file) cropImage,
  }) async {
    final source = ImageSource.gallery;
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile == null) return null;

    if (cropImage == null) {
      return File(pickedFile.path);
    } else {
      final file = File(pickedFile.path);

      return cropImage(file);
    }
  }
}

Future<File> cropSquareImage(File imageFile) async =>
    await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      aspectRatioPresets: [CropAspectRatioPreset.square],
      compressQuality: 70,
      compressFormat: ImageCompressFormat.jpg,
      androidUiSettings: androidUiSettingsLocked(),
      iosUiSettings: iosUiSettingsLocked(),
    );

IOSUiSettings iosUiSettingsLocked() => IOSUiSettings(
  rotateClockwiseButtonHidden: false,
  rotateButtonsHidden: false,
);

AndroidUiSettings androidUiSettingsLocked() => AndroidUiSettings(
  toolbarTitle: 'Crop Image',
  toolbarColor: Colors.red,
  toolbarWidgetColor: Colors.white,
  hideBottomControls: true,
);