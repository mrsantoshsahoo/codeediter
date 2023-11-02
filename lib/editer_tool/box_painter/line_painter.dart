import 'package:flutter/material.dart';

import '../../utils/enum.dart';
import '../models/box_properties.dart';

// class LineBoxDecoration extends Decoration {
//   final BoxProperties box;
//   final BorderDrag? borderDrag;
//
//   LineBoxDecoration({required this.box, this.borderDrag});
//
//   @override
//   BoxPainter createBoxPainter([VoidCallback? onChanged]) {
//     return LineBoxPainter(box, borderDrag);
//   }
// }

class CustomBorderPainter extends CustomPainter {
  final BoxProperties box;
  final BorderDrag? borderDrag;

  CustomBorderPainter(this.box, this.borderDrag);

  @override
  void paint(Canvas canvas, Size size) {
    final left = 0.0;
    final top = 0.0;
    final right = box.width;

    final handlePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final handlePaintBorder = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    const cornerHandleSize = 4.0;

    // Draw the top-left corner handle
    if (BorderDrag.leftTop == borderDrag) {
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
    );}
    if (BorderDrag.rightTop == borderDrag) {
    canvas.drawRect(
      Rect.fromPoints(
        Offset(right - cornerHandleSize, top - cornerHandleSize),
        Offset(right +cornerHandleSize, top + cornerHandleSize),
      ),
      handlePaint,
    );
    canvas.drawRect(
      Rect.fromPoints(
        Offset(right - cornerHandleSize, top - cornerHandleSize),
        Offset(right +cornerHandleSize, top + cornerHandleSize),
      ),
      handlePaintBorder,
    );}

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
// class LineBoxPainter extends BoxPainter {
//   final BoxProperties box;
//   final BorderDrag? borderDrag;
//
//   LineBoxPainter(this.box, this.borderDrag);
//
//   @override
//   void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
//     final size = configuration.size!;
//     final left = offset.dx;
//     final top = offset.dy;
//     final right = left + size.width;
//     final bottom = top + size.height;
//
//
//     final handlePaint = Paint()
//       ..color = Colors.white
//       ..style = PaintingStyle.fill;
//     final handlePaintBorder = Paint()
//       ..color = Colors.blue
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 1.5;
//     // Define the corner size
//     const cornerHandleSize = 4.0;
//
//     // Draw the container's border
//     final rect = Rect.fromLTRB(left, top, right, bottom);
//     // Draw the top-left corner handle
//     if (BorderDrag.leftTop == borderDrag) {
//       canvas.drawRect(
//         Rect.fromPoints(
//           Offset(left - cornerHandleSize, top - cornerHandleSize),
//           Offset(left + cornerHandleSize, top + cornerHandleSize),
//         ),
//         handlePaint,
//       );
//       canvas.drawRect(
//         Rect.fromPoints(
//           Offset(left - cornerHandleSize, top - cornerHandleSize),
//           Offset(left + cornerHandleSize, top + cornerHandleSize),
//         ),
//         handlePaintBorder,
//       );
//     }
//     else if (BorderDrag.rightTop == borderDrag) {
//       // Draw the top-right corner handle
//       canvas.drawRect(
//         Rect.fromPoints(
//           Offset(right - cornerHandleSize, top - cornerHandleSize),
//           Offset(right + cornerHandleSize, top + cornerHandleSize),
//         ),
//         handlePaint,
//       );
//       canvas.drawRect(
//         Rect.fromPoints(
//           Offset(right - cornerHandleSize, top - cornerHandleSize),
//           Offset(right + cornerHandleSize, top + cornerHandleSize),
//         ),
//         handlePaintBorder,
//       );
//     } else if (BorderDrag.leftBottom == borderDrag) {
//       // Draw the bottom-left corner handle
//       canvas.drawRect(
//         Rect.fromPoints(
//           Offset(left - cornerHandleSize, bottom - cornerHandleSize),
//           Offset(left + cornerHandleSize, bottom + cornerHandleSize),
//         ),
//         handlePaint,
//       );
//       canvas.drawRect(
//         Rect.fromPoints(
//           Offset(left - cornerHandleSize, bottom - cornerHandleSize),
//           Offset(left + cornerHandleSize, bottom + cornerHandleSize),
//         ),
//         handlePaintBorder,
//       );
//     } else if (BorderDrag.rightBottom == borderDrag) {
//       // Draw the bottom-right corner handle
//       canvas.drawRect(
//         Rect.fromPoints(
//           Offset(right - cornerHandleSize, bottom - cornerHandleSize),
//           Offset(right + cornerHandleSize, bottom + cornerHandleSize),
//         ),
//         handlePaint,
//       );
//       canvas.drawRect(
//         Rect.fromPoints(
//           Offset(right - cornerHandleSize, bottom - cornerHandleSize),
//           Offset(right + cornerHandleSize, bottom + cornerHandleSize),
//         ),
//         handlePaintBorder,
//       );
//     } else if (BorderDrag.top == borderDrag) {
//       canvas.drawLine(
//         Offset(box.lineProperties.left, box.lineProperties.top),
//         Offset(box.lineProperties.right, box.lineProperties.top),
//         Paint()
//           ..color = Colors.transparent // Top border color
//           ..style = PaintingStyle.stroke
//           ..strokeWidth = 2.0,
//       );
//     } else if (BorderDrag.left == borderDrag) {
//       canvas.drawLine(
//         Offset(box.lineProperties.left, box.lineProperties.top),
//         Offset(box.lineProperties.left, box.lineProperties.button),
//         Paint()
//           ..color = Colors.transparent
//           ..style = PaintingStyle.stroke
//           ..strokeWidth = 2.0,
//       );
//     }
//
//     // canvas.drawRect(rect, borderPaint);
//   }
// }

// class LineBoxPainter extends BoxPainter {
//   final BoxProperties box;
//   final BorderDrag? borderDrag;
//
//   LineBoxPainter(this.box, this.borderDrag);
//
//   @override
//   void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
//     final size = configuration.size!;
//     final left = offset.dx;
//     final top = offset.dy;
//     final right = left + size.width;
//     final bottom = top + size.height;
//     const cornerRadius = 5.0;
//
//     final borderPaint = Paint()
//       ..color = Colors.red
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 10.0;
//
//     // Draw the container's border
//     // final rect = Rect.fromLTRB(left, top, right, bottom);
//     if (BorderDrag.top == borderDrag) {
//       canvas.drawLine(
//         Offset(box.lineProperties.left, box.lineProperties.top),
//         Offset(box.lineProperties.right, box.lineProperties.top),
//         Paint()
//           ..color = Colors.transparent // Top border color
//           ..style = PaintingStyle.stroke
//           ..strokeWidth = 2.0,
//       );
//     } else if (BorderDrag.left == borderDrag) {
//       canvas.drawLine(
//         Offset(box.lineProperties.left, box.lineProperties.top),
//         Offset(box.lineProperties.left, box.lineProperties.button),
//         Paint()
//           ..color = Colors.transparent
//           ..style = PaintingStyle.stroke
//           ..strokeWidth = 2.0,
//       );
//     }
//
//     // canvas.drawRect(rect, borderPaint);
//   }
// }
