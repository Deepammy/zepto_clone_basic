import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import '../data/datasources/firebase_service.dart';
import '../features/products/data/datasources/product_remote_data_source.dart';
import '../features/products/data/repositories/product_repository_impl.dart';
import '../features/products/domain/repositories/product_repository.dart';
import '../features/products/domain/usecases/get_product.dart';
import '../features/products/domain/usecases/get_products.dart';
import '../features/products/domain/usecases/add_product.dart';
import '../features/cart/data/datasources/cart_remote_data_source.dart';
import '../features/cart/data/repositories/cart_repository_impl.dart';
import '../features/cart/domain/repositories/cart_repository.dart';
import '../features/cart/domain/usecases/get_cart_items.dart';
import '../features/cart/domain/usecases/add_to_cart.dart';
import '../features/cart/domain/usecases/update_cart_item.dart';
import '../features/cart/domain/usecases/remove_from_cart.dart';

final getIt = GetIt.instance;
final GlobalKey<NavigatorState> appNavKey = GlobalKey<NavigatorState>();

Future<void> init() async {
  // Firebase Service
  getIt.registerLazySingleton(() => FirebaseService());

  // Data Sources
  getIt.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<CartRemoteDataSource>(
    () => CartRemoteDataSourceImpl(getIt()),
  );

  // Repositories
  getIt.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(getIt()),
  );

  // Use Cases
  getIt.registerLazySingleton(() => GetProducts(getIt()));
  getIt.registerLazySingleton(() => GetProduct(getIt()));
  getIt.registerLazySingleton(() => AddProduct(getIt()));
  getIt.registerLazySingleton(() => GetCartItems(getIt()));
  getIt.registerLazySingleton(() => AddToCart(getIt()));
  getIt.registerLazySingleton(() => UpdateCartItem(getIt()));
  getIt.registerLazySingleton(() => RemoveFromCart(getIt()));

  // Notifiers
}