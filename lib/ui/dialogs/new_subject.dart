import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ssas/entities/grade_department.dart';
import 'package:ssas/entities/semester.dart';
import 'package:ssas/entities/subject.dart';

import '../../entities/academic.dart';
import 'academic_selector.dart';

class AddNewSubject extends StatefulWidget {
  final GradeAndDepartment gradeAndDepartment;

  const AddNewSubject({required this.gradeAndDepartment, Key? key})
      : super(key: key);

  @override
  State<AddNewSubject> createState() => _AddNewSubjectState();
}

class _AddNewSubjectState extends State<AddNewSubject> {
  final _formKey = GlobalKey<FormState>();

  final _subjectName = TextEditingController();

  final _subjectDesc = TextEditingController();

  final _creditHours = TextEditingController();

  Semester _currentSemester = Semester.s0;


  @override
  Widget build(BuildContext context) {
    return Container(
      width: kIsWeb ? 300 : null,
      padding: const EdgeInsets.all(16.0),
      child: Wrap(
        alignment: WrapAlignment.center,
        runSpacing: 8,
        children: [
          Text(
            "Add New Subject",
            style: Theme
                .of(context)
                .textTheme
                .headline5,
          ),
          _buildBody(context)
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _subjectName,
              validator: _validateName,
              decoration: const InputDecoration(
                filled: true,
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: _creditHours,
              validator: _validateHours,
              decoration: const InputDecoration(
                filled: true,
                labelText: "Hours/Week",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              maxLines: 4,
              minLines: 2,
              controller: _subjectDesc,
              validator: _validateDesc,
              decoration: const InputDecoration(
                filled: true,
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Semester:"),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Radio<Semester>(
                            value: Semester.s0,
                            groupValue: _currentSemester,
                            onChanged: _onChangeSemester,
                          ),
                          const Text("First")
                        ],
                      ),
                      Row(
                        children: [
                          Radio<Semester>(
                            value: Semester.s1,
                            groupValue: _currentSemester,
                            onChanged: _onChangeSemester,
                          ),
                          const Text("Second")
                        ],
                      ),
                      Row(
                        children: [
                          Radio<Semester>(
                            value: Semester.extended,
                            groupValue: _currentSemester,
                            onChanged: _onChangeSemester,
                          ),
                          const Text("Extended")
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () => _onAddNewSubject(context),
              child: const Text("Add Subject"),
            )
          ],
        ));
  }

  String? _validateName(String? data) {
    if (data == null) return null;

    if (data
        .trim()
        .isEmpty) {
      return "Name can not be empty";
    }
    return null;
  }

  String? _validateDesc(String? data) {
    if (data == null) return null;
    if (data
        .trim()
        .isEmpty) {
      return "Description can not be empty";
    }
    return null;
  }

  String? _validateHours(String? data) {
    if (data == null) return null;
    if (data
        .trim()
        .isEmpty) {
      return "Hours can not be empty";
    }
    try {
      int.parse(data);
    } catch (e) {
      return "Please enter numbers";
    }
    return null;
  }

  void _onChangeSemester(Semester? semester) {
    if (semester == null) {
      return;
    }
    setState(() {
      _currentSemester = semester;
    });
  }

  void _onAddNewSubject(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      final subject = Subject(
          id: "",
          name: _subjectName.text,
          description: _subjectDesc.text,
          grade: widget.gradeAndDepartment.grade,
          semester: _currentSemester,
          department: widget.gradeAndDepartment.department,
          creationDate: Timestamp.now(),
          creditHours: _creditHours.text,
          academic:widget.gradeAndDepartment.academic,
        division: widget.gradeAndDepartment.division,
      );
      Navigator.of(context).pop(subject);
    }
  }
}
