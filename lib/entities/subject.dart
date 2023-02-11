import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ssas/entities/academic.dart';
import 'package:ssas/entities/department.dart';
import 'package:ssas/entities/grade.dart';
import 'package:ssas/entities/semester.dart';
import 'Division.dart';

class Subject {
  final String id;
  final String name;
  final String description;
  final Grade grade;
  final Semester semester;
  final Department? department;
  final Academic? academic;
  final Division? division;
  final Timestamp creationDate;
  final String creditHours;
  final List<String> doctorsIds;
  final bool isArchived;

  // grade , semester

  Subject(
      {required this.id,
      required this.name,
      required this.description,
      required this.grade,
      required this.semester,
      required this.department,
      required this.division,
      required this.academic,
      required this.creationDate,
      required this.creditHours,
      this.doctorsIds = const [],
      this.isArchived = false});

  String path(String separator) {
    return gradeLabel(grade) +
        separator +
        (department != null ? departmentLabel(department!) + separator : "") +
        semesterLabel(semester);
  }

  static Map<String, dynamic> toFirebase(
    Subject subject,
    SetOptions? options,
  ) {
    return {
      nameKey: subject.name,
      descriptionKey: subject.description,
      gradeKey: subject.grade.toString(),
      semesterKey: subject.semester.toString(),
      departmentIdKey: subject.department?.toString(),
      creationDateKey: subject.creationDate,
      creditHoursDateKey: subject.creditHours,
      doctorIdKey: subject.doctorsIds,
      isArchivedKey: subject.isArchived,
      academicYearIdKey:subject.academic?.toString(),
      divisionIdKey:subject.division?.toString(),
    };
  }

// deserialization
  static Subject fromFirebase(DocumentSnapshot ds, SnapshotOptions? options) {
    bool isArchived = false;
    try {
      isArchived = ds.get(isArchivedKey);
    } catch (e) {}
    return Subject(
      id: ds.id,
      name: ds.get(nameKey),
      description: ds.get(descriptionKey),
      grade: gradeFromString(ds.get(gradeKey))!,
      semester: semesterFromString(ds.get(semesterKey))!,
      department: departmentFromString(ds.get(departmentIdKey)),
      creationDate: ds.get(creationDateKey),
      creditHours: ds.get(creditHoursDateKey),
      doctorsIds: (ds.get(doctorIdKey) as List).cast(),
      isArchived: isArchived,
      academic: academicFromString(ds.get(academicYearIdKey)),
      division: divisionFromString(ds.get(divisionIdKey)),
    );
  }

  static const String nameKey = "name";
  static const String descriptionKey = "description";
  static const String gradeKey = "grade";
  static const String semesterKey = "semester";
  static const String departmentIdKey = "department_id";
  static const String divisionIdKey = "division_id";
  static const String doctorIdKey = "doctor_id";
  static const String creationDateKey = "creation_date";
  static const String creditHoursDateKey = "credit_hours";
  static const String isArchivedKey = "is_archived";
  static const String academicYearIdKey = "academic_year";

}
