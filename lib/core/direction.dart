enum Direction {
  horizontal(0, 1),
  vertical(1, 0),
  diagonalDown(1, 1),
  diagonalUp(-1, 1),
  horizontalReverse(0, -1),
  verticalReverse(-1, 0),
  diagonalDownReverse(-1, -1),
  diagonalUpReverse(1, -1);

  final int dr;
  final int dc;

  const Direction(this.dr, this.dc);
}
