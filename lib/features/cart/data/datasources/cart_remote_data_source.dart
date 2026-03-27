import '../../../../data/datasources/firebase_service.dart';
import '../models/cart_item_model.dart';

abstract class CartRemoteDataSource {
  Future<List<CartItemModel>> getCartItems();
  Future<void> addToCart(CartItemModel item);
  Future<void> updateCartItem(String productId, int quantity);
  Future<void> removeFromCart(String productId);
  Future<void> clearCart();
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final FirebaseService firebaseService;
  final String userId = 'user1';

  CartRemoteDataSourceImpl(this.firebaseService);

  @override
  Future<List<CartItemModel>> getCartItems() async {
    final snapshot = await firebaseService.firestore
        .collection('users')
        .doc(userId)
        .collection('cart')
        .get();
    return snapshot.docs.map((doc) => CartItemModel.fromJson(doc.data())).toList();
  }

  @override
  Future<void> addToCart(CartItemModel item) async {
    await firebaseService.firestore
        .collection('users')
        .doc(userId)
        .collection('cart')
        .doc(item.product.id)
        .set(item.toJson());
  }

  @override
  Future<void> updateCartItem(String productId, int quantity) async {
    if (quantity <= 0) {
      await removeFromCart(productId);
    } else {
      await firebaseService.firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc(productId)
          .update({'quantity': quantity});
    }
  }

  @override
  Future<void> removeFromCart(String productId) async {
    await firebaseService.firestore
        .collection('users')
        .doc(userId)
        .collection('cart')
        .doc(productId)
        .delete();
  }

  @override
  Future<void> clearCart() async {
    final batch = firebaseService.firestore.batch();
    final snapshot = await firebaseService.firestore
        .collection('users')
        .doc(userId)
        .collection('cart')
        .get();
    for (var doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}