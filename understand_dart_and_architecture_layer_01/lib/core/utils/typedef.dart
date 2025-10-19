import 'package:dartz/dartz.dart';
import 'package:understand_dart_and_architecture_layer_01/core/errors/failure.dart';

typedef ResultFuture<T> = Future<Either<Failure, T>>;

typedef ResultVoid = ResultFuture<void>;

typedef DataMap = Map<String, dynamic>;
