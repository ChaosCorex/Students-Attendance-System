import 'package:flutter/material.dart';
import 'package:ssas/entities/academic.dart';

import '../../entities/activeAcademic.dart';
import '../../services/academic_service.dart';

class AcademicSelector extends StatefulWidget {
  const AcademicSelector({Key? key}) : super(key: key);

  @override
  State<AcademicSelector> createState() => _AcademicSelectorState();
}

class _AcademicSelectorState extends State<AcademicSelector> {
  Academic? _currentAcademic;
  final _academicServices = AcademicService();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white38,
      width: 260,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          runAlignment: WrapAlignment.center,
          runSpacing: 8,
          children: [
            Text(
              "Select Active Year",
              style: Theme.of(context).textTheme.headline5,
            ),
            const SizedBox(height: 15),
            StreamBuilder<ActiveAcademic>(
                stream: _academicServices.getItemStreamById("ssasActiveYear"),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return Text(snapshot.error.toString());
                  }
                  if (snapshot.hasData) {
                    final activeAcademic = snapshot.data!;

                    return buildAcademicSelector(
                        activeAcademic.incrementalAcademic);
                  }
                  return Text("");
                }),
          ],
        ),
      ),
    );
  }

  Widget buildAcademicSelector(num increment) {
    return Container(
      width: 240,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Radio<Academic>(
                value: Academic.a0,
                groupValue: _currentAcademic,
                onChanged: (academic) => _onChangeAcademic(context, academic),
              ),
              Text(
                academicYearLabel(Academic.a0, increment),
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Radio<Academic>(
                value: Academic.a1,
                groupValue: _currentAcademic,
                onChanged: (academic) => _onChangeAcademic(context, academic),
              ),
              Text(
                academicYearLabel(Academic.a1, increment),
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Radio<Academic>(
                value: Academic.a2,
                groupValue: _currentAcademic,
                onChanged: (academic) => _onChangeAcademic(context, academic),
              ),
              Text(
                academicYearLabel(Academic.a2, increment),
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Radio<Academic>(
                value: Academic.a3,
                groupValue: _currentAcademic,
                onChanged: (academic) => _onChangeAcademic(context, academic),
              ),
              Text(
                academicYearLabel(Academic.a3, increment),
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Radio<Academic>(
                value: Academic.a4,
                groupValue: _currentAcademic,
                onChanged: (academic) => _onChangeAcademic(context, academic),
              ),
              Text(
                academicYearLabel(Academic.a4, increment),
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              )
            ],
          ),
        ],
      ),
    );
  }

  void _onChangeAcademic(BuildContext context, Academic? academic) {
    if (academic == null) {
      return;
    }
    setState(() {
      _currentAcademic = academic;
    });
    Navigator.of(context).pop(academic);
  }
}
