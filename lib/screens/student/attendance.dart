import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:ssas/entities/academic.dart';
import 'package:ssas/entities/subject.dart';
import 'package:ssas/services/subject_service.dart';
import 'package:ssas/ui/loading.dart';
import '../../entities/Division.dart';
import '../../entities/app_user.dart';
import '../../entities/department.dart';
import '../../entities/grade.dart';
import '../../entities/lecture_state.dart';
import '../../entities/semester.dart';
import '../../entities/user_role.dart';
import '../../services/lectures_service.dart';
import '../../services/user_service.dart';

class StudentLanding extends StatefulWidget {
  final AppUser currentUser;
  final Academic? academic;

  StudentLanding({
    Key? key,
    required this.academic,
    required this.currentUser,
  }) : super(key: key);

  @override
  State<StudentLanding> createState() => _StudentLandingState();
}

Map<String, List<double>> TotalAttendance = {};

class _StudentLandingState extends State<StudentLanding> {
  final _subjectService = SubjectService();
  final _userService = UserService();

  final _lecturesService = LecturesService();
  ScrollController scrollController = ScrollController();
  Semester _currentSemester = Semester.s0;
  double Rate = 0;
@override
  void initState() {
    super.initState();
    TotalAttendance.clear();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("Home"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await scrollController.animateTo(
                  scrollController.position.maxScrollExtent,
                  duration: Duration(milliseconds: 500),
                  curve: Curves.linear);
              await Duration(milliseconds: 3000);
              print(TotalAttendance);
              Rate = await getTotalRate();
              _openAttendanceRate(context);
            },
            icon: Icon(Icons.rate_review),
          )
        ],
      ),
      body: Stack(children: [
        Center(
          child: widget.currentUser.student!.grade == null
              ? const Text("Contact students affairs")
              : _buildBody(),
        ),
        _buildSemesterSelector(),
      ]),
    );
  }

  Widget _buildBody() {
    return StreamBuilder<List<Subject>>(
        stream: _subjectService.getSubjectStreamForGradAndDepartment(
          grade: widget.currentUser.student!.grade!,
          department: widget.currentUser.student!.department,
          academic: widget.academic,
          semester: _currentSemester,
          division: widget.currentUser.student!.division,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _buildSubjectList(snapshot.data!);
          }
          if (snapshot.hasError) {
            print(snapshot.error.toString());
          }
          return const Loading();
        });
  }

  Widget _buildSubjectList(List<Subject> subjects) {
    if (subjects.isEmpty) {
      return const Text("No subjects");
    }
    return ListView.builder(
        padding: const EdgeInsets.all(8).copyWith(top: 64, bottom: 64),
        controller: scrollController,
        itemCount: subjects.length,
        itemBuilder: (context, index) =>
            _buildSubjectItem(context, subjects[index]));
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
                  style: kIsWeb
                      ? Theme.of(context).textTheme.headline4
                      : Theme.of(context).textTheme.headlineSmall,
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
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ],
                    ),
                    StreamBuilder<int>(
                        initialData: 0,
                        stream:
                            _lecturesService.getLecturesCountStreamForSubject(
                                subject.id, " ", false),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            print(snapshot.error);
                            return Text(snapshot.error.toString());
                          }
                          final count = snapshot.data!;
                          lectureCount = count;
                          return SizedBox();
                        }),
                    StreamBuilder<int>(
                        initialData: 0,
                        stream:
                            _lecturesService.getLecturesCountStreamForSubject(
                                subject.id, widget.currentUser.id, true),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            print(snapshot.error);
                            return Text(snapshot.error.toString());
                          }
                          final count = snapshot.data!;
                            if(subject.semester == _currentSemester || subject.semester == Semester.extended)

                              {
                                TotalAttendance[subject.name] = [
                                  count.toDouble(),
                                  lectureCount.toDouble()
                                ];
                              }

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/img/lecture.png",
                                width: 24,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "( $count/${lectureCount} ) Lectures ",
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
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
                _buildDoctorsSection(subject.doctorsIds),
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
          width: 26,
          height: 26,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.caption,
        )
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
              setState(()  {
                if (isSelected) {
                  _currentSemester = Semester.s0;
                  TotalAttendance.clear();
                   scrollController.animateTo(
                      scrollController.position.minScrollExtent,
                      curve: Curves.linear,
                      duration: Duration(milliseconds: 500));
                     Rate=0;
                  print(TotalAttendance);
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
                   TotalAttendance.clear();
                    scrollController.animateTo(
                      scrollController.position.minScrollExtent,
                      curve: Curves.linear,
                       duration: Duration(milliseconds: 1000));
                  Rate=0;
                  print(TotalAttendance);

                }
              });
            },
          )
        ],
      ),
    );
  }

  Widget _Attendance_rate(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 8,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: new CircularPercentIndicator(
              radius: 100.0,
              animation: true,
              animationDuration: 3000,
              lineWidth: 15.0,
              percent: getTotalRate(),
              center: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Total Attendance",
                    style: new TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "%${(Rate * 100).round()}",
                    style: new TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),
                ],
              ),
              circularStrokeCap: CircularStrokeCap.butt,
              backgroundColor: Colors.grey,
              progressColor:
                  MapprecentToColor((getTotalRate() * 100).floorToDouble())),
        ),
      ),
    );
  }

  Color MapprecentToColor(double rate) {
    if (rate <= 50) {
      return Colors.red;
    } else if (rate > 50 && rate <= 65) {
      return Colors.deepOrange;
    } else if (rate > 65 && rate <= 75) {
      return Colors.yellow;
    } else if (rate > 75 && rate <= 85) {
      return Colors.blue;
    } else if (rate > 85) return Colors.green;
    return Colors.teal;
  }

  double getTotalRate() {
    double att = 0.0;
    double lec = 0.0;
    double rate = 0.0;
    List<double> lists;
    for (int i = 0; i < TotalAttendance.length; i++) {
      lists = TotalAttendance.values.elementAt(i);
      att = att + lists[0];
      lec = lec + lists[1];
    }
    if(lec==0) return 0.0;
    rate = rate + att / lec;
    return rate;
  }

  void _openAttendanceRate(BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(child: _Attendance_rate(context));
        });
  }

  void _onSubjectClick(BuildContext context, Subject subject) {}
}
