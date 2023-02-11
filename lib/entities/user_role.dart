enum Role { anonymous, admin, doctor, student, affairs }

Role? roleFromString(String role) {
  Role? roleValue;
  for (var item in Role.values) {
    if (item.toString() == role) {
      roleValue = item;
      break;
    }
  }
  return roleValue;
}

String roleLabel(Role role) {
  switch (role) {
    case Role.anonymous:
      return "Anonymous";
    case Role.admin:
      return "Admin";
    case Role.doctor:
      return "Doctor";
    case Role.student:
      return "Student";
    case Role.affairs:
      return "Affairs";
  }
}
