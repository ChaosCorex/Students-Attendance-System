enum Division { d0, d1, d2 }

Division? divisionFromString(String? division) {
  if (division == null) return null;
  Division? divisionValue;
  for (var item in Division.values) {
    if (item.toString() == division) {
      divisionValue = item;
      break;
    }
  }
  return divisionValue;
}

String divisionLabel(Division d) {
  switch (d) {
    case Division.d0:
      return "Production mechanics ";
    case Division.d1:
      return "Industrial Mechanics ";
    case Division.d2:
      return "Mechatronics";

  }

}
String divisionImg(Division  division) {
  switch (division) {
    case Division.d0:
      return "assets/img/production.png";
    case Division.d1:
      return "assets/img/industrial-robot.png";
    case Division.d2:
      return "assets/img/robot.png";
  }
}
