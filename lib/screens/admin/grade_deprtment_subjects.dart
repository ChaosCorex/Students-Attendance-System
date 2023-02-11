import 'package:flutter/material.dart';
import 'package:ssas/entities/app_user.dart';
import 'package:ssas/entities/grade_department.dart';
import 'package:ssas/entities/semester.dart';
import 'package:ssas/entities/subject.dart';
import 'package:ssas/entities/user_role.dart';
import 'package:ssas/screens/admin/subject_details.dart';
import 'package:ssas/services/subject_service.dart';
import 'package:ssas/services/user_service.dart';
import 'package:ssas/ui/dialogs/new_subject.dart';
import 'package:ssas/ui/loading.dart';

class GradeDepartmentSubjects extends StatefulWidget {
  static const String route = "/route_grade_department_subjects";
  final GradeAndDepartment gradeAndDepartment;
  final _subjectService = SubjectService();
  final _userService = UserService();

  GradeDepartmentSubjects({required this.gradeAndDepartment, Key? key})
      : super(key: key);

  @override
  State<GradeDepartmentSubjects> createState() =>
      _GradeDepartmentSubjectsState();
}

class _GradeDepartmentSubjectsState extends State<GradeDepartmentSubjects> {
  Semester _currentSemester = Semester.s0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white54,
      appBar: AppBar(
        title: Text(widget.gradeAndDepartment.getLabel()),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.grey.shade200,
        child: Stack(
          children: [_buildBody(), _buildSemesterSelector()],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _onAddNewSubject(context),
        label: const Text("New Subject"),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {
    return Center(
      child: StreamBuilder<List<Subject>>(
          stream: widget._subjectService.getSubjectStreamForGradAndDepartment(
            grade: widget.gradeAndDepartment.grade,
            department: widget.gradeAndDepartment.department,
            semester: _currentSemester,
            academic: widget.gradeAndDepartment.academic,
            division: widget.gradeAndDepartment.division,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error.toString());
              return Text(snapshot.error.toString());
            }
            if (snapshot.hasData) {
              return _buildSubjectsList(context, snapshot.data!);
            }
            return const Loading();
          }),
    );
  }

  Widget _buildSemesterSelector() {
    return Container(
      height: 64,
      color: Theme.of(context).colorScheme.secondary.withAlpha(230),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ChoiceChip(
            selectedColor:
                Theme.of(context).colorScheme.secondary.withAlpha(100),
            backgroundColor:
                Theme.of(context).colorScheme.secondary.withAlpha(200),
            label: const Text(
              "First Semester",
              style: TextStyle(color: Colors.white),
            ),
            selected: Semester.s0 == _currentSemester,
            onSelected: (isSelected) {
              setState(() {
                if (isSelected) {
                  _currentSemester = Semester.s0;
                }
              });
            },
          ),
          const SizedBox(
            width: 16,
          ),
          ChoiceChip(
            selectedColor:
                Theme.of(context).colorScheme.secondary.withAlpha(100),
            backgroundColor:
                Theme.of(context).colorScheme.secondary.withAlpha(200),
            label: const Text(
              "Second Semester",
              style: TextStyle(color: Colors.white),
            ),
            selected: Semester.s1 == _currentSemester,
            onSelected: (isSelected) {
              setState(() {
                if (isSelected) {
                  _currentSemester = Semester.s1;
                }
              });
            },
          )
        ],
      ),
    );
  }

  Widget _buildSubjectsList(BuildContext context, List<Subject> subjects) {
    if (subjects.isEmpty) return const Text("Add New Subject");
    return ListView.builder(
        padding: const EdgeInsets.all(8).copyWith(top: 64, bottom: 64),
        itemCount: subjects.length,
        itemBuilder: (context, index) =>
            _buildSubjectItem(context, subjects[index]));
  }

  Widget _buildSubjectItem(BuildContext context, Subject subject) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: () => _onClickSubject(subject),
          child: Container(
            color: subject.isArchived ? Colors.red.shade200 : null,
            child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            onPressed: () =>
                                widget._subjectService.deleteItemById(subject.id),
                            tooltip:"Delete Subject",
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red.shade900,
                            ))
                      ],
                    ),
                    Text(
                      subject.name,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .headline4
                          ?.copyWith(color: Colors.black),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "${subject.creditHours} h",
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.only(left: 12,right: 12),
                      child: Text(
                        subject.description,
                        maxLines: 3,
                        textAlign: TextAlign.justify,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildDoctorsSection(subject.doctorsIds)
                  ],
                )
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorsSection(List<String> docsIds) {
    if (docsIds.isEmpty) return const SizedBox();
    return SizedBox(
      height: 64,
      child: StreamBuilder<List<AppUser>>(
          stream: widget._userService.getUsersSteamWithIds(
            usersIds: docsIds,
            role: Role.doctor,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasError) return Text(snapshot.error.toString());
            if (snapshot.hasData) return _buildDoctorList(snapshot.data!);
            return const Loading();
          }),
    );
  }

  Widget _buildDoctorList(List<AppUser> doctors) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: doctors.length,
        shrinkWrap: true,
        itemBuilder: (context, index) =>
            _buildDoctorItem(context, doctors[index]));
  }

  Widget _buildDoctorItem(BuildContext context, AppUser doctor) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      child: ActionChip(
        avatar: CircleAvatar(
          backgroundImage: NetworkImage(
            doctor.imgUrl,
          ),
        ),
        label: Text(doctor.name),
        onPressed: () {},
      ),
    );
  }

  void _onClickSubject(Subject subject) {
    Navigator.of(context).pushNamed(SubjectDetails.route, arguments: subject);
  }

  void _onAddNewSubject(BuildContext context) async {
    final Subject? newSubject = await showDialog<Subject>(
        context: context,
        builder: (context) {
          return Dialog(
              child: AddNewSubject(
            gradeAndDepartment: widget.gradeAndDepartment,
          ));
        });
    if (newSubject != null) {
      await widget._subjectService.createItem(newSubject);
    }
  }
}
