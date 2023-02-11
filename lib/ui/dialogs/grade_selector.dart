import 'package:flutter/material.dart';

import '../../entities/grade.dart';

class GradeSelector extends StatefulWidget {
  const GradeSelector({Key? key}) : super(key: key);

  @override
  State<GradeSelector> createState() => _GradeSelectorState();
}

class _GradeSelectorState extends State<GradeSelector> {
  Grade? _currentGrade;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          alignment: WrapAlignment.center,
          runSpacing: 8,
          children: [
            Text(
              "Select Grade",
              style: Theme.of(context).textTheme.headline5,
            ),
            buildGradesSelector()
          ],
        ),
      ),
    );
  }

  Widget buildGradesSelector() {
    return Column(
      children: <Widget>[
        Row(
          children: [
            Radio<Grade>(
              value: Grade.g0,
              groupValue: _currentGrade,
              onChanged: (grade) => _onChangeGrade(context, grade),
            ),
            Text(gradeLabel(Grade.g0))
          ],
        ),
        Row(
          children: [
            Radio<Grade>(
              value: Grade.g1,
              groupValue: _currentGrade,
              onChanged: (grade) => _onChangeGrade(context, grade),
            ),
            Text(gradeLabel(Grade.g1))
          ],
        ),
        Row(
          children: [
            Radio<Grade>(
              value: Grade.g2,
              groupValue: _currentGrade,
              onChanged: (grade) => _onChangeGrade(context, grade),
            ),
            Text(gradeLabel(Grade.g2))
          ],
        ),
        Row(
          children: [
            Radio<Grade>(
              value: Grade.g3,
              groupValue: _currentGrade,
              onChanged: (grade) => _onChangeGrade(context, grade),
            ),
            Text(gradeLabel(Grade.g3))
          ],
        ),
        Row(
          children: [
            Radio<Grade>(
              value: Grade.g4,
              groupValue: _currentGrade,
              onChanged: (grade) => _onChangeGrade(context, grade),
            ),
            Text(gradeLabel(Grade.g4))
          ],
        ),
      ],
    );
  }

  void _onChangeGrade(BuildContext context, Grade? grade) {
    if (grade == null) {
      return;
    }
    setState(() {
      _currentGrade = grade;
    });
    Navigator.of(context).pop(grade);
  }
}
