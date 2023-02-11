enum Grade { g0, g1, g2, g3, g4 }

Grade? gradeFromString(String grade) {
  Grade? gradeValue;
  for (var item in Grade.values) {
    if (item.toString() == grade) {
      gradeValue = item;
      break;
    }
  }
  return gradeValue;
}

String gradeLabel(Grade grade) {
  switch (grade) {
    case Grade.g0:
      return "Preparatory";
    case Grade.g1:
      return "First Level";
    case Grade.g2:
      return "Second Level";
    case Grade.g3:
      return "Third Level";
    case Grade.g4:
      return "Fourth Level";
  }
}
