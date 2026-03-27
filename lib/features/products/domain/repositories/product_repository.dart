import 'package:dartz/dartz.dart';
import '../../../../core/failures.dart';
import '../entities/product.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getProducts();
  Future<Either<Failure, Product>> getProduct(String id);
  Future<Either<Failure, void>> addProduct(Product product);
}