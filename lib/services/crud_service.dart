abstract class CRUD<T> {
  Future<T> getItemById(String id);

  Future<void> createItem(T item);

  Future<void> deleteItemById(String id);

  Future<void> updateItem(T item);

  Stream<List<T>> getItemsStream();

  Stream<T> getItemStreamById(String id);
}
