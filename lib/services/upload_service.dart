import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ssas/services/auth_service.dart';

class UploadService {
  final _imagesRef = FirebaseStorage.instance.ref("images");
  final _authService = AuthService();

  Future<String?> uploadProfileImage(XFile file) async {
    return await _uploadImage("profile", file);
  }

  Future<String?> _uploadImage(String folderName, XFile file) async {
    final generatedFileName = await _generateFileName();
    if (generatedFileName == null) {
      return null;
    }
    final uploadResult = await _imagesRef
        .child(folderName)
        .child(generatedFileName)
        .putData(await file.readAsBytes());
    return await uploadResult.ref.getDownloadURL();
  }

  Future<String?> _generateFileName() async {
    final currentUser = await _authService.getCurrentUser();
    if (currentUser == null) {
      return null;
    }
    return DateTime.now().millisecondsSinceEpoch.toString() + currentUser.id;
  }
}
