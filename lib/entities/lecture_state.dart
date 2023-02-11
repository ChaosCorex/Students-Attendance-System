enum LectureState {
  archived,
  collectingAttendance,
  started,
  ended,
}

LectureState? lectureFromString(String state) {
  LectureState? stateValue;
  for (var item in LectureState.values) {
    if (item.toString() == state) {
      stateValue = item;
      break;
    }
  }
  return stateValue;
}

String lectureLabel(LectureState lecture) {
  switch (lecture) {
    case LectureState.archived:
      return "Archived";
    case LectureState.collectingAttendance:
      return "Collecting Attendance";
    case LectureState.started:
      return "Started";
    case LectureState.ended:
      return "Ended";
  }
}

String lectureIcon(LectureState lecture) {
  switch (lecture) {
    case LectureState.archived:
      return "assets/img/bin.png";
    case LectureState.collectingAttendance:
      return "assets/img/data_collection.png";
    case LectureState.started:
      return "assets/img/start.png";
    case LectureState.ended:
      return "assets/img/finish.png";
  }
}
num lectureCount=0;