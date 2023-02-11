enum Department { d0, d1, d2, d3, d4 }

Department? departmentFromString(String? department) {
  if (department == null) return null;
  Department? departmentValue;
  for (var item in Department.values) {
    if (item.toString() == department) {
      departmentValue = item;
      break;
    }
  }
  return departmentValue;
}

String departmentLabel(Department d) {
  switch (d) {
    case Department.d0:
      return "Computer";
    case Department.d1:
      return "Electrical Power";
    case Department.d2:
      return "Biomedical";
    case Department.d3:
      return "Communication";
    case Department.d4:
      return "Mechanics";
  }
}

String departmentImg(Department d) {
  switch (d) {
    case Department.d0:
      return "assets/img/monitor.png";
    case Department.d1:
      return "assets/img/electrical_energy.png";
    case Department.d2:
      return "assets/img/medical.png";
    case Department.d3:
      return "assets/img/antenna.png";
    case Department.d4:
      return "assets/img/engineering.png";
  }
}
