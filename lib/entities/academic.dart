import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';




enum Academic { a4, a3, a2, a1, a0 }

Academic? academicFromString(String? academic) {
  if (academic == null) return null;
  Academic? academicValue;
  for (var item in Academic.values) {
    if (item.toString() == academic) {
      academicValue = item;
      break;
    }
  }
  return academicValue;
}


String academicYearLabel(Academic? a ,num yearIncremental )  {

  switch (a) {
    case Academic.a0:
      return "${yearIncremental!+1} - ${yearIncremental}";
    case Academic.a1:
      return "${yearIncremental!+2} - ${yearIncremental!+1}";
    case Academic.a2:
      return "${yearIncremental!+3} - ${yearIncremental!+2}";
    case Academic.a3:
      return "${yearIncremental!+4} - ${yearIncremental!+3}";
    case Academic.a4:
      return "${yearIncremental!+5} - ${yearIncremental!+4}";
    case null:
      return "error in academic label";
  }
}
String academicYearState(String activeYear, String currentYear)
{
  int active = int.parse(activeYear.substring(10));
  int current = int.parse(currentYear.substring(10));
  if (active > current) {
    return "previous";
  }
  if (active == current) {
    return "active";
  }
    return "next";


}

