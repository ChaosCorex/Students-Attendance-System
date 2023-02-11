import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ssas/entities/identity.dart';
import 'package:ssas/services/crud_service.dart';

class IdentityService extends CRUD<Identity> {
  final _identityCollection =
      FirebaseFirestore.instance.collection("identities").withConverter(
            fromFirestore: Identity.fromFirebase,
            toFirestore: Identity.toFirebase,
          );

  @override
  Future<void> createItem(Identity item) {
    final doc = _identityCollection.doc();
    return doc.set(item);
  }

  @override
  Future<void> deleteItemById(String id) {
    return _identityCollection.doc(id).delete();
  }

  @override
  Future<Identity> getItemById(String id) async {
    return (await _identityCollection.doc(id).get()).data()!;
  }

  @override
  Stream<Identity> getItemStreamById(String id) {
    return _identityCollection
        .doc(id)
        .snapshots()
        .map((event) => event.data()!);
  }

  @override
  Stream<List<Identity>> getItemsStream() {
    return _identityCollection
        .snapshots()
        .map((event) => event.docs.map((e) => e.data()).toList());
  }

  @override
  Stream<List<Identity>> getItemsStreamBy(bool isAffairs) => _identityCollection
      .orderBy(Identity.createdAtKey)
      .where(Identity.isCreatedByAffairsKey, isEqualTo: isAffairs)
      .snapshots()
      .map((event) => event.docs.map((e) => e.data()).toList());

  @override
  Future<void> updateItem(Identity item) {
    return _identityCollection.doc(item.id).set(item);
  }

  Future<void> makeIdentityInActive(String identityId) async {
    await _identityCollection
        .doc(identityId)
        .update({Identity.activeKey: false});
  }
}
