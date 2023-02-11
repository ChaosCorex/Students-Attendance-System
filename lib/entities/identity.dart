import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ssas/entities/academic.dart';
import 'package:ssas/entities/department.dart';
import 'package:ssas/entities/user_role.dart';
import 'package:ssas/utils/qr_parser.dart';

import 'Division.dart';
import 'grade.dart';

class Identity {
  final String id;
  final String nationalId;
  final Role role;
  final bool active;
  final bool isCreatedByAffairs;
  final Timestamp createdAt;
  final Department? studentDepartment;
  final Grade? studentGrade;
  final Academic? academicYear;
  final String? studentName;
  final Division? studentDivision;

  Identity(
      {required this.id,
      required this.nationalId,
      required this.role,
      required this.active,
      required this.isCreatedByAffairs,
      required this.createdAt,
      this.studentName,
      this.studentDepartment,
      this.studentGrade,
      this.academicYear,
      this.studentDivision});

  String getQrData() => "${QrFunctions.identity}$qrDataFunctionSeparator$id";

  static Map<String, dynamic> toFirebase(
    Identity identity,
    SetOptions? options,
  ) {
    return {
      _nationalIdKey: identity.nationalId,
      _roleKey: identity.role.toString(),
      activeKey: identity.active,
      isCreatedByAffairsKey: identity.isCreatedByAffairs,
      createdAtKey: identity.createdAt,
      studentGradeKey: identity.studentGrade.toString(),
      studentDepartmentKey: identity.studentDepartment.toString(),
      academicYearKey: identity.academicYear.toString(),
      _studentNameKey: identity.studentName,
      studentDivisionKey:identity.studentDivision.toString(),
    };
  }

// deserialization
  static Identity fromFirebase(DocumentSnapshot ds, SnapshotOptions? options) {
    Grade? grade;
    Department? departmentId;
    Academic? academicId;
    Division? divisionId;
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
      academicId = academicFromString(ds.get(academicYearKey));
    } catch (e) {}
    return Identity(
      id: ds.id,
      nationalId: ds.get(_nationalIdKey),
      role: roleFromString(ds.get(_roleKey))!,
      active: ds.get(activeKey),
      isCreatedByAffairs: ds.get(isCreatedByAffairsKey),
      createdAt: ds.get(createdAtKey),
      studentGrade: grade,
      studentDepartment: departmentId,
      academicYear: academicId,
        studentName: ds.get(_studentNameKey),
      studentDivision: divisionId,
    );
  }

  static const String _nationalIdKey = "national_id";
  static const String _studentNameKey = "student_name";
  static const String _roleKey = "role";
  static const String activeKey = "active";
  static const String isCreatedByAffairsKey = "is_created_by_affairs";
  static const String createdAtKey = "created_at";
  static const studentGradeKey = "student_grade";
  static const studentDepartmentKey = "student_department";
  static const academicYearKey = "academic_year";
  static const studentDivisionKey = "student_division";

}
