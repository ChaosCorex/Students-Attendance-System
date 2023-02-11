import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ssas/entities/app_user.dart';
import 'package:ssas/services/academic_service.dart';

import '../../entities/academic.dart';
import '../../entities/activeAcademic.dart';
import 'doctor_subjects.dart';

class AcademicYear extends StatefulWidget {
  final AppUser currentUser;

  const AcademicYear({required this.currentUser, Key? key}) : super(key: key);

  @override
  State<AcademicYear> createState() => _AcademicYearState();
}

class _AcademicYearState extends State<AcademicYear> {
  final _academicServices = AcademicService();
  String? academicString;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Academic Years"),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  final academics = Academic.values;

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
          height: double.infinity,
          width: double.infinity,
          child: ListView.separated(
              itemBuilder: (context, index) =>
                  buildItem(context, academics[index]),
              separatorBuilder: (context, index) => SizedBox(
                    height: 10,
                  ),
              itemCount: 5)),
    );
  }

  Widget buildItem(BuildContext context, Academic academic) {
    return Center(
      child: StreamBuilder<ActiveAcademic>(
          stream: _academicServices.getItemStreamById("ssasActiveYear"),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
              return Text(snapshot.error.toString());
            }
            if (snapshot.hasData) {
              final activeAcademic = snapshot.data!;

              return buildListAcademic(academic,
                  academicFromString(activeAcademic!.activeAcademicYear));
            }
            return SizedBox();
          }),
    );
  }

  Widget buildListAcademic(Academic academic, Academic? ActiveAcademicYear) {
    return Container(
      height: 100,
      width: 700,
      child: Card(
        color: mapAcademicStateToColor(academicYearState( ActiveAcademicYear.toString(),academic.toString())),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        child: InkWell(
          onTap: () => _onAcademicClick(context, academic),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ActiveAcademicYear == academic
                  ? Icon(
                      Icons.account_balance,
                      size: 24,
                      color: Colors.white,
                    )
                  : SizedBox(),
              SizedBox(
                width: kIsWeb ? 50 : 15,
              ),
              StreamBuilder<ActiveAcademic>(
                  stream: _academicServices.getItemStreamById("ssasActiveYear"),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      print(snapshot.error);
                      return Text(snapshot.error.toString());
                    }
                    if (snapshot.hasData) {
                      final activeAcademic = snapshot.data!;

                      return Center(
                        child: Text(
                          "Academic Year ${academicYearLabel(academic, activeAcademic.incrementalAcademic)}",
                          style: TextStyle(fontSize: kIsWeb ? 28 : 20),
                        ),
                      );
                    }
                    return Text("");
                  }),
            ],
          ),
        ),
      ),
    );
  }

  void _onAcademicClick(BuildContext context, Academic academic) {
    Navigator.of(context).pushNamed(DoctorSubjects.route,
        arguments: DoctorSubjectData(
          academic: academic,
          appUser: widget.currentUser,
        ));
  }

  Color mapAcademicStateToColor(String state)
  {
    if(state=="active")
      return Colors.green;
    else if(state == "next")
      return Colors.black12;
    else return  Colors.blueGrey;

  }

}
