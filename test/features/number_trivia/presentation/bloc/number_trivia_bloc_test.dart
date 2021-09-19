import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_clean/core/error/failures.dart';
import 'package:flutter_tdd_clean/core/usecases/usecase.dart';
import 'package:flutter_tdd_clean/core/util/input_converter.dart';
import 'package:flutter_tdd_clean/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_tdd_clean/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_tdd_clean/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_tdd_clean/features/number_trivia/presenter/bloc/number_trivia_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockInputConverter extends Mock implements InputConverter {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

void main() {
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;
  late NumberTriviaBloc bloc;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(
        getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
        getRandomNumberTrivia: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter);
  });

  test(
    'initialState should be empty',
    () {
      // assert
      expect(bloc.initialState, equals(Empty()));
    },
  );

  group('GetTriviaForConcreteNumber', () {
    const tNumberString = '1';
    const tNumberParsed = 1;
    const tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    setUp(() {
      registerFallbackValue(const Params(number: tNumberParsed));
    });

    void setUpMockInputConverterSuccess() =>
        when(() => mockInputConverter.stringtiUnsignedInteger(any()))
            .thenReturn(const Right(tNumberParsed));

    void setUpMockGetContreteNumberTriviaSuccess() =>
        when(() => mockGetConcreteNumberTrivia(any()))
            .thenAnswer((_) async => const Right(tNumberTrivia));

    test(
      'should call the InputConverter to validate and convert the String to an unsigned integer',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        setUpMockGetContreteNumberTriviaSuccess();
        // act
        bloc.add(const GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(
            () => mockInputConverter.stringtiUnsignedInteger(any()));
        // assert
        verify(() => mockInputConverter.stringtiUnsignedInteger(tNumberString));
      },
    );

    test(
      'should emit [Error] when input is invalid',
      () async {
        // arrange
        when(() => mockInputConverter.stringtiUnsignedInteger(any()))
            .thenReturn(Left(InvalidInputFailure()));
        // assert later
        expectLater(bloc.stream.asBroadcastStream(),
            emits(const Error(message: INVALID_INPUT_FAILURE_MESSAGE)));
        // act
        bloc.add(const GetTriviaForConcreteNumber(tNumberString));
      },
    );

    test(
      'should get data from the concrete use case',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        setUpMockGetContreteNumberTriviaSuccess();
        // act
        bloc.add(const GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(() => mockGetConcreteNumberTrivia(any()));
        // assert later
        verify(() =>
            mockGetConcreteNumberTrivia(const Params(number: tNumberParsed)));
      },
    );

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        setUpMockGetContreteNumberTriviaSuccess();
        // assert later
        final expected = [Loading(), const Loaded(trivia: tNumberTrivia)];
        expectLater(bloc.stream.asBroadcastStream(), emitsInOrder(expected));
        // act
        bloc.add(const GetTriviaForConcreteNumber(tNumberString));
      },
    );

    test(
      'should emit [Loading, Error] when getting data fails',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(() => mockGetConcreteNumberTrivia(any()))
            .thenAnswer((_) async => Left(ServerFailure()));
        // assert later
        final expected = [
          Loading(),
          const Error(message: SERVER_FAILURE_MESSAGE)
        ];
        expectLater(bloc.stream.asBroadcastStream(), emitsInOrder(expected));
        // act
        bloc.add(const GetTriviaForConcreteNumber(tNumberString));
      },
    );

    test(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(() => mockGetConcreteNumberTrivia(any()))
            .thenAnswer((_) async => Left(CacheFailure()));
        // assert later
        final expected = [
          Loading(),
          const Error(message: CACHE_FAILURE_MESSAGE)
        ];
        expectLater(bloc.stream.asBroadcastStream(), emitsInOrder(expected));
        // act
        bloc.add(const GetTriviaForConcreteNumber(tNumberString));
      },
    );
  });

  group('GetTriviaForRandomNumber', () {
    const tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    setUp(() {
      registerFallbackValue(NoParams());
    });

    void setUpMockGetRandomNumberTriviaSuccess() =>
        when(() => mockGetRandomNumberTrivia(any()))
            .thenAnswer((_) async => const Right(tNumberTrivia));

    test(
      'should get data from the random use case',
      () async {
        // arrange
        setUpMockGetRandomNumberTriviaSuccess();
        // act
        bloc.add(GetTriviaForRandomNumber());
        await untilCalled(() => mockGetRandomNumberTrivia(any()));
        // assert later
        verify(() => mockGetRandomNumberTrivia(NoParams()));
      },
    );

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () async {
        // arrange
        setUpMockGetRandomNumberTriviaSuccess();
        // assert later
        final expected = [Loading(), const Loaded(trivia: tNumberTrivia)];
        expectLater(bloc.stream.asBroadcastStream(), emitsInOrder(expected));
        // act
        bloc.add(GetTriviaForRandomNumber());
      },
    );

    test(
      'should emit [Loading, Error] when getting data fails',
      () async {
        // arrange
        when(() => mockGetRandomNumberTrivia(any()))
            .thenAnswer((_) async => Left(ServerFailure()));
        // assert later
        final expected = [
          Loading(),
          const Error(message: SERVER_FAILURE_MESSAGE)
        ];
        expectLater(bloc.stream.asBroadcastStream(), emitsInOrder(expected));
        // act
        bloc.add(GetTriviaForRandomNumber());
      },
    );

    test(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      () async {
        // arrange
        when(() => mockGetRandomNumberTrivia(any()))
            .thenAnswer((_) async => Left(CacheFailure()));
        // assert later
        final expected = [
          Loading(),
          const Error(message: CACHE_FAILURE_MESSAGE)
        ];
        expectLater(bloc.stream.asBroadcastStream(), emitsInOrder(expected));
        // act
        bloc.add(GetTriviaForRandomNumber());
      },
    );
  });
}
