import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ssas/entities/academic.dart';
import 'package:ssas/entities/app_user.dart';
import 'package:ssas/entities/subject.dart';
import 'package:ssas/screens/doctor/lectures.dart';
import 'package:ssas/services/lectures_service.dart';
import 'package:ssas/services/subject_service.dart';
import 'package:ssas/services/user_service.dart';
import '../../entities/Division.dart';
import '../../entities/activeAcademic.dart';
import '../../entities/department.dart';
import '../../entities/grade.dart';
import '../../entities/semester.dart';
import '../../entities/user_role.dart';
import '../../services/academic_service.dart';
import '../../ui/loading.dart';
import 'generate_report.dart';

class DoctorSubjects extends StatefulWidget {
  static const String route = "/route_doctor_subjects";
  final DoctorSubjectData doctorSubjectData;

  DoctorSubjects({required this.doctorSubjectData, Key? key}) : super(key: key);

  @override
  State<DoctorSubjects> createState() => _DoctorSubjectsState();
}

class _DoctorSubjectsState extends State<DoctorSubjects> {
  final _subjectService = SubjectService();

  final _userService = UserService();

  final _lecturesService = LecturesService();

  final _academicServices = AcademicService();


  bool isActiveYear() => widget.doctorSubjectData.academic == Academic.a0;

  Semester _currentSemester = Semester.s0;
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

                return Text(isActiveYear()
                    ? "Subjects of Active Academic year ${academicYearLabel(widget.doctorSubjectData.academic,activeAcademic.incrementalAcademic)} "
                    : "Subjects of next Academic year ${academicYearLabel(widget.doctorSubjectData.academic,activeAcademic.incrementalAcademic)} ");
              }
              return Text("");
            }),

        centerTitle: true,
      ),
      body: Container(
        child: Stack(
          children: [
            _buildBody(),
            _buildSemesterSelector(),

          ],
        ),
      ),
    );
  }


  Widget _buildBody() {
    return StreamBuilder<List<Subject>>(
        stream: _subjectService.getSubjectStreamForDoctor(
          semester: _currentSemester,
            doctorId: widget.doctorSubjectData.appUser.id,
            academicYear: widget.doctorSubjectData.academic,
        ),


        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return Center(child: Text(snapshot.error.toString()));
          }

          if (snapshot.hasData) {
            return _buildSubjectsList(snapshot.data!);
          }
          return const Center(
            child: Text("Loading"),
          );
        });
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
              style: TextStyle(color: Colors.black87,fontSize: 18),
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
            width: 20,
          ),
          ChoiceChip(
            selectedColor:
            Theme.of(context).colorScheme.secondary.withAlpha(100),
            backgroundColor:
            Theme.of(context).colorScheme.secondary.withAlpha(200),
            label: const Text(
              "Second Semester",
              style: TextStyle(color: Colors.black,fontSize: 18),
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


  Widget _buildSubjectsList(List<Subject> subjects) {
    if (subjects.isEmpty) return const Center(child: Text("No subjects added"));
    return ListView.builder(
      padding: const EdgeInsets.all(8).copyWith(top: 64, bottom: 64),
      itemCount: subjects.length,
      itemBuilder: (context, index) => _buildSubjectItem(
        context,
        subjects[index],
      ),
    );
  }

  Widget _buildSubjectItem(BuildContext context, Subject subject) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: () => _onSubjectClick(context, subject),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  subject.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: kIsWeb?32:20,
                  color: Colors.black87,fontWeight: FontWeight.w600)

                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/img/chronometer.png",
                          width: 24,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "${subject.creditHours} Hours/Week",
                          textAlign: TextAlign.center,
                            style: TextStyle(fontSize: kIsWeb?18:12,
                                color: Colors.black,fontWeight: FontWeight.w300)                        ),
                      ],
                    ),
                    StreamBuilder<int>(
                        initialData: 0,
                        stream:
                            _lecturesService.getLecturesCountStreamForSubject(
                                subject.id, "fake", false),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            print(snapshot.error);
                            return Text(snapshot.error.toString());
                          }
                          final count = snapshot.data!;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/img/lecture.png",
                                width: 24,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "$count Lectures",
                                textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: kIsWeb?18:12,
                                      color: Colors.black,fontWeight: FontWeight.w400)                               ),
                            ],
                          );
                        }),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _infoItem(
                      context,
                      "assets/img/school.png",
                      gradeLabel(subject.grade),
                    ),
                    subject.department != null
                        ? _infoItem(
                            context,
                            subject.division != null?divisionImg(subject.division!):departmentImg(subject.department!),
                      subject.division != null?divisionLabel(subject.division!):departmentLabel(subject.department!),
                          )
                        : const SizedBox(),
                    _infoItem(
                      context,
                      "assets/img/book.png",
                      semesterLabel(subject.semester),
                    )
                  ],
                ),
                _buildDoctorsSection(subject.doctorsIds
                    .where((id) => id != widget.doctorSubjectData.appUser.id)
                    .toList()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoItem(BuildContext context, String imgPath, String label) {
    return Column(
      children: [
        Image.asset(
          imgPath,
          width: 36,
          height: 36,
        ),
        const SizedBox(height: 4),
        Text(
          label,
            style: TextStyle(fontSize: kIsWeb?18:12,
                color: Colors.black,fontWeight: FontWeight.w400)         )
      ],
    );
  }

  Widget _buildDoctorsSection(List<String> docsIds) {
    if (docsIds.isEmpty) return const SizedBox();
    return Container(
      margin: const EdgeInsets.only(top: 16),
      height: 64,
      child: StreamBuilder<List<AppUser>>(
          stream: _userService.getUsersSteamWithIds(
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

  void _onSubjectClick(BuildContext context, Subject subject) {
    Navigator.of(context).pushNamed(Lectures.route,
        arguments: LecturesData(
          currentUser: widget.doctorSubjectData.appUser,
          subject: subject,
        ));
  }
}

class DoctorSubjectData {
  final AppUser appUser;
  final Academic academic;

  DoctorSubjectData({
    required this.appUser,
    required this.academic,
  });
}
