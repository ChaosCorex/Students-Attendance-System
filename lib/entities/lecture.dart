import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/qr_parser.dart';
import 'lecture_state.dart';

class Lecture {
  final String id;
  final String doctorId;
  final String subjectId;
  final List<String> attendancesIds;
  final Timestamp creationDate;
  final LectureState state;

  Lecture({
    required this.id,
    required this.doctorId,
    required this.subjectId,
    required this.attendancesIds,
    required this.creationDate,
    required this.state,
  });

  String getQrData() => "${QrFunctions.attendance}$qrDataFunctionSeparator$id";

  bool canCollectAttendance() =>
      state == LectureState.started ||
      state == LectureState.collectingAttendance;

  static Map<String, dynamic> toFirebase(
    Lecture lecture,
    SetOptions? options,
  ) {
    return {
      _doctorIdKey: lecture.doctorId,
      subjectIdKey: lecture.subjectId,
      attendancesIdsKey: lecture.attendancesIds,
      creationDateKey: lecture.creationDate,
      lectureStateKey: lecture.state.toString(),
    };
  }

// deserialization
  static Lecture fromFirebase(DocumentSnapshot ds, SnapshotOptions? options) {
    return Lecture(
        id: ds.id,
        doctorId: ds.get(_doctorIdKey),
        subjectId: ds.get(subjectIdKey),
        attendancesIds: (ds.get(attendancesIdsKey) as List).cast(),
        creationDate: ds.get(creationDateKey),
        state: lectureFromString(ds.get(lectureStateKey))!);
  }

  static const String _doctorIdKey = "doctor_id";
  static const String subjectIdKey = "subject_id";
  static const String attendancesIdsKey = "attendances_ids";
  static const String creationDateKey = "creation_date";
  static const String lectureStateKey = "lecture_state";
}
