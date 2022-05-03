import 'dart:html';

import 'dart:math';

/// The players in chess.
enum ChessPlayer { white, black, cat }

/// The pieces in chess.
enum ChessPieceType { pawn, rook, knight, bishop, queen, king, cat }

class ChessPiece {
  ChessPlayer allegience;
  ChessPieceType type;
  ChessPiece(this.type, this.allegience);
}

class ChessMove {
  Point start;
  Point end;
  ChessMove(this.start, this.end);
}

String getTextForChessPiece(ChessPiece piece) {
  switch (piece.type) {
    case ChessPieceType.bishop:
      return '♝';
    case ChessPieceType.cat:
      return '   ';
    case ChessPieceType.king:
      return '♚';
    case ChessPieceType.knight:
      return '♞';
    case ChessPieceType.pawn:
      return '♟';
    case ChessPieceType.queen:
      return '♛';
    case ChessPieceType.rook:
      return '♜';
  }
}

class Point {
  int x;
  int y;
  Point(this.x, this.y);
}

/// Data representation of a chess game.
class ChessGame {
  ChessPlayer currentPlayerTurn = ChessPlayer.white;
  List<List<ChessPiece>> squares = [];
  getStartingPieceForPosition(int x, int y) {
    switch (y) {
      case 0:
        switch (x) {
          case 0:
          case 7:
            return ChessPiece(ChessPieceType.rook, ChessPlayer.black);
          case 1:
          case 6:
            return ChessPiece(ChessPieceType.knight, ChessPlayer.black);
          case 2:
          case 5:
            return ChessPiece(ChessPieceType.bishop, ChessPlayer.black);
          case 3:
            return ChessPiece(ChessPieceType.queen, ChessPlayer.black);
          case 4:
            return ChessPiece(ChessPieceType.king, ChessPlayer.black);
          default:
            return ChessPiece(ChessPieceType.cat, ChessPlayer.cat);
        }
      case 1:
        return ChessPiece(ChessPieceType.pawn, ChessPlayer.black);
      case 6:
        return ChessPiece(ChessPieceType.pawn, ChessPlayer.white);
      case 7:
        switch (x) {
          case 0:
          case 7:
            return ChessPiece(ChessPieceType.rook, ChessPlayer.white);
          case 1:
          case 6:
            return ChessPiece(ChessPieceType.knight, ChessPlayer.white);
          case 2:
          case 5:
            return ChessPiece(ChessPieceType.bishop, ChessPlayer.white);
          case 3:
            return ChessPiece(ChessPieceType.queen, ChessPlayer.white);
          case 4:
            return ChessPiece(ChessPieceType.king, ChessPlayer.white);
          default:
            return ChessPiece(ChessPieceType.cat, ChessPlayer.cat);
        }
      default:
        return ChessPiece(ChessPieceType.cat, ChessPlayer.cat);
    }
  }

  List<Point> getRookMoves(int x, int y, {int maxRange = 8}) {
    if (x < 0 || x > 7 || y < 0 || y > 7) {
      return [];
    }
    List<Point> moves = [];
    for (int xIter = x + 1; xIter < 8 && xIter - x < maxRange; xIter++) {
      moves.add(Point(xIter, y));
    }
    for (int xIter = x - 1; xIter >= 0 && x - xIter < maxRange; xIter--) {
      moves.add(Point(xIter, y));
    }
    for (int yIter = y + 1; yIter < 8 && yIter - y < maxRange; yIter++) {
      moves.add(Point(x, yIter));
    }
    for (int yIter = y - 1; yIter >= 0 && y - yIter < maxRange; yIter--) {
      moves.add(Point(x, yIter));
    }
    return moves;
  }

  List<Point> getKnightMoves(int x, int y) {
    return [];
  }

  List<Point> getBishopMoves(int x, int y, {int maxRange = 8}) {
    if (x < 0 || x > 7 || y < 0 || y > 7) {
      return [];
    }
    List<Point> moves = [];
    bool intersectedNE = false;
    bool intersectedNW = false;
    bool intersectedSE = false;
    bool intersectedSW = false;
    for (int dist = 1; dist < 8 && dist <= maxRange; dist++) {
      if (x + dist < 8 && y + dist < 8 && !intersectedNE) {
        moves.add(Point(x + dist, y + dist));
        if (squares[x + dist][y + dist].type != ChessPieceType.cat) {
          intersectedNE = true;
        }
      }
      if (x + dist < 8 && y - dist >= 0 && !intersectedSE) {
        moves.add(Point(x + dist, y - dist));
        if (squares[x + dist][y - dist].type != ChessPieceType.cat) {
          intersectedSE = true;
        }
      }
      if (x - dist >= 0 && x + dist < 8 && !intersectedNW) {
        moves.add(Point(x - dist, y + dist));
        if (squares[x - dist][y + dist].type != ChessPieceType.cat) {
          intersectedNW = true;
        }
      }
      if (x - dist >= 0 && x + dist >= 0 && !intersectedSW) {
        moves.add(Point(x - dist, y - dist));
        if (squares[x + dist][y + dist].type != ChessPieceType.cat) {
          intersectedSW = true;
        }
      }
    }
    return moves;
  }

  List<Point> getPawnMoves(int x, int y) {
    List<Point> moves = [];
    var pieceToMove = squares[x][y];
    switch (pieceToMove.allegience) {
      case ChessPlayer.cat:
        break;
      case ChessPlayer.white:
        if (y <= 0) {
          break;
        }
        if (squares[x][y - 1].type == ChessPieceType.cat) {
          moves.add(Point(x, y - 1));
        }
        if (x >= 1 && squares[x - 1][y - 1].allegience == ChessPlayer.black) {
          moves.add(Point(x - 1, y - 1));
        }
        if (x <= 6 && squares[x + 1][y - 1].allegience == ChessPlayer.black) {
          moves.add(Point(x + 1, y - 1));
        }
        break;
      case ChessPlayer.black:
        if (y >= 7) {
          break;
        }
        if (squares[x][y + 1].type == ChessPieceType.cat) {
          moves.add(Point(x, y - 1));
        }
        if (x >= 1 && squares[x - 1][y + 1].allegience == ChessPlayer.black) {
          moves.add(Point(x - 1, y + 1));
        }
        if (x <= 6 && squares[x + 1][y - 1].allegience == ChessPlayer.black) {
          moves.add(Point(x + 1, y + 1));
        }
        break;
    }
    return moves;
  }

  List<Point> getValidMoves(Point pointToMoveFrom) {
    if (pointToMoveFrom.x < 0 ||
        pointToMoveFrom.x > 7 ||
        pointToMoveFrom.y < 0 ||
        pointToMoveFrom.y > 7 ||
        pointToMoveFrom.x < 0 ||
        pointToMoveFrom.x > 7 ||
        pointToMoveFrom.y < 0 ||
        pointToMoveFrom.y > 7) {
      return [];
    }
    var x = pointToMoveFrom.x;
    var y = pointToMoveFrom.y;

    var pieceToMove = squares[x][y];
    List<Point> possibleDestinations = [];
    switch (pieceToMove.type) {
      case ChessPieceType.king:
        possibleDestinations.addAll(getBishopMoves(x, y, maxRange: 1));
        possibleDestinations.addAll(getRookMoves(x, y, maxRange: 1));
        break;
      case ChessPieceType.queen:
        possibleDestinations.addAll(getBishopMoves(x, y));
        possibleDestinations.addAll(getRookMoves(x, y));
        break;
      case ChessPieceType.bishop:
        possibleDestinations.addAll(getBishopMoves(x, y));
        break;
      case ChessPieceType.rook:
        possibleDestinations.addAll(getRookMoves(x, y));
        break;
      case ChessPieceType.knight:
        possibleDestinations.addAll(getKnightMoves(x, y));
        break;
      case ChessPieceType.pawn:
        possibleDestinations.addAll(getPawnMoves(x, y));
        break;
      case ChessPieceType.cat:
        return [];
    }
    return possibleDestinations;
  }

  bool makeMove(Point start, Point end) {
    var pieceToMove = squares[start.x][start.y];
    if (pieceToMove.allegience == ChessPlayer.cat) {
      return false;
    }
    squares[end.x][end.y] = pieceToMove;
    squares[start.x][start.y] = ChessPiece(ChessPieceType.cat, ChessPlayer.cat);
    return true;
  }

  ChessGame() {
    currentPlayerTurn = ChessPlayer.white;
    for (var x = 0; x < 8; x++) {
      squares.add([]);
      for (var y = 0; y < 8; y++) {
        squares[x].add(getStartingPieceForPosition(x, y));
      }
    }
  }
}

class ChessGameGuiData {
  Point selectedSquare = Point(-1, -1);
  Point targetSquare = Point(-1, -1);

  select(Point p) {
    selectedSquare = p;
  }

  setTarget(Point p) {
    targetSquare = p;
  }

  clear() {
    selectedSquare.x = -1;
    selectedSquare.y = -1;
    targetSquare.x = -1;
    targetSquare.y = -1;
  }
}

void updateGameBoardGui(ChessGame game, DivElement baseElement) {
  for (var squareElement in baseElement.children) {
    var column = int.tryParse(squareElement.style.gridColumn.split(' ')[0]);
    var row = int.tryParse(squareElement.style.gridRow.split(' ')[0]);
    if (row == null || column == null) {
      return;
    }
    squareElement.text =
        getTextForChessPiece(game.squares[column - 1][row - 1]);
    squareElement.style.color =
        game.squares[column - 1][row - 1].allegience == ChessPlayer.white
            ? '#3D3'
            : game.squares[column - 1][row - 1].allegience == ChessPlayer.black
                ? '#90D'
                : '#FFF';
  }
}

/// Generates a visual representation of a chess board
/// with click listeners that map events to a ChessGame object.
DivElement generateGameBoard(ChessGame game) {
  var guiData = ChessGameGuiData();
  var baseElement = DivElement();
  baseElement.className = 'chess';
  for (var row = 1; row <= 8; row++) {
    for (var column = 1; column <= 8; column++) {
      var squareElement = DivElement();
      squareElement.style.gridRow = row.toString();
      squareElement.style.gridColumn = column.toString();
      var colorationClass = row % 2 == 0
          ? column % 2 == 0
              ? 'white-square'
              : 'black-square'
          : column % 2 == 0
              ? 'black-square'
              : 'white-square';
      squareElement.className = 'chess-square ' + colorationClass;
      squareElement.onClick.listen((event) {
        if (guiData.selectedSquare.x == -1) {
          guiData.selectedSquare = Point(column - 1, row - 1);
        } else {
          guiData.targetSquare = Point(column - 1, row - 1);
          game.makeMove(guiData.selectedSquare, guiData.targetSquare);
          print('making move from [' +
              guiData.selectedSquare.x.toString() +
              ',' +
              guiData.selectedSquare.y.toString() +
              '] to [' +
              guiData.targetSquare.x.toString() +
              ',' +
              guiData.targetSquare.y.toString() +
              ']');
          guiData.clear();
          updateGameBoardGui(game, baseElement);
        }
        print('clicked on square ' +
            squareElement.style.gridRow.split(' ')[0] +
            ',' +
            squareElement.style.gridColumn.split(' ')[0]);
      });
      baseElement.children.add(squareElement);
    }
  }
  updateGameBoardGui(game, baseElement);
  return baseElement;
}

LIElement newLI(String itemText) => LIElement()..text = itemText;

var passwords = {'BilboBaggins': 'Pockets1#', 'Aragorn': 'GondorThrone'};

void login() {
  print('Login button pressed.');
  var username = (querySelector('#username-input') as InputElement).value;
  var password = (querySelector('#password-input') as InputElement).value;
  var expectedPassword = passwords[username];
  if (password == expectedPassword) {
    print('Login success.');
  } else {
    print('Login failed.');
    print('Username: ' +
        username.toString() +
        '. Password: ' +
        password.toString());
  }
}

void main() {
  // var loginDiv = new DivElement();
  // querySelector('#output')?.text = 'Dart Web Application';
  querySelector('#login-button')?.onClick.listen((event) {
    login();
  });
  querySelector('#output')?.children.add(ButtonElement()
    ..setInnerHtml('Generate ChessBoard')
    ..onClick.listen((event) {
      querySelector('#output')?.children = [generateGameBoard(ChessGame())];
    }));
}
