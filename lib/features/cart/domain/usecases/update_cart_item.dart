import 'package:dartz/dartz.dart';
import '../../../../core/failures.dart';
import '../../../../core/usecase.dart';
import '../repositories/cart_repository.dart';

class UpdateCartItemParams {
  final String productId;
  final int quantity;

  UpdateCartItemParams(this.productId, this.quantity);
}

class UpdateCartItem implements UseCase<void, UpdateCartItemParams> {
  final CartRepository repository;

  UpdateCartItem(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateCartItemParams params) async {
    return await repository.updateCartItem(params.productId, params.quantity);
  }
}