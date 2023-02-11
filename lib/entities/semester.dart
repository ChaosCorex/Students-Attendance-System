enum Semester { s0, s1, extended }

Semester? semesterFromString(String semester) {
  Semester? semesterValue;
  for (var item in Semester.values) {
    if (item.toString() == semester) {
      semesterValue = item;
      break;
    }
  }
  return semesterValue;
}

String semesterLabel(Semester semester) {
  switch (semester) {
    case Semester.s0:
      return "First Semester";
    case Semester.s1:
      return "Second Semester";
    case Semester.extended:
      return "Extended";
  }
}
