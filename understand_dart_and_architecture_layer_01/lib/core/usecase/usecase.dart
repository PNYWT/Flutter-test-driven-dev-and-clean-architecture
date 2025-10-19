import 'package:understand_dart_and_architecture_layer_01/core/utils/typedef.dart';

abstract class UsecaseWithParams<T, Params> {
  const UsecaseWithParams();
  ResultFuture<T> call(Params params);
}

abstract class UsecaseWithOurParams<T> {
  const UsecaseWithOurParams();
  ResultFuture<T> call();
}
