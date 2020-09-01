import 'package:flutter/material.dart';
import 'package:minesweeper/widgets/board.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Board _board = Board(rowCount: 8, columnCount: 8, bombs: 10,);

  void _resetBoard(BuildContext context) {
    _board.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: _board,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _resetBoard(context),
        tooltip: 'Reset Board',
        child: Icon(Icons.refresh),
      ),
    );
  }
}
