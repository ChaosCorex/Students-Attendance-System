import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ssas/services/crud_service.dart';

import '../entities/activeAcademic.dart';

class AcademicService extends CRUD<ActiveAcademic> {
  final _academicCollection =
      FirebaseFirestore.instance.collection("academic").withConverter(
            fromFirestore: ActiveAcademic.fromFirebase,
            toFirestore: ActiveAcademic.toFirebase,
          );

  @override
  Future<void> createItem(ActiveAcademic item) {
    final doc = _academicCollection.doc();
    return doc.set(item);
  }

  @override
  Future<void> deleteItemById(String id) {
    return _academicCollection.doc(id).delete();
  }

  @override
  Future<ActiveAcademic> getItemById(String id) async {
    return (await _academicCollection.doc(id).get()).data()!;
  }

  @override
  Stream<ActiveAcademic> getItemStreamById(String id) {
    return _academicCollection
        .doc(id)
        .snapshots()
        .map((event) => event.data()!);
  }

  @override
  Stream<List<ActiveAcademic>> getItemsStream() {
    return _academicCollection
        .snapshots()
        .map((event) => event.docs.map((e) => e.data()).toList());
  }

  @override
  Future<void> updateItem(ActiveAcademic item) {
    return _academicCollection.doc(item.id).set(item);
  }

  Future<void> updateActiveAcademicYearInfo(
      String academicId, var key ,var newUpdate) async {
    return await _academicCollection
        .doc(academicId)
        .update({key: newUpdate});
  }
}
