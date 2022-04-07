import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../models/linking.dart';
import 'home.dart';

class BoardGame extends StatefulWidget {
  const BoardGame({Key? key}) : super(key: key);

  @override
  _BoardGameState createState() => _BoardGameState();
}

class _BoardGameState extends State<BoardGame> {
  final boardArray = List.generate(
      8 + 1, (i) => List.filled(8 + 1, 0, growable: false),
      growable: false);

  int yourColor = -1;
  int enemyColor = -1;
  int whoTurn = 1;
 bool isShowEnd = false;
  final blackImage = Image.asset('assets/images/Black.png');
  final whiteImage = Image.asset('assets/images/White.png');
  final drawImage = Image.asset('assets/images/Draw.png');
  final canPlaceImage = Image.asset('assets/images/CanPlace.png');
  final transparentImage = Image.asset('assets/images/Transparent.png');
  @override
  void didChangeDependencies() {
    precacheImage(blackImage.image, context);
    precacheImage(whiteImage.image, context);
    precacheImage(drawImage.image, context);
    precacheImage(canPlaceImage.image, context);
    precacheImage(transparentImage.image, context);
    super.didChangeDependencies();
  }

  int getScoreColor(int color) {
    int c = 0;
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if (boardArray[i][j] == color) {
          c++;
        }
      }
    }
    return c;
  }

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

  /**
   * http://www.cse.uaa.alaska.edu/~afkjm/csce211/handouts/othello.pdf
   */
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

  void switchTurn(var from) {
    if (whoTurn == 1) {
      whoTurn = 2;
    } else {
      whoTurn = 1;
    }
    print('switch from ${whoTurn} turn $from');


    Future.delayed(const Duration(milliseconds: 500), () {
      AudioCache audioPlayer = AudioCache();

      var result = audioPlayer.play(
          'sounds/switch.wav',

          volume: 0.3);
      result.then((value) {});

    });
    setState(() {});

    if(whoTurn == enemyColor) {
      botPlay();
    }
  }

  final scoreBoardArray = [
    [100,1,1,1,1,1,1,100],
    [1,1,1,1,1,1,2,1],
    [1,1,1,1,1,1,1,1],
    [1,1,1,1,1,1,1,1],
    [1,1,1,1,1,1,1,1],
    [1,1,1,1,1,1,1,1],
    [1,1,1,1,1,1,1,1],
    [100,1,1,1,1,1,1,100],
  ];

  void _move(int x, int y) {

    makeMove(boardArray, x, y, whoTurn);

    AudioCache audioPlayer = AudioCache();

    var result = audioPlayer.play(
        'sounds/move.wav',

        volume: 1);
    result.then((value) {});

    switchTurn('_move');


  }

  void botPlay() {
    Future.delayed(const Duration(milliseconds: 3000), () {
      var clone = List.generate(
          8 + 1, (i) => List.filled(8 + 1, 0, growable: false),
          growable: false);

      for (int i = 0; i < 8; i++) {
        for (int j = 0; j < 8; j++) {
          clone[i][j] = boardArray[i][j];
        }
      }
      var canPlay = legal_moves(enemyColor, clone);


      LinkingValue root = LinkingValue(-1, -1, -99999);

      for (int i = 0; i < 8; i++) {
        for (int j = 0; j < 8; j++) {
          if (canPlay[i][j] == enemyColor) {
            makeMove(clone, i, j, whoTurn);
            LinkingValue next_root = LinkingValue(i, j, 0);
            int count = 0;

            root.next['$i,$j'] = next_root;

            int team = enemyColor; //is bot
            for(int lv=0;lv<2;++lv) {
               // print('score lv=$lv count=$count p=$team $i,$j');
              for (int r = 0; r < 8; r++) {
                for (int c = 0; c < 8; c++) {
                  if (clone[r][c] == team) {
                    var child = LinkingValue(r, c, 0);
                    next_root.next['$r,$c'] = child;
                    makeMove(clone, r, c, team);

                    if((clone[0][0] == 0 && ((r==0 && c==1) || (r==1 && c==1) || (r==1 && c==0))) ||
                        (clone[0][7] == 0 && ((r==0 && c==6) || (r==1 && c==6) || (r==1 && c==7))) ||
                            (clone[7][0] == 0 && ((r==7 && c==1) || (r==6 && c==0) || (r==6 && c==1))) ||
                                (clone[7][7] == 0 && ((r==7 && c==6) || (r==6 && c==7) || (r==6 && c==6))
                                )) {
                        if(r==0) {
                          bool sameColor = true;
                          for(int k=0;k<8;k++) {
                            if(clone[r][k] == yourColor) {
                              sameColor = false;
                              break;
                            }
                          }
                          if(sameColor) {
                            next_root.score += 100;
                            child.score += 100;
                            continue;
                          }
                        }
                        if(r==7) {
                          bool same_color = true;
                          for(int k=0;k<8;k++) {
                            if(clone[r][k] == yourColor) {
                              same_color = false;
                              break;
                            }
                          }
                          if(same_color) {
                            next_root.score += 100;
                            child.score += 100;
                            continue;
                          }
                        }
                        if(j==0) {
                          bool same_color = true;
                          for(int k=0;k<8;k++) {
                            if(clone[k][j] == yourColor) {
                              same_color = false;
                              break;
                            }
                          }
                          if(same_color) {
                            next_root.score += 100;
                            child.score += 100;
                            continue;
                          }
                        }
                        if(j==7) {
                          bool same_color = true;
                          for(int k=0;k<8;k++) {
                            if(clone[k][j] == yourColor) {
                              same_color = false;
                              break;
                            }
                          }
                          if(same_color) {
                            next_root.score += 100;
                            child.score += 100;
                            continue;
                          }
                        }
                        next_root.score -= 100;
                        child.score += -100;

                      }


                    if(team == enemyColor){
                      next_root.score += scoreBoardArray[r][c];
                      child.score += scoreBoardArray[r][c];
                    } else {
                      next_root.score -= scoreBoardArray[r][c];
                      child.score -= scoreBoardArray[r][c];
                    }
                  }
                }
              }
              if(team == enemyColor){
                team = yourColor;
              } else {
                team = enemyColor;
              }
            }

            for (int i = 0; i < 8; i++) {
              for (int j = 0; j < 8; j++) {
                clone[i][j] = boardArray[i][j];
              }
            }

          }
        }
      }

      bool canMove = false;

      for(LinkingValue v in root.next.values){
        if(v.score >= root.score) {
          root.score = v.score;
          root.x = v.x;
          root.y = v.y;
        }

        canMove = true;
      }

      if(!canMove) {

        setState(() {});
        return;
      }
      _move(root.x, root.y);

    });
  }

  @override
  void initState() {
    // prepare boardArray
    super.initState();
    boardArray[3][3] = 1;
    boardArray[3][4] = 2;
    boardArray[4][3] = 2;
    boardArray[4][4] = 1;

  /*  for(int i=0;i<8;++i) {
      for(int j=0;j<8;++j) {
        boardArray[i][j] = 1;
      }
    }
    boardArray[0][7] = 0;
    boardArray[0][6] = 0;
    boardArray[1][6] = 0;
    boardArray[1][7] = 0;
    boardArray[0][7] = 0;
    boardArray[0][5] = 2;
    boardArray[1][5] = 2;
    boardArray[2][7] = 2;*/
  }

  Map<String, dynamic> checkGame() {
    int black = 0;
    int white = 0;
    var b = legal_moves(1, boardArray);
    var w = legal_moves(2, boardArray);
    int canPlaceB=0, canPlaceW=0;
    for (int i = 0; i < 8; ++i) {
      for (int j = 0; j < 8; j++) {
        if(boardArray[i][j] == 1) {
          black++;
        } else if(boardArray[i][j] == 2){
          white++;
        }
        if (b[i][j] == 1) {
          canPlaceB++;
        }
        if (w[i][j] == 2) {
          canPlaceW++;
        }
      }
    }

    bool isEnd = (canPlaceB == 0 && canPlaceW == 0 && yourColor != -1 || black == 0 || white == 0);
    return {
      "Black": black,
      "White": white,
      "isEnd": isEnd
    };
  }

  @override
  Widget build(BuildContext context) {


    Map<String, dynamic> check = checkGame();

    if (check['isEnd']) {
      AudioCache audioPlayer = AudioCache();

      var result = audioPlayer.play(
          'sounds/endgame.wav',

          volume: 0.5);
      result.then((value) {
        showEndDialog(context);
      });
    }
    var inmove_legal = legal_moves(whoTurn, boardArray);
    int canPlace = 0;
    for (int i = 0; i < 8; ++i) {
      for (int j = 0; j < 8; j++) {
        if (inmove_legal[i][j] == whoTurn) {
          canPlace++;
        }
      }
    }
    if (canPlace == 0 && !check['isEnd']) {
      switchTurn('can place == 0');

    }
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text('Back'),
        ),
        body: Container(
            color: Colors.green.withBlue(250),
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (yourColor != -1)
                      Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Column(
                            children: [
                              IconButton(
                                icon: (whoTurn == 2 ? whiteImage : blackImage),
                                iconSize: 30,
                                onPressed: () {},
                              ),
                              Text(
                                whoTurn == 1 ? "Black Turn" : "White Turn",
                                style: TextStyle(
                                    color: (whoTurn == 1
                                        ? Colors.black
                                        : Colors.white),
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                    if (yourColor != -1)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'You   ${getScoreColor(yourColor)} ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 30),
                            ),
                            IconButton(
                              icon: yourColor == 1 ? blackImage : whiteImage,
                              iconSize: 10,
                              onPressed: () {},
                            ),
                            Text(
                              '  VS ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 30),
                            ),
                            IconButton(
                              icon: enemyColor == 1 ? blackImage : whiteImage,
                              iconSize: 10,
                              onPressed: null,
                            ),
                            Text(
                              ' ${getScoreColor(enemyColor)}   Bot',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 30),
                            ),
                          ],
                        ),
                      ),
                    if (yourColor == -1)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Choose your color:',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            IconButton(
                              icon: blackImage,
                              iconSize: 50,
                              onPressed: () {
                                AudioCache audioPlayer = AudioCache();

                                var result = audioPlayer.play(
                                    'sounds/switch.wav',

                                    volume: 0.5);
                                result.then((value) {
                                  yourColor = 1;
                                  enemyColor = 2;
                                  whoTurn = 1;
                                  setState(() {});
                                });
                              },
                            ),
                            IconButton(
                              icon: whiteImage,
                              iconSize: 50,
                              onPressed: () {
                                AudioCache audioPlayer = AudioCache();

                                var result = audioPlayer.play(
                                    'sounds/switch.wav',

                                    volume: 0.5);
                                result.then((value) {
                                  yourColor = 2;
                                  enemyColor = 1;
                                  whoTurn = 1;
                                  botPlay();
                                  setState(() {});
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    Container(
                      padding: const EdgeInsets.all(0.0),

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          for (var i = 0; i < 8; i++) buildRow(i)
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            )));
  }

  void restart() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => BoardGame()),
    );
  }
  void home() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Home()),
    );
  }


  Row buildRow(int i) {
    var inmove_legal = legal_moves(yourColor, boardArray);
    var check = checkGame();
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      for (var j = 0; j < 8; j++)
        Container(
            child: IconButton(
              icon: (whoTurn == yourColor
                  ? (inmove_legal[i][j] == yourColor)
                      ? canPlaceImage
                      : (boardArray[i][j] == 0
                          ? transparentImage
                          : (boardArray[i][j] == 2 ? whiteImage : blackImage))
                  : (boardArray[i][j] == 0
                      ? transparentImage
                      : (boardArray[i][j] == 2 ? whiteImage : blackImage))),
              iconSize: 50,
              onPressed: (check['isEnd']
                  ? null
                  : (whoTurn == yourColor
                      ? (inmove_legal[i][j] != yourColor)
                          ? null
                          : () {
                 //   print(MediaQuery.of(context).size.height);
                  //  print(MediaQuery.of(context).size.width);
                  //  print((MediaQuery.of(context).size.height<=MediaQuery.of(context).size.width?(MediaQuery.of(context).size.height/9.5)-30:(MediaQuery.of(context).size.width/9.5)-30),

                              if (yourColor == -1) {
                                return;
                              }
                              if (boardArray[i][j] != 0) {
                                return;
                              }

                              _move(i, j);
                              setState(() {});
                            }
                      : null)),
            ),

            width: (MediaQuery.of(context).size.height<=MediaQuery.of(context).size.width?(MediaQuery.of(context).size.height/8)-30:(MediaQuery.of(context).size.width/8)-30),
            height: (MediaQuery.of(context).size.height<=MediaQuery.of(context).size.width?(MediaQuery.of(context).size.height/8)-30:(MediaQuery.of(context).size.width/8)-30),

            decoration: BoxDecoration(

              color: const Color(0xff7c94b6),
              border: Border.all(
                color: Colors.black,
                width: 1,
              ),
            )),
    ]);
  }

  showEndDialog(BuildContext context) {
    if(isShowEnd) {
      return;
    }
    Map<String, dynamic> check = checkGame();

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.transparent,

      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Container(

            child: IconButton(

              icon: (check['Black'] > check['White']
                  ? blackImage
                  : (check['Black'] == check['White'] ? drawImage : whiteImage)),
              iconSize: 50,
              onPressed: () {},
            ),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  (check['Black'] > check['White']
                      ? '${yourColor==1?'You':'Bot'} Won'
                      : (check['Black'] == check['White']
                      ? 'Draw Game'
                      : '${yourColor==2?'You':'Bot'} Won')),
                  style: TextStyle(
                      color: (check['Black'] > check['White']
                          ? Colors.white
                          : (check['Black'] == check['White']
                          ? Colors.red
                          : Colors.white)),
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
              ]),
          Text('${check[yourColor==1?'Black':'White']} : ${check[enemyColor==1?'Black':'White']}',
            style: TextStyle(
                color: (check['Black'] > check['White']
                    ? Colors.white
                    : (check['Black'] == check['White']
                    ? Colors.red
                    : Colors.white)),
                fontSize: 40,
                fontWeight: FontWeight.bold),
          ),
          Container(
            margin: EdgeInsets.only(top: 30),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [


                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue.shade500,
                            side: BorderSide(
                              width: 2.0,
                              color: Colors.blue,
                            ),
                            padding: EdgeInsets.all(16),
                          ),
                          onPressed: restart,
                          child: Text(
                            'Play again!',
                            style: TextStyle(fontSize: 26, color: Colors.white),
                          ),
                        ),
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.all(0),
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue.shade500,
                            side: BorderSide(
                              width: 2.0,
                              color: Colors.blue,
                            ),
                            padding: EdgeInsets.all(16),
                          ),
                          onPressed: home,
                          child: Text(
                            'Home',
                            style: TextStyle(fontSize: 26, color: Colors.white),
                          ),
                        ),
                      ),
                    ),

                  ],
                )
              ],
            ),
          ),
        ],
      ),


      actions: [],
    );
    isShowEnd = true;
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
