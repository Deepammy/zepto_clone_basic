import 'package:dartz/dartz.dart';
import '../../../../core/failures.dart';
import '../../../../core/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductParams {
  final String id;

  GetProductParams(this.id);
}

class GetProduct implements UseCase<Product, GetProductParams> {
  final ProductRepository repository;

  GetProduct(this.repository);

  @override
  Future<Either<Failure, Product>> call(GetProductParams params) async {
    return await repository.getProduct(params.id);
  }
}