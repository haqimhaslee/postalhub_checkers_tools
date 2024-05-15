import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:postalhub_checkers_tools/src/navigator/navigator_services.dart';
import 'package:postalhub_checkers_tools/src/postalhub_ui.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (lightDynamic, darkDynamic) {
      return MaterialApp(
          theme: ThemeData(
            colorScheme: lightDynamic ?? lightColorScheme,
            // useMaterial3: true,
            //  fontFamily: 'GoogleSans',
          ),
          darkTheme: ThemeData(
            colorScheme: darkDynamic ?? darkColorScheme,
            // useMaterial3: true,
            // fontFamily: 'GoogleSans',
          ),
          themeMode: ThemeMode.system,
          debugShowCheckedModeBanner: false,
          home: const NavigatorServices());
    });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Postal Hub Inv Tools"),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
