import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure();

  @override
  List<Object> get props => [];
}

class ServerFailure extends Failure {}

class CacheFailure extends Failure {}

class NetworkFailure extends Failure {}

class AuthFailure extends Failure {}

class UnknownFailure extends Failure {
  final String message;

  const UnknownFailure(this.message);

  @override
  List<Object> get props => [message];
}