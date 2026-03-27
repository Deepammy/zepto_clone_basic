import 'package:dartz/dartz.dart';
import '../../../../core/failures.dart';
import '../../../../core/usecase.dart';
import '../repositories/cart_repository.dart';

class RemoveFromCartParams {
  final String productId;

  RemoveFromCartParams(this.productId);
}

class RemoveFromCart implements UseCase<void, RemoveFromCartParams> {
  final CartRepository repository;

  RemoveFromCart(this.repository);

  @override
  Future<Either<Failure, void>> call(RemoveFromCartParams params) async {
    return await repository.removeFromCart(params.productId);
  }
}