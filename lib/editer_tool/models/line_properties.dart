class LineProperties {
  double top;
  double left;
  double button;
  double right;
  double centerX;
  double centerY;
  bool isTop;
  bool isLeft;
  bool isButton;
  bool isRight;
  bool isCenterX;
  bool isCenterY;

  LineProperties({
    required this.top,
    required this.left,
    required this.button,
    required this.right,
    required this.centerX,
    required this.centerY,
    this.isTop = false,
    this.isButton = false,
    this.isLeft = false,
    this.isRight = false,
    this.isCenterX = false,
    this.isCenterY = false,
  });

  @override
  String toString() {
    return 'LineProperties{top: $top, left: $left, button: $button, right: $right, centerX: $centerX, centerY: $centerY, isTop: $isTop, isLeft: $isLeft, isButton: $isButton, isRight: $isRight, isCenterX: $isCenterX, isCenterY: $isCenterY}';
  }
}
