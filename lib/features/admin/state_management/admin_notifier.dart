import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zepto_clone/features/products/domain/entities/product.dart';
import '../../products/domain/usecases/add_product.dart';
import 'admin_state.dart';

class AdminNotifier extends StateNotifier<AdminState> {
  final AddProduct addProductUseCase;

  AdminNotifier(this.addProductUseCase) : super(const AdminLoaded());

  Future<void> addNewProduct(Product product, File imageFile,Function onSuccess) async {
    state = const AdminLoading();

    final imageUrl = await uploadImage(imageFile);

    if (imageUrl == null) {
      state = const AdminError('Image upload failed');
      return;
    }

    final updatedProduct = Product(
      id: product.id,
      name: product.name,
      description: product.description,
      price: product.price,
      imageUrl: imageUrl,
      category: product.category,
      isAvailable: product.isAvailable,
    );

    final result = await addProductUseCase.call(
      AddProductParams(updatedProduct),
    );

    result.fold(
      (failure) => state = const AdminError('Failed to add product'),
      (_) {
        onSuccess();
        state = const AdminSuccess('Product added successfully');
      }
    );
  }

  Future<String?> uploadImage(File imageFile) async {
    try {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();

      final ref = FirebaseStorage.instance.ref().child(
        'products/$fileName.jpg',
      );

      final uploadTask = await ref.putFile(imageFile);

      final downloadUrl = await uploadTask.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      return null;
    }
  }

  void reset() {
    state = const AdminLoaded();
  }
}
