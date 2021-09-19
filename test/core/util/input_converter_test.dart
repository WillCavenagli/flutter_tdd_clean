import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_clean/core/util/input_converter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToUnsignedInt', () {
    test(
      'should return an integer when the string represents an unsigned integer',
      () async {
        // arrange
        const String str = '123';
        // act
        final result = inputConverter.stringtiUnsignedInteger(str);
        // assert
        expect(result, const Right(123));
      },
    );

    test(
      'should return a Failure when the String is not an integer',
      () async {
        // arrange
        const String str = 'abc';
        // act
        final result = inputConverter.stringtiUnsignedInteger(str);
        // assert
        expect(result, Left(InvalidInputFailure()));
      },
    );

    test(
      'should return a Failure when the String is a negative integer',
      () async {
        // arrange
        const String str = '-123';
        // act
        final result = inputConverter.stringtiUnsignedInteger(str);
        // assert
        expect(result, Left(InvalidInputFailure()));
      },
    );
  });
}
