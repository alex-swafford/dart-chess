import 'dart:html';

Iterable<String> thingsTodo() sync* {
  const actions = ['Walk', 'Wash', 'Feed'];
  const pets = ['cats', 'dogs'];

  for (final action in actions) {
    for (final pet in pets) {
      if (pet != 'cats' || action == 'Feed') {
        yield '$action the $pet';
      }
    }
  }
}

/// The players in chess.
enum ChessPlayer { white, black, cat }

/// The pieces in chess.
enum ChessPieceType { pawn, rook, knight, bishop, queen, king, cat }

class ChessPiece {
  ChessPlayer allegience;
  ChessPieceType type;
  ChessPiece(this.type, this.allegience);
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

/// Generates a visual representation of a chess board
/// with click listeners that map events to a ChessGame object.
DivElement generateGameBoard(ChessGame game) {
  var baseElement = DivElement();
  baseElement.className = 'chess';
  for (var row = 1; row <= 8; row++) {
    for (var column = 1; column <= 8; column++) {
      var squareElement = DivElement();
      squareElement.text =
          getTextForChessPiece(game.squares[column - 1][row - 1]);
      squareElement.style.color =
          game.squares[column - 1][row - 1].allegience == ChessPlayer.white
              ? '#3D3'
              : '#90D';
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
        print('clicked on square ' +
            squareElement.style.gridRow.split(' ')[0] +
            ',' +
            squareElement.style.gridColumn.split(' ')[0]);
      });
      baseElement.children.add(squareElement);
    }
  }
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
