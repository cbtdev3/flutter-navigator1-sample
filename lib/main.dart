import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: const MyHomePage(title: 'Flutter Demo Home Page'),
      // ここでページのルートを設定 --->
      initialRoute: MyHomePage.routeName,
      routes: <String, WidgetBuilder>{
        MyHomePage.routeName: (BuildContext context) =>
            const MyHomePage(title: 'Home Page'),
        NextPage.routeName: (BuildContext context) =>
            const NextPage(title: 'Next Page'),
      }, // <--- ここまで
    );
  }
}

// Homeページ
class MyHomePage extends StatefulWidget {
  static const routeName = '/'; //ルート名
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

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
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
              style: Theme.of(context).textTheme.headline4,
            ),
            // 画面遷移ボタン ---
            // （.push）
            ElevatedButton(
              onPressed: () async {
                RouteSettings settings = RouteSettings(arguments: _counter);
                var result = await Navigator.of(context).push(
                  MaterialPageRoute(
                    settings: settings,
                    builder: (context) => const NextPage(title: 'Next Page'),
                  ),
                );
                setState(() {
                  _counter = result as int;
                });
              },
              child: const Text('Next Page (.push)'),
            ),
            const SizedBox(height: 10),
            // （.pushNamed）
            ElevatedButton(
              onPressed: () async {
                var args = _counter;
                var result = await Navigator.of(context)
                    .pushNamed('/next', arguments: args);
                setState(() {
                  _counter = result as int;
                });
              },
              child: const Text('Next Page (.pushNamed)'),
            ),
            // --- ここまで
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

// Nextページ
class NextPage extends StatefulWidget {
  static const routeName = '/next'; //ルート名
  const NextPage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<NextPage> createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  int _counter = 0;
  Object? args; //argsの受け取り用

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // argumentsを受け取る --->
    // ※setStateの度にbuildが呼ばれるので初回(argsがnull)の時だけ受け取る
    if (args == null) {
      args = ModalRoute.of(context)!.settings.arguments;
      _counter = args as int;
    }
    // <--- ここまで

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
              style: Theme.of(context).textTheme.headline4,
            ),
            // 画面遷移（戻る）ボタン --->
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, _counter);
              },
              child: const Text(
                'Home Page (.pop)',
              ),
            ),
            // <--- ここまで
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
