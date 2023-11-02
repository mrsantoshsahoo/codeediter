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
}