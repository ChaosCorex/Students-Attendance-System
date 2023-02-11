import 'package:circular_widgets/circular_widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ssas/entities/academic.dart';
import 'package:ssas/entities/department.dart';
import 'package:ssas/entities/grade.dart';
import 'package:ssas/screens/admin/grade_deprtment_subjects.dart';

import '../../entities/grade_department.dart';
import 'grade_department_division.dart';

class GradeDepartment extends StatelessWidget {
  static const String route = "/route_grade_department";
  final GradeDepartmentData gradeDepartmentData;

  const GradeDepartment({required this.gradeDepartmentData, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(gradeLabel(gradeDepartmentData.grade)),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    const items = Department.values;
    return Center(
      child: CircularWidgets(
        centerWidgetRadius: kIsWeb ? 230 : 120,
        radiusOfItem: kIsWeb ? 199 : 120,
        itemsLength: items.length,
        itemBuilder: (BuildContext context, int index) {
          return _DepartmentItem(context, items[index]);
        },
      ),
    );
  }

  Widget _DepartmentItem(BuildContext context, Department department) {
    return InkWell(
      onTap: () => _onDepartmentClick(context, department),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  offset: Offset(3.0, 3.0),
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 6,
                  blurRadius: 10,
                ),
              ],
              shape: BoxShape.circle,
              color: Colors.grey.shade300,
            ),
            child: Center(
              child: Image.asset(
                departmentImg(department),
                width: kIsWeb ? 80 : 60,
              ),
            ),
          ),
          const SizedBox(
            height: kIsWeb ? 15 : 10,
          ),
          Text(
            departmentLabel(department),
            style: TextStyle(
                fontSize: kIsWeb ? 22 : 14, fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }

  void _onDepartmentClick(BuildContext context, Department department) {
    String routeName = GradeDepartmentSubjects.route;
    Object args = GradeAndDepartment(
        grade: gradeDepartmentData.grade,
        department: department,
        academic: gradeDepartmentData.academic);
    if (department == Department.d4 && gradeDepartmentData.grade !=Grade.g1) {
      routeName = GradeDepartmentDivision.route;
      args = GradeDepartmentDivsionData(
          department: department,
          grade: gradeDepartmentData.grade,
          academic: gradeDepartmentData.academic);
    }
    Navigator.of(context).pushNamed(routeName, arguments: args);
  }
}

class GradeDepartmentData {
  final Academic academic;
  final Grade grade;

  GradeDepartmentData({
    required this.academic,
    required this.grade,
  });
}
