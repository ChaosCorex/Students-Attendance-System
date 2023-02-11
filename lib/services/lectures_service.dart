import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ssas/entities/app_user.dart';
import 'package:ssas/entities/department.dart';
import 'package:ssas/entities/grade.dart';
import 'package:ssas/entities/lecture.dart';
import 'package:ssas/entities/lecture_state.dart';
import 'package:ssas/services/subject_service.dart';
import 'package:ssas/utils/exceptions.dart';
import 'crud_service.dart';

class LecturesService extends CRUD<Lecture> {
  final _lecturesCollection =
      FirebaseFirestore.instance.collection("lectures").withConverter(
            fromFirestore: Lecture.fromFirebase,
            toFirestore: Lecture.toFirebase,
          );

  final _subjectService = SubjectService();

  @override
  Future<void> createItem(Lecture item) {
    final doc = _lecturesCollection.doc();
    return doc.set(item);
  }

  @override
  Future<void> deleteItemById(String id) {
    return _lecturesCollection.doc(id).delete();
  }

  @override
  Future<Lecture> getItemById(String id) async {
    return (await _lecturesCollection.doc(id).get()).data()!;
  }

  @override
  Stream<Lecture> getItemStreamById(String id) {
    return _lecturesCollection
        .doc(id)
        .snapshots()
        .map((event) => event.data()!);
  }

  @override
  Stream<List<Lecture>> getItemsStream() {
    return _lecturesCollection
        .snapshots()
        .map((event) => event.docs.map((e) => e.data()).toList());
  }

  @override
  Future<void> updateItem(Lecture item) {
    return _lecturesCollection.doc(item.id).set(item);
  }

  Stream<List<Lecture>> getLecturesStreamForSubject(String subjectId) {
    Query<Lecture> query = _lecturesCollection
        .orderBy(Lecture.creationDateKey, descending: true)
        .where(Lecture.subjectIdKey, isEqualTo: subjectId);
    return query
        .snapshots()
        .map((event) => event.docs.map((e) => e.data()).toList());
  }

  Stream<int> getLecturesCountStreamForSubject(
      String subjectId, String studentId, bool isStudent) {
    if (isStudent == true) {
      return getLecturesStreamForSubject(subjectId).map((event) {
        int studentCount = 0;
        for (int i = 0; i < event.length; i++) {
          if (event[i].attendancesIds.contains(studentId)) studentCount++;
        }
        return studentCount;
      });
    }

    return getLecturesStreamForSubject(subjectId).map((event) => event.length);
  }

  Future<Lecture> startNewLecture(
      {required String doctorId, required String subjectId}) async {
    final doc = _lecturesCollection.doc();
    final lecture = Lecture(
      id: doc.id,
      doctorId: doctorId,
      subjectId: subjectId,
      attendancesIds: [],
      creationDate: Timestamp.now(),
      state: LectureState.started,
    );
    await doc.set(lecture);
    return lecture;
  }

  Future<Lecture?> recordStudentAttendance(
      AppUser appUser, String lectureId) async {
    final lectureSS = (await _lecturesCollection.doc(lectureId).get());

    if (!lectureSS.exists) {
      return null;
    }
    final lecture = lectureSS.data()!;

    final subject = await _subjectService.getItemById(lecture.subjectId);
    if (subject.grade != appUser.student!.grade ||
        subject.department != appUser.student!.department ||
        ((subject.grade != Grade.g1 || subject.grade != Grade.g0) &&
            (subject.department == Department.d4) &&
            (subject.division != appUser.student!.division))) {
      return null;
    }
    if (lecture.state != LectureState.collectingAttendance) {
      throw LectureAttendanceExpired();
    }
    if(lecture.attendancesIds.contains(appUser.id))
      {return null;}
    _lecturesCollection.doc(lectureId).update({
      Lecture.attendancesIdsKey: FieldValue.arrayUnion([appUser.id])
    });
    return lecture;
  }

  Future<void> updateLectureState(String lectureId, LectureState state) async {
    await _lecturesCollection
        .doc(lectureId)
        .update({Lecture.lectureStateKey: state.toString()});
  }
}
