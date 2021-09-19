import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tdd_clean/features/number_trivia/presenter/bloc/number_trivia_bloc.dart';
import 'package:flutter_tdd_clean/features/number_trivia/presenter/widgets/message_display.dart';
import 'package:flutter_tdd_clean/features/number_trivia/presenter/widgets/trivia_controls.dart';
import 'package:flutter_tdd_clean/features/number_trivia/presenter/widgets/trivia_display.dart';
import 'package:flutter_tdd_clean/injection_container.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Trivia'),
      ),
      body: SingleChildScrollView(child: buildBody(context)),
    );
  }

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    final TextEditingController textController = TextEditingController();
    return BlocProvider<NumberTriviaBloc>(
      create: (context) => sl<NumberTriviaBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                builder: (context, state) {
                  if (state is Empty) {
                    return const MessageDisplay(
                      message: 'Start Searching',
                    );
                  } else if (state is Loading) {
                    return SizedBox(
                        height: MediaQuery.of(context).size.height / 3,
                        child:
                            const Center(child: CircularProgressIndicator()));
                  } else if (state is Loaded) {
                    return TriviaDisplay(
                      trivia: state.trivia,
                    );
                  } else if (state is Error) {
                    return MessageDisplay(
                      message: state.message,
                    );
                  } else {
                    return const MessageDisplay(
                      message: 'Unknown Error',
                    );
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TriviaControls(textController: textController)
            ],
          ),
        ),
      ),
    );
  }
}
