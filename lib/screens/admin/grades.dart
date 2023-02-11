import 'package:circular_widgets/circular_widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ssas/entities/grade.dart';
import 'package:ssas/entities/grade_department.dart';
import 'package:ssas/screens/admin/grade_department.dart';
import 'package:ssas/screens/admin/grade_deprtment_subjects.dart';
import 'package:ssas/services/subject_service.dart';

import '../../entities/academic.dart';
import '../../entities/activeAcademic.dart';
import '../../entities/subject.dart';
import '../../services/academic_service.dart';

final _academicServices = AcademicService();
final _subjectService = SubjectService();
Academic? activeYear;

class GradesScreen extends StatelessWidget {
  static const String route = "/route_Grade";
  final GradeData gradeData;

  const GradesScreen({required this.gradeData, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          StreamBuilder<List<Subject>>(
              stream:
                  _subjectService.clearAcademic(academic: gradeData.academic),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                  return Text(snapshot.error.toString());
                }
                if (snapshot.hasData) {
                  final subjectList = snapshot.data!;
                  return IconButton(
                      onPressed: () async {
                        await deleteConfirmation(context, subjectList);
                      },
                      icon: Icon(Icons.clear));
                }
                return Text("");
              }),
        ],
        title: StreamBuilder<ActiveAcademic>(
            stream: _academicServices.getItemStreamById("ssasActiveYear"),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print(snapshot.error);
                return Text(snapshot.error.toString());
              }
              if (snapshot.hasData) {
                final activeAcademic = snapshot.data!;
                activeYear =
                    academicFromString(activeAcademic.activeAcademicYear);

                return Text("Levels in " +
                    academicYearState(activeAcademic.activeAcademicYear,
                        gradeData.academic.toString()) +
                    " Academic year " +
                    academicYearLabel(gradeData.academic,
                        activeAcademic.incrementalAcademic));
              }
              return Text("");
            }),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    const items = Grade.values;
    return Center(
      child: CircularWidgets(
        centerWidgetRadius: kIsWeb ? 200 : 120,
        radiusOfItem: kIsWeb ? 160 : 120,
        itemsLength: items.length,
        itemBuilder: (BuildContext context, int index) {
          return _gradeItem(context, items[index]);
        },
      ),
    );
  }

  Widget _gradeItem(BuildContext context, Grade grade) {
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.red.shade500,
          boxShadow: [
            BoxShadow(
              offset: Offset(3.0, 3.0),
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 6,
              blurRadius: 10,
            ),
          ]),
      child: InkWell(
        onTap: () => _onGradeClick(context, grade, gradeData.academic),
        child: Center(
          child: Text(
            gradeLabel(grade),
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: kIsWeb ? 20 : 15),
          ),
        ),
      ),
    );
  }

  void _onGradeClick(BuildContext context, Grade grade, Academic academic) {
    String routeName = GradeDepartment.route;
    Object args = GradeDepartmentData(academic: academic, grade: grade);
    if (grade == Grade.g0) {
      routeName = GradeDepartmentSubjects.route;
      args = GradeAndDepartment(grade: grade, academic: academic);
    }
    Navigator.of(context).pushNamed(routeName, arguments: args);
  }

  Future<void> clearAcademicSubjects(List<Subject> subjectList) async {
    for (int i = 0; i < subjectList.length; i++) {
      await _subjectService.deleteItemById(subjectList[i].id);
    }
  }

  Future<Widget> deleteConfirmation(
      BuildContext context, List<Subject> subjectList) async {
    String? Unused = await showDialog<String>(
        context: context,
        builder: (context) {
          return Dialog(
              insetPadding:
                  EdgeInsets.only(bottom: 200, top: 200, left: 300, right: 300),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              backgroundColor: Colors.red.shade200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                        "Are you sure to delete all academic year data..",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: kIsWeb ? 24 : 16)),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      MaterialButton(
                          color: Colors.white,
                          elevation: 100,
                          onPressed: () async {
                            await clearAcademicSubjects(subjectList);
                            Navigator.pop(context);
                          },
                          child: Text("  Yes  ",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: kIsWeb ? 24 : 16))),
                      SizedBox(
                        width: 10,
                      ),
                      MaterialButton(
                          color: Colors.white,
                          elevation: 100,
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                          child: Text("  No  ",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: kIsWeb ? 24 : 16))),
                    ],
                  ),
                ],
              ));
        });
    return Text("");
  }
}

class GradeData {
  final Academic academic;

  GradeData({
    required this.academic,
  });
}
