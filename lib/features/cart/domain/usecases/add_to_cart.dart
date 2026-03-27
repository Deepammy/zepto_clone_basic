import 'package:dartz/dartz.dart';
import '../../../../core/failures.dart';
import '../../../../core/usecase.dart';
import '../entities/cart_item.dart';
import '../repositories/cart_repository.dart';

class AddToCartParams {
  final CartItem item;

  AddToCartParams(this.item);
}

class AddToCart implements UseCase<void, AddToCartParams> {
  final CartRepository repository;

  AddToCart(this.repository);

  @override
  Future<Either<Failure, void>> call(AddToCartParams params) async {
    return await repository.addToCart(params.item);
  }
}