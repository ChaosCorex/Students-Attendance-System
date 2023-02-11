import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ssas/entities/Division.dart';
import 'package:ssas/entities/academic.dart';
import 'package:ssas/entities/department.dart';
import 'package:ssas/ui/dialogs/department_selector.dart';
import 'package:ssas/ui/dialogs/grade_selector.dart';
import 'package:ssas/ui/dialogs/role_selector.dart';
import 'package:string_validator/string_validator.dart';

import '../../entities/activeAcademic.dart';
import '../../entities/app_user.dart';
import '../../entities/grade.dart';
import '../../entities/identity.dart';
import '../../entities/user_role.dart';
import '../../services/academic_service.dart';
import 'academic_selector.dart';
import 'divssion_selector.dart';

class NewQrIdentity extends StatefulWidget {
  final AppUser currentUser;

  const NewQrIdentity({required this.currentUser, Key? key}) : super(key: key);

  @override
  State<NewQrIdentity> createState() => _NewQrIdentityState();

  bool isAffairs() => currentUser.role == Role.affairs;
}

class _NewQrIdentityState extends State<NewQrIdentity> {
  final _nationalIdController = TextEditingController();
  final _userNameController = TextEditingController();
  final _academicServices = AcademicService();
  String errorMessage = "";

  Role? _role;
  Grade? _grade;
  Department? _department;
  Division? _division;
  Academic? _academicYear;

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(16.0), child: _buildBody());
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Container(
        width: 380,
        child: Column(
          children: [
            TextFormField(
              keyboardType: TextInputType.name,
              controller: _userNameController,
              decoration: const InputDecoration(
                filled: true,
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: _nationalIdController,
              decoration: const InputDecoration(
                filled: true,
                labelText: "National ID",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 12,
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

                    return _buildAcademicYearSection(
                        activeAcademic.incrementalAcademic);
                  }
                  return Text("");
                }),
            _buildRoleSection(),
            _role != null && _role == Role.student
                ? _buildGradeSection()
                : const SizedBox(),
            _grade != null && _grade != Grade.g0
                ? _buildDepartmentSection()
                : const SizedBox(),
            _department == Department.d4 ? _buildDivisionSection() : SizedBox(),
            Text("${errorMessage}",
                style: TextStyle(
                    color: Colors.red,
                    fontSize: kIsWeb ? 18 : 10,
                    fontWeight: FontWeight.w500)),
            ElevatedButton(
              onPressed: _onSaveClick,
              child: const Text("Save"),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRoleSection() {
    return Column(
      children: [
        InkWell(
          onTap: _onSelectRole,
          child: Container(
            color: Colors.amber.shade100,
            padding: const EdgeInsets.all(9.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _role == null ? "select role" : "Role: " + roleLabel(_role!),
                  style: Theme.of(context).textTheme.headline6,
                ),
                const Icon(Icons.add)
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }

  Widget _buildGradeSection() {
    return Column(
      children: [
        InkWell(
          onTap: _onSelectGrade,
          child: Container(
            color: Colors.red.shade100,
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _grade == null
                      ? "select Level"
                      : "Level: " + gradeLabel(_grade!),
                  style: Theme.of(context).textTheme.headline6,
                ),
                const Icon(Icons.add)
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }

  void _onSelectGrade() async {
    Grade? selectedGrade = await showDialog<Grade>(
        context: context,
        builder: (context) {
          return const Dialog(child: GradeSelector());
        });
    if (selectedGrade == null) {
      return;
    }
    setState(() {
      _grade = selectedGrade;
    });
  }

  Widget _buildDepartmentSection() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: [
          InkWell(
            onTap: _onSelectDepartment,
            child: Container(
              width: 380,
              color: Colors.green.shade100,
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _department == null
                        ? "select department"
                        : "Department: " + departmentLabel(_department!),
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  const Icon(Icons.add)
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }

  Widget _buildAcademicYearSection(num increment) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: [
          InkWell(
            onTap: _onSelectAcademicYear,
            child: Container(
              width: 380,
              color: Colors.teal.shade100,
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _academicYear == null
                        ? "select academic year"
                        : "Academic Year: " +
                            academicYearLabel(_academicYear!, increment),
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  const Icon(Icons.add)
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }

  Widget _buildDivisionSection() {
    return Column(
      children: [
        InkWell(
          onTap: _onSelectDivision,
          child: Container(
            color: Colors.teal.shade100,
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _division == null
                      ? "select division "
                      : "Division: " + divisionLabel(_division!),
                  style: Theme.of(context).textTheme.headline6,
                ),
                const Icon(Icons.add)
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }

  void _onSelectDepartment() async {
    Department? selectedDepartment = await showDialog<Department>(
        context: context,
        builder: (context) {
          return const Dialog(child: DepartmentSelector());
        });
    if (selectedDepartment == null) {
      return;
    }
    setState(() {
      _department = selectedDepartment;
    });
  }

  void _onSelectAcademicYear() async {
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
  }

  void _onSelectDivision() async {
    Division? selectedDivision = await showDialog<Division>(
        context: context,
        builder: (context) {
          return const Dialog(child: DivisionSelector());
        });
    if (selectedDivision == null) {
      return;
    }
    setState(() {
      _division = selectedDivision;
    });
  }

  void _onSelectRole() async {
    Role? selectedRole = await showDialog<Role>(
        context: context,
        builder: (context) {
          return Dialog(
              child: RoleSelector(
            widget.isAffairs(),
            null,
            isForQrIdentity: true,
          ));
        });
    if (selectedRole == null) {
      return;
    }
    setState(() {
      _role = selectedRole;
    });
  }

  void _onSaveClick() async {
    if (_userNameController.text.trim().isEmpty) {
      setState(() {
        errorMessage = "Name can not be empty";
      });
      return;
    } else {
      setState(() {
        errorMessage = "";
      });
    }
    if (isNumeric(_userNameController.text.trim())== true) {
      setState(() {
        errorMessage = "Name must have characters only";
      });
      return;
    } else {
      setState(() {
        errorMessage = "";
      });
    }
    if (_userNameController.text.trim().length < 5) {
      setState(() {
        errorMessage = "Name must have more than 5 character";
      });
      return;
    } else {
      setState(() {
        errorMessage = "";
      });
    }

    if (_nationalIdController.text.trim().isEmpty) {
      setState(() {
        errorMessage = "National id can not be empty";
      });
      return;
    } else {
      setState(() {
        errorMessage = "";
      });
    }
    if(isNumeric(_nationalIdController.text.trim()) == false){
      setState(() {
        errorMessage = "National id must have numbers";
      });
      return;
    }else {
      setState(() {
        errorMessage = "";
      });
    }
    if (_nationalIdController.text.trim().length <8) {
      setState(() {
        errorMessage = "National id must more than 8 numbers";
      });
      return;
    } else {
      setState(() {
        errorMessage = "";
      });
    }
    if (_academicYear == null) {
      setState(() {
        errorMessage = "Please select academic year";
      });
      return;
    } else {
      errorMessage = "";
    }
    if (_role == null) {
      setState(() {
        errorMessage = "Please select role ";
      });
      return;
    } else {
      setState(() {
        errorMessage = "";
      });
    }
    if (_role! == Role.student && _grade == null) {
      errorMessage = "Please select level ";
      return;
    } else {
      setState(() {
        errorMessage = "";
      });
    }
    if (widget.isAffairs() && _grade != Grade.g0 && _department == null) {
      setState(() {
        errorMessage = "Please select department ";
      });
      return;
    } else {
      setState(() {
        errorMessage = "";
      });
    }
    if (widget.isAffairs() &&
        _department == Department.d4 &&
        _division == null &&
        (_grade != Grade.g0 || _grade != Grade.g1)) {
      setState(() {
        errorMessage = "Please select division ";
      });
    } else {
      setState(() {
        errorMessage = "";
      });
    }
    Navigator.of(context).pop(
      Identity(
          id: "",
          nationalId: _nationalIdController.text,
          role: _role!,
          active: true,
          isCreatedByAffairs: widget.isAffairs(),
          createdAt: Timestamp.now(),
          studentGrade: _grade,
          studentDepartment: _department,
          academicYear: _academicYear,
          studentName: _userNameController.text,
          studentDivision: _division),
    );
  }
}
