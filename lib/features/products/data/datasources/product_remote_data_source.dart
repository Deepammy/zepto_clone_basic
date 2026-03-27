import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../data/datasources/firebase_service.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<ProductModel> getProduct(String id);
  Future<void> addProduct(ProductModel product);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final FirebaseService firebaseService;

  ProductRemoteDataSourceImpl(this.firebaseService);

  @override
  Future<List<ProductModel>> getProducts() async {
    final snapshot = await firebaseService.firestore.collection('products').get();
    return snapshot.docs.map((doc) => ProductModel.fromJson(doc.data())).toList();
  }

  @override
  Future<ProductModel> getProduct(String id) async {
    final doc = await firebaseService.firestore.collection('products').doc(id).get();
    if (doc.exists) {
      return ProductModel.fromJson(doc.data()!);
    } else {
      throw Exception('Product not found');
    }
  }

  @override
  Future<void> addProduct(ProductModel product) async {
    await firebaseService.firestore.collection('products').doc(product.id).set(product.toJson());
  }
}