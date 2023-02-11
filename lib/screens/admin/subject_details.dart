import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ssas/entities/app_user.dart';
import 'package:ssas/entities/department.dart';
import 'package:ssas/entities/grade.dart';
import 'package:ssas/entities/semester.dart';
import 'package:ssas/entities/subject.dart';
import 'package:ssas/services/user_service.dart';
import 'package:ssas/ui/dialogs/doctors_selector.dart';
import 'package:ssas/ui/loading.dart';

import '../../entities/user_role.dart';
import '../../services/subject_service.dart';
import '../../ui/dialogs/EditSubject.dart';

class SubjectDetails extends StatefulWidget {
  static const String route = "/route_subject_details";

  final Subject subject;

  SubjectDetails({required this.subject, Key? key}) : super(key: key);

  @override
  State<SubjectDetails> createState() => _SubjectDetailsState();
}

class _SubjectDetailsState extends State<SubjectDetails> {
  final _subjectService = SubjectService();

  final _userService = UserService();


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Subject>(
        initialData: widget.subject,
        stream: _subjectService.getItemStreamById(widget.subject.id),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error.toString());
          Subject subject = snapshot.data!;
          return Scaffold(
            backgroundColor: Colors.blueGrey.shade100,
            appBar: AppBar(
              title: Text("Subject Details"),
              centerTitle: true,
              actions: [
                IconButton(
                    onPressed: () =>
                        _subjectService.toggleSubjectArchive(subject),
                    tooltip: subject.isArchived ? "Unarchive" : "Archive",
                    icon: Icon(
                      subject.isArchived ? Icons.unarchive : Icons.archive,
                      color: subject.isArchived
                          ? Colors.lightGreen
                          : Colors.brown.shade900,
                    )),
              ],
            ),
            body: _buildBody(context, subject),
          );
        });
  }

  Widget _buildBody(BuildContext context, Subject subject) {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 8),
      children: [
        _buildBodyMainContent(context, subject),
        _buildBodyInfoContent(context, subject),
        _doctorsSection(context, subject),
      ],
    );
  }

  Widget _buildBodyMainContent(BuildContext context, Subject subject) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
      ),
      clipBehavior: Clip.hardEdge,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    subject.name,
                    textAlign: TextAlign.center,
                   style: TextStyle(fontSize: kIsWeb?30:20,
                   fontWeight: FontWeight.w600),
                  ),
                  SizedBox(width: 10),
                  IconButton(
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.black,
                    ),
                    onPressed: () async {

                      final editInfo= await _EditSubjectInfo(context, "Edit Subject name");
                      await _subjectService.updateSubjectInfo(subject.id,
                          Subject.nameKey, editInfo == null ? subject.name: editInfo!);

                    },
                  )
                ],
              ),
            ),

            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: kIsWeb?1100:200,
                  child: Text(
                    subject.description,
                  //  overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.justify,
                    style: Theme
                        .of(context)
                        .textTheme
                        .caption,
                  ),
                ),
                SizedBox(width: 10),
                IconButton(
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.black,
                  ),
                  onPressed: () async {

                    final editInfo= await _EditSubjectInfo(context, "Edit Subject description");
                    await _subjectService.updateSubjectInfo(subject.id,
                        Subject.descriptionKey, editInfo == null ? subject.description: editInfo!);

                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBodyInfoContent(BuildContext context, Subject subject) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
      ),
      clipBehavior: Clip.hardEdge,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
                  style: Theme
                      .of(context)
                      .textTheme
                      .labelLarge,
                ),
                IconButton(
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.black,
                  ),
                  onPressed: () async {

                     final editInfo= await _EditSubjectInfo(context, "Edit Hour");
                        await _subjectService.updateSubjectInfo(subject.id,
                            Subject.creditHoursDateKey, editInfo == null ? subject.creditHours: editInfo!);

                  },
                )
              ],
            ),
            const SizedBox(
              height: 16,
            ),
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
                  departmentImg(subject.department!),
                  departmentLabel(subject.department!),
                )
                    : const SizedBox(),
                _infoItem(
                  context,
                  "assets/img/book.png",
                  semesterLabel(subject.semester),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoItem(BuildContext context, String imgPath, String label) {
    return Column(
      children: [
        Image.asset(
          imgPath,
          width: 32,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme
              .of(context)
              .textTheme
              .caption,
        )
      ],
    );
  }

  Widget _doctorsSection(BuildContext context, Subject subject) {
    final doctorsIdsList = subject.doctorsIds;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
      ),
      clipBehavior: Clip.hardEdge,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Text(
              "Professors",
              style: Theme
                  .of(context)
                  .textTheme
                  .labelLarge,
            ),
            _doctorsList(doctorsIdsList, subject),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: OutlinedButton(
                  onPressed: () => _onAddDoctorToSubject(context, subject),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.add),
                      Text("Add Professor"),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }

  Widget _doctorsList(List<String> ids, Subject subject) {
    if (ids.isEmpty) return const SizedBox();
    return StreamBuilder<List<AppUser>>(
        stream: _userService.getUsersSteamWithIds(
          usersIds: ids,
          role: Role.doctor,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text(snapshot.error.toString());
          if (snapshot.hasData) {
            final data = snapshot.data!;
            return Container(
              height: 164,
              child: ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: data.length,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (context, index) =>
                      _buildDoctorItem(context, subject, data[index])),
            );
          }
          return const Loading();
        });
  }

  Widget _buildDoctorItem(BuildContext context, Subject subject,
      AppUser doctor) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
      ),
      clipBehavior: Clip.hardEdge,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    doctor.imgUrl,
                  ),
                  minRadius: 32,
                  maxRadius: 32,
                ),
                Text(
                  doctor.name,
                  style: Theme
                      .of(context)
                      .textTheme
                      .labelMedium,
                )
              ],
            ),
            Container(
              margin: const EdgeInsets.only(left: 8),
              width: 24,
              child: IconButton(
                  onPressed: () =>
                      _onRemoveDoctorFromSubject(context, subject, doctor.id),
                  padding: const EdgeInsets.all(0),
                  icon: const Icon(
                    Icons.cancel_rounded,
                    color: Colors.red,
                  )),
            )
          ],
        ),
      ),
    );
  }

  void _onRemoveDoctorFromSubject(BuildContext context,
      Subject subject,
      String doctorId,) async {
    await _subjectService.removeDoctorFromSubject(subject, doctorId);
  }

  void _onAddDoctorToSubject(BuildContext context,
      Subject subject,) async {
    AppUser? doctor = await showDialog<AppUser>(
        context: context,
        builder: (context) {
          return Dialog(
              child: DoctorsSelector(
                exceptionsIds: subject.doctorsIds,
              ));
        });
    if (doctor == null) {
      return;
    }

    await _subjectService.addDoctorToSubject(subject, doctor.id);
  }

  Future<String?> _EditSubjectInfo(BuildContext context, String editType) async {
    String? EditInfo = await showDialog<String>(
        context: context,
        builder: (context) {
          return Dialog(child: EditSubjectInfo(editType: editType));
        });

    return EditInfo;
  }
}
