import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ssas/entities/academic.dart';
import 'package:ssas/entities/department.dart';
import 'package:ssas/entities/grade.dart';
import 'package:ssas/entities/semester.dart';
import 'package:ssas/entities/subject.dart';
import 'package:ssas/services/crud_service.dart';

import '../entities/Division.dart';

class SubjectService extends CRUD<Subject> {
  final _subjectsCollection =
      FirebaseFirestore.instance.collection("subjects").withConverter(
            fromFirestore: Subject.fromFirebase,
            toFirestore: Subject.toFirebase,
          );

  @override
  Future<void> createItem(Subject item) {
    final doc = _subjectsCollection.doc();
    return doc.set(item);
  }

  @override
  Future<void> deleteItemById(String id) {
    return _subjectsCollection.doc(id).delete();
  }

  @override
  Future<Subject> getItemById(String id) async {
    return (await _subjectsCollection.doc(id).get()).data()!;
  }

  @override
  Stream<Subject> getItemStreamById(String id) {
    return _subjectsCollection
        .doc(id)
        .snapshots()
        .map((event) => event.data()!);
  }

  @override
  Stream<List<Subject>> getItemsStream() {
    return _subjectsCollection
        .snapshots()
        .map((event) => event.docs.map((e) => e.data()).toList());
  }

  @override
  Future<void> updateItem(Subject item) {
    return _subjectsCollection.doc(item.id).set(item);
  }
  Future<void> updateSubjectInfo(String subjectId,var key ,String edit) async {
    return await _subjectsCollection
        .doc(subjectId)
        .update({key: edit});
  }

  Stream<List<Subject>> getSubjectStreamForGradAndDepartment({
    required Grade grade,
    Department? department,
    Semester? semester,
    Academic? academic,
    Division? division,
  }) {
    Query<Subject> query = _subjectsCollection
        .orderBy(Subject.creationDateKey, descending: true)
        .where(
          Subject.gradeKey,
          isEqualTo: grade.toString(),
        );
    if (department == null) {
      query = query.where(Subject.departmentIdKey, isNull: true);
    } else {
      query = query.where(Subject.departmentIdKey,
          isEqualTo: department.toString());
    }

    query = query.where(Subject.academicYearIdKey,isEqualTo:  academic.toString());
    if(division != null)
      {
        query = query.where(Subject.divisionIdKey,isEqualTo:  division.toString());
      }

    if (semester != null) {
      query = query.where(Subject.semesterKey,
          whereIn: [semester.toString(), Semester.extended.toString()]);
    }
    return query
        .snapshots()
        .map((event) => event.docs.map((e) => e.data()).toList());
  }

  Stream<List<Subject>> clearAcademic({
    required Academic academic,

  }) {
    Query<Subject> query = _subjectsCollection
        .orderBy(Subject.creationDateKey, descending: true)
        .where(
      Subject.academicYearIdKey,
      isEqualTo: academic.toString(),
    );

    return query
        .snapshots()
        .map((event) => event.docs.map((e) => e.data()).toList());
  }

  Future<void> toggleSubjectArchive(Subject subject) async {
    await _subjectsCollection.doc(subject.id).update({
      Subject.isArchivedKey: !subject.isArchived,
    });
  }

  Future<void> removeDoctorFromSubject(Subject subject, String doctorId) async {
    final doctorsIds = subject.doctorsIds;
    doctorsIds.remove(doctorId);
    await _subjectsCollection
        .doc(subject.id)
        .update({Subject.doctorIdKey: doctorsIds});
  }

  Future<void> addDoctorToSubject(Subject subject, String doctorId) async {
    final doctorsIds = subject.doctorsIds;
    doctorsIds.add(doctorId);
    await _subjectsCollection
        .doc(subject.id)
        .update({Subject.doctorIdKey: doctorsIds});
  }

  Stream<List<Subject>> getSubjectStreamForDoctor({
    required String doctorId,
    required Semester semester,
    required Academic academicYear,
  }) {
    Query<Subject> query = _subjectsCollection
        .orderBy(Subject.creationDateKey, descending: true)
        .where(Subject.doctorIdKey, arrayContains: doctorId);
    query = query.where(Subject.academicYearIdKey,
        isEqualTo: academicYear.toString());
    if (semester != null) {
      query = query.where(Subject.semesterKey,
          whereIn: [semester.toString(), Semester.extended.toString()]);
    }
    return query
        .snapshots()
        .map((event) => event.docs.map((e) => e.data()).toList());
  }



}

