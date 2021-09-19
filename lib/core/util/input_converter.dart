import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_clean/core/error/failures.dart';

class InputConverter {
  Either<Failure, int> stringtiUnsignedInteger(String str) {
    try {
      final integer = int.parse(str);
      if (integer < 0) {
        throw const FormatException();
      }
      return Right(integer);
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {}
