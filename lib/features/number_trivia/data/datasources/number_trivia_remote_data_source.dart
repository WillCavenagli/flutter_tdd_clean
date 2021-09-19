import 'package:flutter_tdd_clean/core/error/exceptions.dart';
import 'package:flutter_tdd_clean/features/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDataSource {
  /// Calls the http://numbersapi.com/{number} endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  /// Calls the http://numbersapi.com/random endpoint.
  ///
  /// Throws a [ServerException] for all error code.
  Future<NumberTriviaModel> getRandomNumberTrivia();
}
