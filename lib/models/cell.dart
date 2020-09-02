class Cell {
  int _row = 0;
  int _column = 0;
  int _adjacentBombs = 0;
  bool _isBomb = false;
  bool _isFlagged = false;
  bool _isFlipped = false;

  Cell(int row, int column) {
    this._row = row;
    this._column = column;
  }

  int getRow() => _row;
  int getColumn() => _column;
  int getAdjacentBombs() => _adjacentBombs;
  bool isBomb() => _isBomb;
  bool isFlipped() => _isFlipped;
  bool isFlagged() => _isFlagged;
  bool isBlank() => (_adjacentBombs == 0);
  
  void flip({bool flipFlagged : false}) {
    if ((!_isFlagged && !_isFlipped) || flipFlagged) {
      _isFlipped = true;
    }
  }

  void flag() {
    if (!_isFlipped) {
      _isFlagged = !_isFlagged;
    }
  }
  
  void setBomb() {
    _isBomb = true;
    _adjacentBombs = -1;
  }


  @override
  bool operator ==(Object other) {
      return other is Cell && (this._row == other.getRow() && this._column == other.getColumn());
  }

  void incrementAdjacentBombsCount() {
    if (!_isBomb) {
      _adjacentBombs++;
    }
  }

  @override
  int get hashCode => _row.hashCode + _column.hashCode;

}