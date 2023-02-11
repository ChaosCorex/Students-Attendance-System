import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ssas/entities/department.dart';
import 'package:ssas/entities/grade.dart';
import 'package:ssas/entities/user_role.dart';

import 'Division.dart';

class AppUser {
  final String id;
  final String email;
  final String imgUrl;
  final String name;
  final Role role;

  final Admin? admin;
  final Student? student;
  final Doctor? doctor;

  AppUser(
      {required this.id,
      required this.email,
      required this.imgUrl,
      required this.name,
      required this.role,
      this.admin,
      this.student,
      this.doctor});

  // serialization
  static Map<String, dynamic> toFirebase(
    AppUser user,
    SetOptions? options,
  ) {
    final Map<String, dynamic> outMap = {
      _email: user.email,
      imgUrlKey: user.imgUrl,
      nameKey: user.name,
      roleKey: user.role.toString(),
    };

    if (user.doctor != null) {
      outMap.addAll(user.doctor!.toMap());
    }

    if (user.student != null) {
      outMap.addAll(user.student!.toMap());
    }

    if (user.admin != null) {
      outMap.addAll(user.admin!.toMap());
    }

    return outMap;
  }

// deserialization
  static AppUser fromFirebase(DocumentSnapshot ds, SnapshotOptions? options) {
    Role userRole = roleFromString(ds.get(roleKey))!;

    Admin? admin;
    Student? student;
    Doctor? doctor;

    switch (userRole) {
      case Role.anonymous:
        break;
      case Role.admin:
        admin = Admin();
        break;
      case Role.doctor:
        doctor = Doctor();
        break;
      case Role.student:
        {
          Grade? grade;
          Department? departmentId;
          String? N_Id;
          Division? divisionId;
          bool? canTakeImageId;
          num? randomId;

          try {
            grade = gradeFromString(ds.get(studentGradeKey)!);
          } catch (e) {}
          try {
            departmentId = departmentFromString(ds.get(studentDepartmentKey));
          } catch (e) {}
          try {
            divisionId = divisionFromString(ds.get(studentDivisionKey));
          } catch (e) {}
          try {
            N_Id = ds.get(studentNIdKey);
          } catch (e) {}
          try {
            canTakeImageId = ds.get(canTakeImageKey);
          } catch (e) {}
          try {
            randomId = ds.get(randomKey);
          } catch (e) {}
          student = Student(
              grade: grade, department: departmentId,N_id: N_Id,division: divisionId,canTakeImage:canTakeImageId,random: randomId );
        }
        break;
    }
    return AppUser(
        id: ds.id,
        email: ds.get(_email),
        imgUrl: ds.get(imgUrlKey),
        name: ds.get(nameKey),
        role: userRole,
        admin: admin,
        student: student,
        doctor: doctor);
  }

  static AppUser fakeUser(String id) => AppUser(
      id: id,
      email: "fake",
      imgUrl: "fake",
      name: "fake",
      role: Role.anonymous);

  static const _email = "email";
  static const imgUrlKey = "img_url";
  static const nameKey = "name";
  static const roleKey = "role";
  static const studentGradeKey = "student_grade";
  static const studentDepartmentKey = "student_department";
  static const studentNIdKey = "student_id";
  static const studentDivisionKey = "student_division";
  static const canTakeImageKey = "can_take_image";
  static const randomKey = "random_number";


}

abstract class ToMap {
  Map<String, dynamic> toMap();
}

class Admin extends ToMap {
  @override
  Map<String, dynamic> toMap() => {};
}

class Student extends ToMap {
  final Grade? grade;
  final Department? department;
  final String? N_id;
  final Division? division;
  final bool? canTakeImage;
  final num? random;
  Student({this.grade, this.department,this.N_id,this.division,this.canTakeImage,this.random});


  @override
  Map<String, dynamic> toMap() => {
        AppUser.studentGradeKey: grade.toString(),
        AppUser.studentDepartmentKey: department.toString(),
        AppUser.studentDivisionKey: division.toString(),
        AppUser.studentNIdKey: N_id,
        AppUser.canTakeImageKey:canTakeImage,
        AppUser.randomKey :random,
      };
}

class Doctor extends ToMap {
  @override
  Map<String, dynamic> toMap() => {};
}

String Profile_FirstName = "";
String Profile_LastName = "";
