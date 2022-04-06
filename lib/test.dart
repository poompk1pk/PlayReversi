final boardArray = List.generate(8 + 1, (i) => List.filled(8 + 1,  0,growable: false), growable: false);

void main() {
  int i = 0;
  int j=0;
  print('${boardArray[i][j]}');
}