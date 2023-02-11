import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ssas/entities/app_user.dart';
import 'package:ssas/entities/department.dart';
import 'package:ssas/entities/user_role.dart';
import 'package:ssas/services/upload_service.dart';

import '../entities/Division.dart';
import '../entities/grade.dart';

class UserService {
  final _userCollection = FirebaseFirestore.instance
      .collection("users")
      .withConverter(
          fromFirestore: AppUser.fromFirebase, toFirestore: AppUser.toFirebase);

  Future<void> addFirebaseUser(User firebaseUser) async {
    String userId = firebaseUser.uid;
    final newUser = AppUser(
        id: userId,
        email: firebaseUser.email!,
        imgUrl: "https://picsum.photos/seed/$userId/200",
        name: Profile_FirstName+" "+Profile_LastName,
        role: Role.anonymous);
    await _addNewUser(newUser);
  }

  Future<void> _addNewUser(AppUser user) async {
    await _userCollection.doc(user.id).set(user);
  }

  Future<AppUser> getUserById(String id) async {
    return (await _userCollection.doc(id).get()).data()!;
  }

  Future<void> deleteUser(String id) async {
    return await _userCollection.doc(id).delete();
  }

  Future<void> updateUserRole(String userId, Role role) async {
    return await _userCollection
        .doc(userId)
        .update({AppUser.roleKey: role.toString()});
  }

  Future<void> updateStudentRole(
      String userId, Grade? grade, Department? department,String Studentid,Division? division,num randomNumber) async {
    return await _userCollection.doc(userId).update({
      AppUser.roleKey: Role.student.toString(),
      AppUser.studentGradeKey: grade?.toString(),
      AppUser.studentDepartmentKey: department?.toString(),
      AppUser.studentNIdKey:Studentid,
      AppUser.studentDivisionKey:division?.toString(),
      AppUser.canTakeImageKey:true,
      AppUser.randomKey: randomNumber,
    });
  }

  Stream<AppUser> getUserStreamById(String id) {
    return _userCollection.doc(id).snapshots().map((ds) => ds.data()!);
  }

  Stream<List<AppUser>> getUsersStreamForAdminExcept(String exceptionId) {
    return _userCollection
        .where(
          AppUser.roleKey,
          isNotEqualTo: Role.student.toString(),
        )
        .snapshots()
        .map((event) => event.docs
            .map((e) => e.data())
            .where((user) => user.id != exceptionId)
            .toList());
  }

  Stream<List<AppUser>> getUsersStreamForAffairs() {
    return _userCollection
        .where(
          AppUser.roleKey,
          whereIn: [Role.student.toString(), Role.anonymous.toString()],
        )
        .snapshots()
        .map((event) => event.docs.map((e) => e.data()).toList());
  }

  Stream<List<AppUser>> getUsersSteamWithIds({
    required List<String> usersIds,
    Role? role,
  }) {
    if (usersIds.isEmpty) {
      return Stream.value([]);
    }
    Query<AppUser> query =
        _userCollection.where(FieldPath.documentId, whereIn: usersIds);
    if (role != null) {
      query = query.where(AppUser.roleKey, isEqualTo: role.toString());
    }
    return query
        .snapshots()
        .map((event) => event.docs.map((e) => e.data()).toList());
  }

  Stream<List<AppUser>> getDoctorsStream({
    List<String>? exceptionsIds,
  }) {
    Query<AppUser> query = _userCollection.where(AppUser.roleKey,
        isEqualTo: Role.doctor.toString());
    if (exceptionsIds != null && exceptionsIds.isNotEmpty) {
      query = query.where(FieldPath.documentId, whereNotIn: exceptionsIds);
    }
    return query
        .snapshots()
        .map((event) => event.docs.map((e) => e.data()).toList());
  }

  Future<void> updateUserInfo(
      String userId,var key,var newUpdate) async {
    return await _userCollection
        .doc(userId)
        .update({key: newUpdate});
  }
  Future<void> editProfileImage(String userId, XFile file) async {
    final url = await UploadService().uploadProfileImage(file);
    if (url == null) return;
    await _userCollection.doc(userId).update({AppUser.imgUrlKey: url});
  }
}
