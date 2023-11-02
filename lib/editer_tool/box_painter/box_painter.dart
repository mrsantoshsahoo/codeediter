import 'package:flutter/material.dart';

import '../models/box_properties.dart';
import '../models/line_properties.dart';

class BoxWithCornersPainter extends BoxPainter {
  final BoxProperties box;
  final LineProperties lineProperties;
  final double cornerRadius;
  final Color borderColor;
  final Color cornerColor;
  final bool isDragging;
  final bool isResizing;
  final bool isSelected;

  BoxWithCornersPainter({
    required this.box,
    required this.isDragging,
    required this.isSelected,
    required this.isResizing,
    required this.lineProperties,
    required this.cornerRadius,
    required this.borderColor,
    required this.cornerColor,
  });

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final size = configuration.size!;
    final left = offset.dx;
    final top = offset.dy;
    final right = left + size.width;
    final bottom = top + size.height;
    final lineLeft = lineProperties.left;
    final lineRight = lineProperties.right;
    final lineTop = lineProperties.top;
    final lineButton = lineProperties.button;

    final fillPaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0;
    final borderPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final cornerPaint = Paint()..color = cornerColor;

    // Draw the container's border
    final rect = Rect.fromLTRB(left, top, right, bottom);
    canvas.drawRect(rect, fillPaint);
    List<double> cornerRadii = [100, 100, 100, 100];
    // Draw the container's border
    // Create a custom path for the main box with rounded corners
    // final path = Path()
    //   ..addRRect(
    //     RRect.fromRectAndCorners(
    //       Rect.fromLTWH(left, top, size.width, size.height),
    //       topLeft: Radius.circular(cornerRadii[0]), // Top-left corner radius
    //       topRight: Radius.circular(cornerRadii[1]), // Top-right corner radius
    //       bottomLeft: Radius.circular(cornerRadii[2]), // Bottom-left corner radius
    //       bottomRight: Radius.circular(cornerRadii[3]), // Bottom-right corner radius
    //     ),
    //   );
    // canvas.drawPath(path, fillPaint);
    // Draw small rectangular handles in the corners
    final handlePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Draw the top-left corner handle
    // ... (code for other corner handles)

    // Draw the 1x1 circle in the center of the box
    final centerX = (left + right) / 2;
    final centerY = (top + bottom) / 2;
    final circleRadius = 1.0; // Radius of the circle

    if (isDragging) {
      // isCenterX
      // if (lineProperties.isCenterX) {
      //   canvas.drawLine(
      //     Offset(lineLeft, lineTop),
      //     Offset(lineRight, lineTop),
      //     Paint()
      //       ..color = Colors.red // Top border color
      //       ..style = PaintingStyle.stroke
      //       ..strokeWidth = 1.0,
      //   );
      // }
      // isCenterY
      // if (lineProperties.isCenterY) {
      //   canvas.drawLine(
      //     Offset(centerX, centerY),
      //     Offset(right, centerY),
      //     Paint()
      //       ..color = Colors.red // Top border color
      //       ..style = PaintingStyle.stroke
      //       ..strokeWidth = 1.0,
      //   );
      // }
      // top line
      if (lineProperties.isTop) {
        canvas.drawLine(
          Offset(lineLeft, lineTop),
          Offset(lineRight, lineTop),
          Paint()
            ..color = Colors.red // Top border color
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5,
        );
      }

      // button line
      if (lineProperties.isButton) {
        canvas.drawLine(
          Offset(lineLeft, lineButton),
          Offset(lineRight, lineButton),
          Paint()
            ..color = Colors.red // Bottom border color
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5,
        );
      }

      // Draw the left border
      if (lineProperties.isLeft) {
        canvas.drawLine(
          Offset(lineLeft, lineTop),
          Offset(lineLeft, lineButton),
          Paint()
            ..color = Colors.red // Left border color
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5,
        );
      }

      if (lineProperties.isRight) {
        // Draw the right border
        canvas.drawLine(
          Offset(lineRight, lineTop),
          Offset(lineRight, lineButton),
          Paint()
            ..color = Colors.red // Right border color
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5,
        );
      }
    }
    // final handlePaints = Paint()
    //   ..color = Colors.red
    //   ..style = PaintingStyle.fill;
    // canvas.drawCircle(
    //   Offset(centerX, centerY),
    //   circleRadius,
    //   handlePaints,
    // );
    // canvas.drawLine(
    //   Offset(centerX, top),
    //   Offset(centerX, centerY),
    //   Paint()
    //     ..color = Colors.red // Center to top border color
    //     ..style = PaintingStyle.stroke
    //     ..strokeWidth = 1.0,
    // );

    // // Draw the center border (center to right)
    // canvas.drawLine(
    //   Offset(centerX, centerY),
    //   Offset(right, centerY),
    //   Paint()
    //     ..color = Colors.green // Center to right border color
    //     ..style = PaintingStyle.stroke
    //     ..strokeWidth = 1.0,
    // );
    //
    // // Draw the center border (center to bottom)
    // canvas.drawLine(
    //   Offset(centerX, centerY),
    //   Offset(centerX, bottom),
    //   Paint()
    //     ..color = Colors.blue // Center to bottom border color
    //     ..style = PaintingStyle.stroke
    //     ..strokeWidth = 1.0,
    // );
    //
    // // Draw the center border (center to left)
    // canvas.drawLine(
    //   Offset(centerX, centerY),
    //   Offset(left, centerY),
    //   Paint()
    //     ..color = Colors.orange // Center to left border color
    //     ..style = PaintingStyle.stroke
    //     ..strokeWidth = 1.0,
    // );

    // Draw circles at each corner
    if (!isDragging) {
      if (box.isHover) {
        canvas.drawRect(rect, borderPaint);
      }
      if (isSelected) {
        canvas.drawRect(rect, borderPaint);

        // Draw small rectangular handles in the corners
        final handlePaint = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;
        final handlePaintBorder = Paint()
          ..color = Colors.blue
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;

        const cornerHandleSize = 4.0;

        // Draw the top-left corner handle
        canvas.drawRect(
          Rect.fromPoints(
            Offset(left - cornerHandleSize, top - cornerHandleSize),
            Offset(left + cornerHandleSize, top + cornerHandleSize),
          ),
          handlePaint,
        );
        canvas.drawRect(
          Rect.fromPoints(
            Offset(left - cornerHandleSize, top - cornerHandleSize),
            Offset(left + cornerHandleSize, top + cornerHandleSize),
          ),
          handlePaintBorder,
        );

        // Draw the top-right corner handle
        canvas.drawRect(
          Rect.fromPoints(
            Offset(right - cornerHandleSize, top - cornerHandleSize),
            Offset(right + cornerHandleSize, top + cornerHandleSize),
          ),
          handlePaint,
        );
        canvas.drawRect(
          Rect.fromPoints(
            Offset(right - cornerHandleSize, top - cornerHandleSize),
            Offset(right + cornerHandleSize, top + cornerHandleSize),
          ),
          handlePaintBorder,
        );

        // Draw the bottom-left corner handle
        canvas.drawRect(
          Rect.fromPoints(
            Offset(left - cornerHandleSize, bottom - cornerHandleSize),
            Offset(left + cornerHandleSize, bottom + cornerHandleSize),
          ),
          handlePaint,
        );
        canvas.drawRect(
          Rect.fromPoints(
            Offset(left - cornerHandleSize, bottom - cornerHandleSize),
            Offset(left + cornerHandleSize, bottom + cornerHandleSize),
          ),
          handlePaintBorder,
        );

        // Draw the bottom-right corner handle
        canvas.drawRect(
          Rect.fromPoints(
            Offset(right - cornerHandleSize, bottom - cornerHandleSize),
            Offset(right + cornerHandleSize, bottom + cornerHandleSize),
          ),
          handlePaint,
        );
        canvas.drawRect(
          Rect.fromPoints(
            Offset(right - cornerHandleSize, bottom - cornerHandleSize),
            Offset(right + cornerHandleSize, bottom + cornerHandleSize),
          ),
          handlePaintBorder,
        );
      }
    }
  }
}

class BoxWithCornersDecoration extends Decoration {
  final BoxProperties box;
  final LineProperties lineProperties;
  final double cornerRadius;
  final Color borderColor;
  final Color cornerColor;
  final bool isDragging;
  final bool isResizing;
  final bool isSelected;

  const BoxWithCornersDecoration({
    required this.box,
    required this.lineProperties,
    this.isDragging = false,
    this.isSelected = false,
    this.isResizing = false,
    this.cornerRadius = 4.0,
    this.borderColor = Colors.black,
    this.cornerColor = Colors.red,
  });

  @override
  BoxWithCornersPainter createBoxPainter([VoidCallback? onChanged]) {
    return BoxWithCornersPainter(
        box: box,
        isDragging: isDragging,
        isSelected: isSelected,
        isResizing: isResizing,
        lineProperties: lineProperties,
        cornerRadius: cornerRadius,
        borderColor: borderColor,
        cornerColor: cornerColor);
  }
}
