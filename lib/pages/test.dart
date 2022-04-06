
class test {
  final boardArray = List.generate(
      8 + 1, (i) => List.filled(8 + 1, 0, growable: false),
      growable: false);
  final scoreBoardArray = [
                          [16,4,2,2,2,2,4,16],
                          [4,4,1,1,1,1,4,4],
                          [2,1,1,1,1,1,1,2],
                          [2,1,1,1,1,1,1,2],
                          [2,1,1,1,1,1,1,2],
                          [2,1,1,1,1,1,1,2],
                          [4,4,1,1,1,1,4,4],
                          [16,4,2,2,2,2,4,16],
                        ];

  int yourColor = -1;
  int enemyColor = -1;
  int whoTurn = 1;

  List<List<int>> legal_moves(int color, board) {
    final legalMoves = List.generate(
        8 + 1, (i) => List.filled(8 + 1, 0, growable: false),
        growable: false);

    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        // can place chip
        if (board[row][col] == 0) {
          if (validMove(color, row, col, board)) {
            legalMoves[row][col] = color;
          }
        }
      }
    }
    return legalMoves;
  }

  void makeMove(board, int x, int y, int piece) {
// Put the piece at x,y
    board[x][y] = piece;
// Figure out the character of the opponent's piece
    int opponent = piece == 1 ? 2 : 1;

// Check to the left
    if (checkFlip(board, x - 1, y, -1, 0, piece, opponent)) {
      flipPieces(board, x - 1, y, -1, 0, piece, opponent);
    }
// Check to the right
    if (checkFlip(board, x + 1, y, 1, 0, piece, opponent)) {
      flipPieces(board, x + 1, y, 1, 0, piece, opponent);
    }
// Check down
    if (checkFlip(board, x, y - 1, 0, -1, piece, opponent)) {
      flipPieces(board, x, y - 1, 0, -1, piece, opponent);
    }
// Check up
    if (checkFlip(board, x, y + 1, 0, 1, piece, opponent)) {
      flipPieces(board, x, y + 1, 0, 1, piece, opponent);
    }
// Check down-left
    if (checkFlip(board, x - 1, y - 1, -1, -1, piece, opponent)) {
      flipPieces(board, x - 1, y - 1, -1, -1, piece, opponent);
    }
// Check down-right
    if (checkFlip(board, x + 1, y - 1, 1, -1, piece, opponent)) {
      flipPieces(board, x + 1, y - 1, 1, -1, piece, opponent);
    }
// Check up-left
    if (checkFlip(board, x - 1, y + 1, -1, 1, piece, opponent)) {
      flipPieces(board, x - 1, y + 1, -1, 1, piece, opponent);
    }
// Check up-right
    if (checkFlip(board, x + 1, y + 1, 1, 1, piece, opponent)) {
      flipPieces(board, x + 1, y + 1, 1, 1, piece, opponent);
    }
  }

// Checks a direction from x,y to see if we can make a move
  bool checkFlip(board, int x, int y, int deltaX, int deltaY, int myPiece,
      int opponentPiece) {
    if ((x < 0 || x > 7) || (y < 0 || y > 7)) {
      return false;
    }
    if (board[x][y] == opponentPiece) {
      while ((x >= 0) && (x < 8) && (y >= 0) && (y < 8)) {
        x += deltaX;
        y += deltaY;
        if ((x < 0 || x > 7) || (y < 0 || y > 7)) {
          return false;
        }
        if (board[x][y] == 0) // not consecutive
          return false;
        if (board[x][y] == myPiece)
          return true; // At least one piece we can flip
        else {
// It is an opponent piece, just keep scanning in our direction
        }
      }
    }
    return false; // Either no consecutive opponent pieces or hit the edge
  }

  void flipPieces(board, int x, int y, int deltaX, int deltaY, int myPiece,
      int opponentPiece) {
    while (board[x][y] == opponentPiece) {
      board[x][y] = myPiece;
      x += deltaX;
      y += deltaY;
    }
  }

  bool validMove(int piece, int x, int y, board) {
// Check that the coordinates are empty
    if (board[x][y] != 0) return false;
// Figure out the character of the opponent's piece
    int opponent = piece == 1 ? 2 : 1;

// If we can flip in any direction, it is valid
// Check to the left
    if (checkFlip(board, x - 1, y, -1, 0, piece, opponent)) return true;
// Check to the right
    if (checkFlip(board, x + 1, y, 1, 0, piece, opponent)) return true;
// Check down
    if (checkFlip(board, x, y - 1, 0, -1, piece, opponent)) return true;
// Check up
    if (checkFlip(board, x, y + 1, 0, 1, piece, opponent)) return true;
// Check down-left
    if (checkFlip(board, x - 1, y - 1, -1, -1, piece, opponent)) return true;
// Check down-right
    if (checkFlip(board, x + 1, y - 1, 1, -1, piece, opponent)) return true;
// Check up-left
    if (checkFlip(board, x - 1, y + 1, -1, 1, piece, opponent)) return true;
// Check up-right
    if (checkFlip(board, x + 1, y + 1, 1, 1, piece, opponent)) return true;
    return false; // If we get here, we didn't find a valid flip direction
  }

  void switchTurn() {
    if (whoTurn == 1) {
      whoTurn = 2;
    } else {
      whoTurn = 1;
    }

  }

  void _move(int x, int y) {

    makeMove(boardArray, x, y, whoTurn);

    switchTurn();

    if (whoTurn == enemyColor) {
      botPlay();
    }
  }

  test() {
    boardArray[3][3] = 1;
    boardArray[3][4] = 2;
    boardArray[4][3] = 2;
    boardArray[4][4] = 1;
  }
}

void botPlay() {
}

void main() {
  test t = test();

}