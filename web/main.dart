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

/// Data representation of a chess game.
class ChessGame {
  ChessPlayer currentPlayerTurn = ChessPlayer.white;
  List<List<ChessPiece>> squares = [];
  ChessGame() {
    currentPlayerTurn = ChessPlayer.white;
  }
}

/// Generates a visual representation of a chess board
/// with click listeners that map events to a ChessGame object.
DivElement generateGameBoard() {
  var baseElement = DivElement();
  baseElement.className = 'chess';
  for (var row = 1; row <= 8; row++) {
    for (var column = 1; column <= 8; column++) {
      var squareElement = DivElement();
      squareElement.text = row.toString() + ',' + column.toString();
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
      querySelector('#output')?.children = [generateGameBoard()];
    }));
}
