import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/usecase.dart';
import '../../domain/usecases/get_products.dart';
import '../../domain/usecases/get_product.dart';
import 'product_state.dart';

class ProductNotifier extends StateNotifier<ProductState> {
  final GetProducts getProducts;
  final GetProduct getProduct;

  ProductNotifier(this.getProducts, this.getProduct) : super(ProductInitial());

  Future<void> fetchProducts() async {
    state = ProductLoading();
    final result = await getProducts(NoParams());
    result.fold(
      (failure) => state = ProductError('Failed to load products'),
      (products) => state = ProductsLoaded(products),
    );
  }

  Future<void> fetchProduct(String id) async {
    state = ProductLoading();
    final result = await getProduct(GetProductParams(id));
    result.fold(
      (failure) => state = ProductError('Failed to load product'),
      (product) => state = ProductLoaded(product),
    );
  }
}
