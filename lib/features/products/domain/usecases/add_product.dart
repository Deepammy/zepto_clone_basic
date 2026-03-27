import 'package:dartz/dartz.dart';
import '../../../../core/failures.dart';
import '../../../../core/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class AddProductParams {
  final Product product;

  AddProductParams(this.product);
}

class AddProduct implements UseCase<void, AddProductParams> {
  final ProductRepository repository;

  AddProduct(this.repository);

  @override
  Future<Either<Failure, void>> call(AddProductParams params) async {
    return await repository.addProduct(params.product);
  }
}