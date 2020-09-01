import 'package:flutter/cupertino.dart';
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
  Board _board = Board(
    rowCount: 8,
    columnCount: 8,
    bombs: 10,
  );

  void _resetBoard(BuildContext context) {
    _board.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.all(12.0),
                    decoration: BoxDecoration(border: Border.all(width: 4),),
                    child: Text("Running", style: TextStyle(color: Colors.green, fontSize: 30,),),
                  ),
                  Container(
                    padding: EdgeInsets.all(12.0),
                    decoration: BoxDecoration(border: Border.all(width: 4)),
                    child: Text("10 Squares Left", style: TextStyle(color: Colors.green, fontSize: 30,),),
                  ),
                ],
              ),
            ),
            _board,
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _resetBoard(context),
        tooltip: 'Reset Board',
        child: Icon(Icons.refresh),
      ),
    );
  }
}
