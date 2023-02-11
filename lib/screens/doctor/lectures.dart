import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ssas/entities/app_user.dart';
import 'package:ssas/entities/lecture.dart';
import 'package:ssas/entities/subject.dart';
import 'package:ssas/screens/doctor/lecture_details.dart';
import 'package:ssas/services/lectures_service.dart';
import 'package:ssas/services/user_service.dart';
import '../../entities/lecture_state.dart';
import 'generate_report.dart';

class Lectures extends StatefulWidget {
  static const String route = "/route_lectures";
  final LecturesData lecturesData;

  Lectures({required this.lecturesData, Key? key}) : super(key: key);

  @override
  State<Lectures> createState() => _LecturesState();
}

class _LecturesState extends State<Lectures> {
  final _lecturesService = LecturesService();

  final _usersService = UserService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lectures of ${widget.lecturesData.subject.name}"),
        centerTitle: true,
        actions: [
         kIsWeb? IconButton(
              onPressed: () {
                generateReport(LectureCount);
              },
              icon: Icon(
                Icons.file_download_sharp,
                color: Colors.white,
              )):SizedBox(),
        ],
      ),
      body: StreamBuilder<List<Lecture>>(
          stream: _lecturesService
              .getLecturesStreamForSubject(widget.lecturesData.subject.id),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }

            if (snapshot.hasData) {
              Future.delayed(const Duration(milliseconds: 1000));
              LectureCount = snapshot.data!.length!;
              Total_Attendance.clear();
              for (int i = 0; i < LectureCount; i++) {
                final list = snapshot.data![i].attendancesIds;
                Total_Attendance.add(list);
              }
              return _buildLecturesList(snapshot.data!);
            }
            return const Center(
              child: Text("Loading"),
            );
          }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _onStartNewLecture(context),
        icon: Image.asset(
          "assets/img/female_professor.png",
          width: 32,
        ),
        label: const Text("Start New Lecture"),
      ),
    );
  }

  void generateReport(int lectureCount) async {
    try {
      Map<String, num> TotalMap = mapStudentToAttendance(Total_Attendance);
      Total_Attendance = mapToList(TotalMap);
      for (int i = 0; i < Total_Attendance.length; i++) {
        String id = Total_Attendance[i][0];
        AppUser user = await _usersService.getUserById(id);
        Total_Attendance[i][0] = user.name;
        List<dynamic> list = Total_Attendance[i];
        list.add(user.student!.N_id.toString());
        Total_Attendance.setAll(i, {list});
      }
      await creatSheet(
          Total_Attendance, widget.lecturesData.subject.name, lectureCount);
    } catch (e) {
      print(e.toString());
    }
    // print(Total_Attendance);
    // Total_Attendance.clear();
    // print(Total_Attendance);
    setState(() {});
  }

  Widget _buildLecturesList(List<Lecture> items) {
    if (items.isEmpty) {
      return const Center(child: Text("No Lectures Yet"));
    }
    return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        itemCount: items.length,
        itemBuilder: (context, index) =>
            _buildLectureItem(context, items[index], items.length - index));
  }

  Widget _buildLectureItem(BuildContext context, Lecture item, int number) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: () => _navigateToLectureDetails(
            context,
            item,
            widget.lecturesData.subject,
          ),
          child: ListTile(
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  lectureIcon(item.state),
                  width: 24,
                ),
                Text("#$number"),
              ],
            ),
            title: Text(item.canCollectAttendance()
                ? lectureLabel(item.state)
                : "Total attendance is : ${item.attendancesIds.length}"),
            subtitle: StreamBuilder<AppUser>(
                stream: _usersService.getUserStreamById(item.doctorId),
                builder: (context, snapshot) {
                  String data = "Loading...";
                  if (snapshot.hasData) {
                    final user = snapshot.data!;
                    data = "By Dr.${user.name}";
                  }
                  if (snapshot.hasError) {
                    print(snapshot.error.toString());
                    data = "error";
                  }
                  return Text(data);
                }),
            trailing: item.state != LectureState.ended
                ? IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      _lecturesService.deleteItemById(item.id);
                    },
                  )
                : const SizedBox(),
          ),
        ),
      ),
    );
  }

  void _onStartNewLecture(BuildContext context) async {
    final lecture = await _lecturesService.startNewLecture(
      doctorId: widget.lecturesData.currentUser.id,
      subjectId: widget.lecturesData.subject.id,
    );
    _navigateToLectureDetails(
      context,
      lecture,
      widget.lecturesData.subject,
    );
  }

  void _navigateToLectureDetails(
      BuildContext context, Lecture lecture, Subject subject) {
    Navigator.of(context).pushNamed(
      LectureDetails.route,
      arguments: LectureDetailsData(
        subject: subject,
        lecture: lecture,
      ),
    );
  }

}

class LecturesData {
  final AppUser currentUser;
  final Subject subject;

  LecturesData({
    required this.currentUser,
    required this.subject,
  });
}
