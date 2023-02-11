import 'package:ssas/entities/academic.dart';
import 'package:ssas/entities/department.dart';

import 'Division.dart';
import 'grade.dart';

class GradeAndDepartment {
  final Grade grade;
  final Department? department;
  final Academic? academic;
  final Division? division;

  GradeAndDepartment(
      {required this.grade, this.department, this.academic, this.division});

  String getLabel() {
    String label = gradeLabel(grade);
    if (department != null && academic != null) {
      label = departmentLabel(department!) + " > " + label;
     // label =  academicYearLabel(academic!) + " > " + label;

    }
    return label;
  }
}
