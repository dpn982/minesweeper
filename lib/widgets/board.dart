import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:minesweeper/models/cell.dart';
import 'dart:math';

class Board extends StatefulWidget {
  final rowCount;
  final columnCount;
  final bombs;

  Board({Key key, this.rowCount, this.columnCount, this.bombs})
      : super(key: key);
  final _BoardState _boardState = _BoardState();

  @override
  _BoardState createState() => _boardState;

  void reset() {
    _boardState.reset();
  }

  int getRemainingCells() {
    return _boardState.getRemainingCells();
  }
}

class _BoardState extends State<Board> {
  List<List<Cell>> _board = new List<List<Cell>>();
  List<Cell> _bombs = new List<Cell>();
  Random _random = new Random();
  int _cellsRemaining = 0;

  void reset() {
    setState(() {
      _initializeBoard();
    });
  }

  int getRemainingCells() {
    return _cellsRemaining;
  }

  void _initializeBoard() {
    _cellsRemaining = widget.columnCount * widget.rowCount;

    _board = List.generate(widget.rowCount, (i) {
      return List.generate(widget.columnCount, (j) {
        return Cell(i, j);
      });
    });

    int bombCount = 0;
    while (bombCount < widget.bombs) {
      int randRow = _random.nextInt(widget.rowCount);
      int randColumn = _random.nextInt(widget.columnCount);

      if (!_board[randRow][randColumn].isBomb()) {
        _board[randRow][randColumn].setBomb();
        _bombs.add(_board[randRow][randColumn]);
        bombCount++;
      }

      for (int offRow = -1; offRow <= 1; offRow++) {
        for (int offColumn = -1; offColumn <= 1; offColumn++) {
          int adjRow = randRow + offRow;
          int adjCol = randColumn + offColumn;

          if (_inBounds(adjRow, adjCol)) {
            _board[adjRow][adjCol].incrementAdjacentBombsCount();
          }
        }
      }
    }
  }

  bool _inBounds(int r, int c) {
    return (r >= 0) &&
        (r < widget.rowCount) &&
        (c >= 0) &&
        (c < widget.columnCount);
  }

  void _gridItemTapped(int x, int y) {
    print("Row: $y, Column: $x");

    setState(() {
      if (_board[y][x].isBlank()) {
        _board[y][x].flip();
        _flipAdjacentBlankCells(_board[y][x]);
      } else {
        _board[y][x].flip();
      }
    });
  }

  void _gridItemLongTapped(int x, int y) {
    print("Long Press - Row: $y, Column: $x");
    setState(() {
      _board[y][x].flag();
    });
  }

  Widget _buildGridItem(int x, int y) {
    Cell _cell = _board[y][x];

    if (_cell.isFlagged()) {
      return Container(
        color: Colors.green,
      );
    } else if (_cell.isFlipped()) {
      if (_cell.isBomb()) {
        return Container(
          child: Text("X"),
          alignment: Alignment.center,
          color: Colors.red,
          constraints: BoxConstraints.tightForFinite(
            width: double.infinity,
            height: double.infinity,
          ),
        );
      }

      if (_cell.getAdjacentBombs() > 0) {
        return Text("${_cell.getAdjacentBombs()}");
      } else if (_cell.isBlank()) {
        return Container(
          color: Colors.white,
        );
      }
    } else {
      return Container(
        color: Colors.black,
      );
    }

    return null;
  }

  Widget _buildGridItems(BuildContext context, int index) {
    int gridStateLength = _board.length;
    int x, y = 0;
    x = (index / gridStateLength).floor();
    y = (index % gridStateLength);
    return GestureDetector(
      onTap: () => _gridItemTapped(x, y),
      onDoubleTap: () => _gridItemLongTapped(x, y),
      child: GridTile(
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.yellow, width: 0.5)),
          child: Center(
            child: _buildGridItem(x, y),
          ),
        ),
      ),
    );
  }

  void _flipSquare(Cell cell) {
    if (!cell.isFlagged() && !cell.isFlipped()) {
      setState(() {
        cell.flip();
        _cellsRemaining--;
      });
    }
  }

  void _flipAdjacentBlankCells(Cell currentSquare) {
    for (int offRow = -1; offRow <= 1; offRow++) {
      for (int offColumn = -1; offColumn <= 1; offColumn++) {
        int adjRow = currentSquare.getRow() + offRow;
        int adjCol = currentSquare.getColumn() + offColumn;

        if (_inBounds(adjRow, adjCol)) {
          Cell neighborCell = _board[adjRow][adjCol];
          if (neighborCell != currentSquare && !neighborCell.isFlipped()) {
            _flipSquare(neighborCell);

            if (neighborCell.isBlank()) {
              _flipAdjacentBlankCells(neighborCell);
            }
          }
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeBoard();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.all(8.0),
        decoration:
            BoxDecoration(border: Border.all(color: Colors.black, width: 2.0)),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _board.length,
          ),
          itemBuilder: _buildGridItems,
          itemCount: _board.length * _board.length,
        ),
      ),
    );
  }
}
