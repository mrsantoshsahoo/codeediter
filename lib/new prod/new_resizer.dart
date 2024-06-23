import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Draggable Container Creator')),
        body: DraggableContainerScreen(),
      ),
    );
  }
}

class DraggableContainerScreen extends StatefulWidget {
  @override
  _DraggableContainerScreenState createState() =>
      _DraggableContainerScreenState();
}

class _DraggableContainerScreenState extends State<DraggableContainerScreen> {
  List<Rect> containers = [];
  Rect? currentContainer;

  @override
  Widget build(BuildContext context) {
    containers.forEach((action) => print);
    return
      GestureDetector(
      onPanStart: (details) {
        setState(() {
          currentContainer =
              Rect.fromPoints(details.localPosition, details.localPosition);
        });
      },
      onPanUpdate: (details) {
        setState(() {
          if (currentContainer != null) {
            currentContainer = Rect.fromPoints(
                currentContainer!.topLeft, details.localPosition);
          }
        });
      },
      onPanEnd: (details) {
        setState(() {
          if (currentContainer != null) {
            containers.add(currentContainer!);
            currentContainer = null;
          }
        });
      },
      child: Stack(
        children: [
          for (final container in containers)
            CustomPaint(
              size: const Size(double.infinity, double.infinity),
              painter: ContainerPainter(container),
            ),
          CustomPaint(
            size: const Size(double.infinity, double.infinity),
            painter: ContainerPainter(currentContainer),
          ),
        ],
      ),
    );
  }
}

class ContainerPainter extends CustomPainter {
  final Rect? currentContainer;
  final Paint borderPaint = Paint()
    ..color = Colors.blue.withOpacity(0.5)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0; // Adjust the border thickness as needed

  final Paint innerPaint = Paint()
    ..color = Colors.blue.withOpacity(0.1) // Change the inner color here
    ..style = PaintingStyle.fill;

  ContainerPainter(this.currentContainer);

  final handlePaint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.fill;
  final handlePaintBorder = Paint()
    ..color = Colors.blue
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.5;

  @override
  void paint(Canvas canvas, Size size) {
    final left = currentContainer?.left ?? 0;
    final top = currentContainer?.top ?? 0;
    final right = currentContainer?.right ?? 0;
    final bottom = currentContainer?.bottom ?? 0;
    const cornerHandleSize = 4.0;

    if (currentContainer != null) {
      canvas.drawRect(currentContainer!, innerPaint);
      canvas.drawRect(currentContainer!, borderPaint);

      // // Draw the top-left corner handle
      // canvas.drawRect(
      //   Rect.fromPoints(
      //     Offset(left - cornerHandleSize, top - cornerHandleSize),
      //     Offset(left + cornerHandleSize, top + cornerHandleSize),
      //   ),
      //   handlePaint,
      // );
      // canvas.drawRect(
      //   Rect.fromPoints(
      //     Offset(left - cornerHandleSize, top - cornerHandleSize),
      //     Offset(left + cornerHandleSize, top + cornerHandleSize),
      //   ),
      //   handlePaintBorder,
      // );
      // // Draw the top-right corner handle
      // canvas.drawRect(
      //   Rect.fromPoints(
      //     Offset(right - cornerHandleSize, top - cornerHandleSize),
      //     Offset(right + cornerHandleSize, top + cornerHandleSize),
      //   ),
      //   handlePaint,
      // );
      // canvas.drawRect(
      //   Rect.fromPoints(
      //     Offset(right - cornerHandleSize, top - cornerHandleSize),
      //     Offset(right + cornerHandleSize, top + cornerHandleSize),
      //   ),
      //   handlePaintBorder,
      // );
      //
      // // Draw the bottom-left corner handle
      // canvas.drawRect(
      //   Rect.fromPoints(
      //     Offset(left - cornerHandleSize, bottom - cornerHandleSize),
      //     Offset(left + cornerHandleSize, bottom + cornerHandleSize),
      //   ),
      //   handlePaint,
      // );
      // canvas.drawRect(
      //   Rect.fromPoints(
      //     Offset(left - cornerHandleSize, bottom - cornerHandleSize),
      //     Offset(left + cornerHandleSize, bottom + cornerHandleSize),
      //   ),
      //   handlePaintBorder,
      // );
      //
      // // Draw the bottom-right corner handle
      // canvas.drawRect(
      //   Rect.fromPoints(
      //     Offset(right - cornerHandleSize, bottom - cornerHandleSize),
      //     Offset(right + cornerHandleSize, bottom + cornerHandleSize),
      //   ),
      //   handlePaint,
      // );
      // canvas.drawRect(
      //   Rect.fromPoints(
      //     Offset(right - cornerHandleSize, bottom - cornerHandleSize),
      //     Offset(right + cornerHandleSize, bottom + cornerHandleSize),
      //   ),
      //   handlePaintBorder,
      // );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
