import 'package:equatable/equatable.dart';
import 'package:understand_dart_and_architecture_layer_01/core/errors/exceptions.dart';

abstract class Failure extends Equatable {
  const Failure({required this.message, required this.statusCode});

  final String message;
  final int statusCode;

  String get errorMessage => "$statusCode Error: $message";

  @override
  List<Object> get props => [message, statusCode];
}

class ApiFailure extends Failure {
  const ApiFailure({required super.message, required super.statusCode});

  ApiFailure.fromException(APIException exception)
    : this(message: exception.message, statusCode: exception.statusCode);
}
