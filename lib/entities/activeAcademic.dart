import 'package:cloud_firestore/cloud_firestore.dart';

class ActiveAcademic {
  final String id;
  final String activeAcademicYear;
  final num incrementalAcademic;

  ActiveAcademic({
    required this.id,
    required this.activeAcademicYear,
    required this.incrementalAcademic,
  });

  static Map<String, dynamic> toFirebase(
    ActiveAcademic activeAcademic,
    SetOptions? options,
  ) {
    return {
      activeYearKey: activeAcademic.activeAcademicYear,
      incrementalAcademicKey: activeAcademic.incrementalAcademic,
    };
  }

// deserialization
  static ActiveAcademic fromFirebase(
      DocumentSnapshot ds, SnapshotOptions? options) {
    return ActiveAcademic(
      id: ds.id,
      activeAcademicYear: ds.get(activeYearKey),
      incrementalAcademic: ds.get(incrementalAcademicKey),
    );
  }

  static const String activeYearKey = "active_year";
  static const String incrementalAcademicKey = "incremental_academic";
}
