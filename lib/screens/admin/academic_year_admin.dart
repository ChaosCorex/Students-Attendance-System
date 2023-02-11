import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ssas/entities/app_user.dart';

import '../../entities/academic.dart';
import '../../entities/activeAcademic.dart';
import '../../services/academic_service.dart';
import '../../ui/dialogs/academic_selector.dart';
import '../../ui/dialogs/incermental_academic.dart';
import 'grades.dart';

class AdminAcademicYear extends StatefulWidget {
  final AppUser currentUser;

  const AdminAcademicYear({required this.currentUser, Key? key})
      : super(key: key);

  @override
  State<AdminAcademicYear> createState() => _AdminAcademicYearState();
}

class _AdminAcademicYearState extends State<AdminAcademicYear> {
  Academic? _academicYear;
  final _academicServices = AcademicService();
  ActiveAcademic ? activeAcademicYear;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Acaddemic Years"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                _onSelectActiveAcademic(context);
              },
              icon: Icon(Icons.manage_history)),
          IconButton(
              onPressed: () {
                _onSelectIncermental(context);
              },
              icon: Icon(Icons.edit_outlined))
        ],
      ),
      body: _buildBody(),
    );
  }

  final academics = Academic.values;

  Widget _buildBody() {
    return Padding(
      padding: EdgeInsets.all(kIsWeb?5.0:11.0),
      child: Container(
          height: double.infinity,
          width: double.infinity,
          child: ListView.separated(
              itemBuilder: (context, index) =>
                  buildItem(context, academics[index]),
              separatorBuilder: (context, index) => SizedBox(
                    height: 8.0,
                  ),
              itemCount: 5)),
    );
  }

  Widget buildItem(BuildContext context, Academic academic) {
    return StreamBuilder<ActiveAcademic>(
        stream: _academicServices.getItemStreamById("ssasActiveYear"),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return Text(snapshot.error.toString());
          }
          if (snapshot.hasData) {
            final activeAcademic = snapshot.data!;
            activeAcademicYear = activeAcademic;

            return buildListes(academic,
                academicFromString(activeAcademic.activeAcademicYear));
          }
          return SizedBox();
        });
  }

  Widget buildListes(Academic academic, Academic? ActiveAcademic) {
    return Center(
      child: Container(
        height: 100,
        width: 700,
        child: Card(
          color: mapAcademicStateToColor(academicYearState( ActiveAcademic.toString(),academic.toString())),

          elevation: 49,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: InkWell(
            onTap: () => _onAcademicClick(context, academic),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment:  CrossAxisAlignment.center,
              children: [
                ActiveAcademic == academic
                    ? Icon(
                  Icons.account_balance,
                  size: 24,
                  color: Colors.white,
                )
                    : SizedBox(),
                SizedBox(
                  width: kIsWeb ? 50 : 15,
                ),
                Center(
                    child: Text(
                  "Academic Year ${academicYearLabel(academic,activeAcademicYear!.incrementalAcademic)}",
                  style: TextStyle(fontSize: kIsWeb ? 28 : 20,color: ActiveAcademic == academic?Colors.white:Colors.black),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onAcademicClick(BuildContext context, Academic academic) {
    Navigator.of(context).pushNamed(GradesScreen.route,
        arguments: GradeData(
          academic: academic,
        ));
  }

  void _onSelectActiveAcademic(BuildContext context) async {
    Academic? selectedAcademic = await showDialog<Academic>(
        context: context,
        builder: (context) {
          return const Dialog(child: AcademicSelector());
        });
    if (selectedAcademic == null) {
      return;
    }
    setState(() {
      _academicYear = selectedAcademic;
    });
    if (_academicYear != null)
      await _academicServices.updateActiveAcademicYearInfo("ssasActiveYear",
          ActiveAcademic.activeYearKey, _academicYear.toString());
  }

  void _onSelectIncermental(BuildContext context) async {
    num? selectedincerement = await showDialog<num>(
        context: context,
        builder: (context) {
          return const Dialog(child: IncrementalAcademic());
        });


  }
Color mapAcademicStateToColor(String state)
{
  if(state=="active")
    return Colors.red.shade600;
  else if(state == "next")
    return Colors.red.shade100;
  else return  Colors.grey;

}
}
