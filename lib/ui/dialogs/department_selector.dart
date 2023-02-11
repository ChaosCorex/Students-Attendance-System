import 'package:flutter/material.dart';

import '../../entities/department.dart';

class DepartmentSelector extends StatefulWidget {
  const DepartmentSelector({Key? key}) : super(key: key);

  @override
  State<DepartmentSelector> createState() => _DepartmentSelectorState();
}

class _DepartmentSelectorState extends State<DepartmentSelector> {
  Department? _currentDepartment;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          alignment: WrapAlignment.center,
          runSpacing: 8,
          children: [
            Text(
              "Select Department",
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
            Radio<Department>(
              value: Department.d0,
              groupValue: _currentDepartment,
              onChanged: (department) => _onChangeGrade(context, department),
            ),
            Text(departmentLabel(Department.d0))
          ],
        ),
        Row(
          children: [
            Radio<Department>(
              value: Department.d1,
              groupValue: _currentDepartment,
              onChanged: (department) => _onChangeGrade(context, department),
            ),
            Text(departmentLabel(Department.d1))
          ],
        ),
        Row(
          children: [
            Radio<Department>(
              value: Department.d2,
              groupValue: _currentDepartment,
              onChanged: (department) => _onChangeGrade(context, department),
            ),
            Text(departmentLabel(Department.d2))
          ],
        ),
        Row(
          children: [
            Radio<Department>(
              value: Department.d3,
              groupValue: _currentDepartment,
              onChanged: (department) => _onChangeGrade(context, department),
            ),
            Text(departmentLabel(Department.d3))
          ],
        ),
        Row(
          children: [
            Radio<Department>(
              value: Department.d4,
              groupValue: _currentDepartment,
              onChanged: (department) => _onChangeGrade(context, department),
            ),
            Text(departmentLabel(Department.d4))
          ],
        ),
      ],
    );
  }

  void _onChangeGrade(BuildContext context, Department? department) {
    if (department == null) {
      return;
    }
    setState(() {
      _currentDepartment = department;
    });
    Navigator.of(context).pop(department);
  }
}
