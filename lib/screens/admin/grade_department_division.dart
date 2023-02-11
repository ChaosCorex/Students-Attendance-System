import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ssas/entities/grade_department.dart';
import 'package:ssas/services/academic_service.dart';
import '../../entities/Division.dart';
import '../../entities/academic.dart';
import '../../entities/activeAcademic.dart';
import '../../entities/department.dart';
import '../../entities/grade.dart';
import 'grade_deprtment_subjects.dart';
final _academicServices = AcademicService();
class GradeDepartmentDivision extends StatelessWidget {
  static const String route = "/route_grade_department_division";
  final GradeDepartmentDivsionData gradeDepartmentDivsionData;

  const GradeDepartmentDivision(
      {required this.gradeDepartmentDivsionData, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<ActiveAcademic>(
            stream:
            _academicServices.getItemStreamById("ssasActiveYear"),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print(snapshot.error);
                return Text(snapshot.error.toString());
              }
              if (snapshot.hasData)  {
                final activeAcademic = snapshot.data!;

                return Text(
                      " Academic Year " +
                          academicYearLabel(academicFromString(
                              activeAcademic!.activeAcademicYear),activeAcademic.incrementalAcademic) +
                          " ",
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w400),
                );
              }
              return Text("");
            }),

        centerTitle: true,
      ),
      body: Container(color: Colors.grey.shade200, child: _buildBody()),
    );
  }

  final divisions = Division.values;

  Widget _buildBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,

      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            height: 500,
            width: double.infinity,
            child: ListView.separated(
                itemBuilder: (context, index) =>
                    buildItem(context, divisions[index]),
                separatorBuilder: (context, index) => SizedBox(
                      height: 10,
                    ),
                itemCount: divisions.length)),
      ],
    );
  }

  Widget buildItem(BuildContext context, Division division) {
    return Center(
      child: Container(
        height: 150,
        width: 700,
        child: Card(

          color: Colors.red.shade100,
          elevation: 50,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            mainAxisAlignment: division==Division.d2?MainAxisAlignment.start:MainAxisAlignment.center,
            children: [
              division==Division.d2?SizedBox(width: kIsWeb?140:20,):SizedBox(),
              Image.asset(
                divisionImg(division),
                width: kIsWeb ? 80 : 60,
              ),
              SizedBox(width: 50,),
              InkWell(
                onTap: () => _onDivisionClick(context, division),
                child: Center(
                    child: Text(
                  " ${divisionLabel(division)}",
                  style: TextStyle(fontSize: kIsWeb ? 28 : 20),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onDivisionClick(BuildContext context,Division division ) {
    String routeName = GradeDepartmentSubjects.route;
    Object args = GradeAndDepartment(
        grade: gradeDepartmentDivsionData.grade,
        department: gradeDepartmentDivsionData.department ,
        academic: gradeDepartmentDivsionData.academic,
    division: division);
    Navigator.of(context).pushNamed(routeName, arguments: args);
  }
}

class GradeDepartmentDivsionData {
  final Academic academic;
  final Grade grade;
  final Department department;

  GradeDepartmentDivsionData({
    required this.academic,
    required this.grade,
    required this.department,
  });
}
