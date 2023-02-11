import 'package:flutter/material.dart';
import 'package:ssas/entities/app_user.dart';
import 'package:ssas/entities/user_role.dart';
import 'package:ssas/services/lectures_service.dart';
import 'package:ssas/services/user_service.dart';
import 'package:ssas/ui/loading.dart';

import '../../entities/lecture.dart';
import '../../entities/lecture_state.dart';
import '../../entities/subject.dart';
import '../../ui/dialogs/qr_preview.dart';

class LectureDetails extends StatelessWidget {
  static const String route = "/route_lecture_details";
  final LectureDetailsData lectureDetailsData;
  final _lecturesService = LecturesService();
  final _userService = UserService();

  LectureDetails({
    required this.lectureDetailsData,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Lecture>(
        initialData: lectureDetailsData.lecture,
        stream:
            _lecturesService.getItemStreamById(lectureDetailsData.lecture.id),
        builder: (context, snapshot) {
          final lecture = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/img/female_professor.png",
                      width: 32,
                    ),
                    Text(lectureDetailsData.subject.name),
                  ],
                ),
              ),
              centerTitle: true,
              actions: [
                lecture.canCollectAttendance()
                    ? IconButton(
                        onPressed: () => _openQrPreview(
                          context,
                          lectureDetailsData.lecture,
                        ),
                        icon: const Icon(Icons.qr_code_scanner_rounded),
                      )
                    : const SizedBox()
              ],
            ),
            body: Center(child: _buildBody(context, lecture)),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton:
                lecture.state == LectureState.collectingAttendance
                    ? null
                    : FloatingActionButton.extended(
                        onPressed: () => _onEndResumeLecture(
                            context,
                            lecture,
                            lecture.state == LectureState.ended
                                ? LectureState.started
                                : LectureState.ended),
                        label: Text(lecture.state == LectureState.ended
                            ? "Resume Lecture"
                            : "End Lecture"),
                        icon: const Icon(Icons.exit_to_app_rounded),
                      ),
          );
        });
  }

  Widget _buildBody(BuildContext context, Lecture lecture) {
    return StreamBuilder<List<AppUser>>(
        stream: _userService.getUsersSteamWithIds(
          usersIds: lecture.attendancesIds,
          role: Role.student,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _buildStudentsList(snapshot.data!);
          }
          if (snapshot.hasError) {
            print(snapshot.error.toString());
            return Text(snapshot.error.toString());
          }
          return const Loading();
        });
  }

  Widget _buildStudentsList(List<AppUser> students) {
    if (students.isEmpty) {
      return const Text("No attendances");
    }
    return ListView.builder(
        padding: const EdgeInsets.only(bottom: 64),
        itemCount: students.length,
        reverse: true,
        itemBuilder: (context, index) =>
            _studentItem(context, students[index]));
  }

  Widget _studentItem(
    BuildContext context,
    AppUser student,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
        clipBehavior: Clip.hardEdge,
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(student.imgUrl),
          ),
          title: Text(student.name),
          subtitle: Text("Student ID: " + student.student!.N_id!),
        ),
      ),
    );
  }

  void _openQrPreview(BuildContext context, Lecture lecture) async {
    _lecturesService.updateLectureState(
        lecture.id, LectureState.collectingAttendance);
    await showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              child: QrPreview(
            qrPreviewData: lecture.getQrData(),
          ));
        });
    _lecturesService.updateLectureState(lecture.id, LectureState.started);
  }

  void _onEndResumeLecture(
      BuildContext context, Lecture lecture, LectureState state) async {
    await _lecturesService.updateLectureState(lecture.id, state);
  }
}

class LectureDetailsData {
  final Subject subject;
  final Lecture lecture;

  LectureDetailsData({
    required this.subject,
    required this.lecture,
  });
}
