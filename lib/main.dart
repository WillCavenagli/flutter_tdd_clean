import 'package:flutter/material.dart';
import 'package:flutter_tdd_clean/features/number_trivia/presenter/pages/number_trivia_page.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter TDD',
      debugShowCheckedModeBanner: false,
      home: NumberTriviaPage(),
    );
  }
}
