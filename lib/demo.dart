import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/services/mouse_cursor.dart';

import 'design_tool/box_resizer/src/enums.dart';
import 'design_tool/design_dashboard_screen.dart';
import 'design_tool/design_tool_main_screen.dart';
import 'design_tool/flutter_box_resizer/src/handles.dart';
import 'design_tool/flutter_box_resizer/src/transformable_box.dart';
import 'design_tool/resources/images.dart';
import 'package:flutter/rendering.dart';

import 'new prod/new_resizer.dart';

class MyRectangularBoxs extends StatefulWidget {
  @override
  _MyRectangularBoxState createState() => _MyRectangularBoxState();
}

class _MyRectangularBoxState extends State<MyRectangularBoxs> {
  List<BoxData> boxes = [];
  BoxProperties? currentBox;
  Offset? startDragOffset;
  BoxProperties? tempBox;
  bool isCreateBox = false;
  Offset position = Offset(0, 0);
  bool isDragging = true;
  List<Rect> containers = [];
  Rect? currentContainer;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return  GestureDetector(
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

            boxes.add(BoxData(
              name: 'Box 2',
              imageAsset: Images.image1,
              rect: currentContainer!,
              flip: Flip.none,
              rotateValue: 0.5,
              constraintsEnabled: true,
            ));
            // containers.add(currentContainer!);
            currentContainer = null;
          }
        });
      },
      child: Stack(
        children: [
          Container(height: double.infinity,width: double.infinity,color: Colors.white10,),

          if (boxes.isNotEmpty)
            CustomPaint(
              size: const Size(1500, 1500), // Adjust the size as needed
              painter: BoxConnectionPainter(boxes, boxes[0]),
            ),
          for (var box in boxes)
            TransformableBox(
              rect: box.rect,
              flip: box.flip,
              onTap: () {},
              onDragUpdate: (v, c) {
                // print(v.rect);
                box.rect = v.rect;
                setState(() {});
              },
              onResizeUpdate: (d, c) {
                box.rect = d.rect;
                setState(() {});
              },
              onDragEnd: (d) {
                setState(() {});
              },
              cornerHandleBuilder: (context, handle) => AngularHandle(
                handle: handle,
                color: Colors.blue,
                hasShadow: false,
              ),
              cornerHandleBuilders: (context, handle) => AngularHandle(
                handle: handle,
                color: Colors.red,
                hasShadow: false,
              ),
              sideHandleBuilder: (context, handle) => AngularHandle(
                handle: handle,
                color: Colors.red,
                hasShadow: false,
              ),
              contentBuilder: (context, rect, flip) => Stack(
                alignment: Alignment.center,
                children: [

                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      setState(() {});
                    },
                    child:
                    // CustomPaint(
                    //   painter: RectangularPainter(
                    //       height: rect.height,
                    //       width: rect.width,
                    //       bottomLeftRadius: 0,
                    //       bottomRightRadius: 0,
                    //       topLeftRadius: 0,
                    //       topRightRadius: 0,
                    //       // rotation: 0.0,
                    //       // numVertices: 3,
                    //       // rotationAngle: 15,
                    //       color: Colors.white24),
                    // ),
                    Container(
                      width: rect.width,
                      height: rect.height,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          TransformableBox(
            rect:currentContainer,
            flip: Flip.none,
            onTap: () {},
            onDragUpdate: (v, c) {
              // print(v.rect);
              currentContainer = v.rect;
              setState(() {});
            },
            onResizeUpdate: (d, c) {
              currentContainer = d.rect;
              setState(() {});
            },
            onDragEnd: (d) {
              setState(() {});
            },
            cornerHandleBuilder: (context, handle) => AngularHandle(
              handle: handle,
              color: Colors.blue,
              hasShadow: false,
            ),
            cornerHandleBuilders: (context, handle) => AngularHandle(
              handle: handle,
              color: Colors.red,
              hasShadow: false,
            ),
            sideHandleBuilder: (context, handle) => AngularHandle(
              handle: handle,
              color: Colors.red,
              hasShadow: false,
            ),
            contentBuilder: (context, rect, flip) => Stack(
              alignment: Alignment.center,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    setState(() {});
                  },
                  child: CustomPaint(
                    painter: RectangularPainter(
                        height: rect.height,
                        width: rect.width,
                        bottomLeftRadius: 0,
                        bottomRightRadius: 0,
                        topLeftRadius: 0,
                        topRightRadius: 0,
                        // rotation: 0.0,
                        // numVertices: 3,
                        // rotationAngle: 15,
                        color: Colors.white24),
                  ),
                  // Container(
                  //   width: rect.width,
                  //   height: rect.height,
                  //   decoration: BoxDecoration(
                  //     color: Colors.white24,
                  //   ),
                  // ),
                ),
              ],
            ),
          ),
          // CustomPaint(
          //   size: const Size(double.infinity, double.infinity),
          //   painter: ContainerPainter(currentContainer),
          // ),
        ],
      ),
    );
    //   Scaffold(
    //   body: SizedBox(
    //     child: Stack(
    //       children: [
    //         if (boxes.isNotEmpty)
    //           CustomPaint(
    //             size: const Size(1500, 1500), // Adjust the size as needed
    //             painter: BoxConnectionPainter(boxes, boxes[0]),
    //           ),
    //         for (var box in boxes)
    //
    //           TransformableBox(
    //             rect: box.rect,
    //             flip: box.flip,
    //             onTap: () {},
    //             onDragUpdate: (v, c) {
    //               // print(v.rect);
    //               box.rect = v.rect;
    //               setState(() {});
    //             },
    //             onResizeUpdate: (d, c) {
    //               box.rect = d.rect;
    //               setState(() {});
    //             },
    //             onDragEnd: (d) {
    //               setState(() {});
    //             },
    //             cornerHandleBuilder: (context, handle) => AngularHandle(
    //               handle: handle,
    //               color: Colors.blue,
    //               hasShadow: false,
    //             ),
    //             cornerHandleBuilders: (context, handle) => AngularHandle(
    //               handle: handle,
    //               color: Colors.red,
    //               hasShadow: false,
    //             ),
    //             sideHandleBuilder: (context, handle) => AngularHandle(
    //               handle: handle,
    //               color: Colors.red,
    //               hasShadow: false,
    //             ),
    //             contentBuilder: (context, rect, flip) => Stack(
    //               alignment: Alignment.center,
    //               children: [
    //                 GestureDetector(
    //                   behavior: HitTestBehavior.translucent,
    //                   onTap: () {
    //                     setState(() {});
    //                   },
    //                   child: CustomPaint(
    //                     painter: RectangularPainter(
    //                         height: rect.height,
    //                         width: rect.width,
    //                         bottomLeftRadius: 0,
    //                         bottomRightRadius: 0,
    //                         topLeftRadius: 0,
    //                         topRightRadius: 0,
    //                         // rotation: 0.0,
    //                         // numVertices: 3,
    //                         // rotationAngle: 15,
    //                         color: Colors.white24),
    //                   ),
    //                   // Container(
    //                   //   width: rect.width,
    //                   //   height: rect.height,
    //                   //   decoration: BoxDecoration(
    //                   //     color: Colors.white24,
    //                   //   ),
    //                   // ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //       ],
    //     ),
    //   ),
    //   floatingActionButton: FloatingActionButton(
    //     onPressed: () {
    //       setState(
    //         () {
    //           boxes.add(BoxData(
    //             name: 'Box 2',
    //             imageAsset: Images.image1,
    //             rect: Rect.fromLTWH(
    //               (1000 - kInitialWidth) / 2,
    //               (1000 - kInitialHeight) / 2,
    //               150,
    //               150,
    //             ),
    //             flip: Flip.none,
    //             rotateValue: 0.5,
    //             constraintsEnabled: true,
    //           ));
    //         },
    //       );
    //     },
    //     child: Icon(Icons.add),
    //   ),
    // );
  }
}

class BoxConnectionPainter extends CustomPainter {
  List<BoxData> boxes = [];
  BoxData selectedBox;

  BoxConnectionPainter(this.boxes, this.selectedBox);

  @override
  void paint(Canvas canvas, Size size) {
    final connectedCenters = <Offset>[];

    for (int i = 0; i < boxes.length; i++) {
      for (int j = i + 1; j < boxes.length; j++) {
        Rect box1 = boxes[i].rect;
        Rect box2 = boxes[j].rect;
        // if (box1.bottom < box2.top) {
        //   Offset startPoint = Offset(box1.left + box1.width / 2, box1.bottom);
        //   Offset endPoint = Offset(box2.left + box2.width / 2, box2.top);
        //   drawLine(canvas, startPoint, endPoint);
        // }
        //
        // if (box2.bottom < box1.top) {
        //   Offset startPoint = Offset(box2.left + box2.width / 2, box2.bottom);
        //   Offset endPoint = Offset(box1.left + box1.width / 2, box1.top);
        //   drawLine(canvas, startPoint, endPoint);
        // }
        if (box1.top.toInt() == box2.top.toInt()) {
          Offset startPoint = Offset(min(box1.left, box2.left), box1.top);
          Offset endPoint = Offset(max(box1.right, box2.right), box2.top);
          Offset boxStartPoint = Offset(box1.left, box1.top);
          Offset boxEndPoint = Offset(box2.right, box2.top);
          drawLine(canvas, startPoint, endPoint, boxStartPoint, boxEndPoint,
              box1, box2);
        }
        if (box1.top.toInt() == box2.bottom.toInt()) {
          Offset startPoint = Offset(min(box1.left, box2.left), box1.top);
          Offset endPoint = Offset(max(box1.right, box2.right), box2.bottom);
          Offset boxStartPoint = Offset(box1.left, box1.top);
          Offset boxEndPoint = Offset(box2.right, box2.bottom);
          drawLine(canvas, startPoint, endPoint, boxStartPoint, boxEndPoint,
              box1, box2);
        }
        //
        if (box1.bottom.toInt() == box2.bottom.toInt()) {
          Offset startPoint = Offset(min(box1.left, box2.left), box1.bottom);
          Offset endPoint = Offset(max(box1.right, box2.right), box2.bottom);

          Offset boxStartPoint = Offset(box1.left, box1.bottom);
          Offset boxEndPoint = Offset(box2.right, box2.bottom);
          drawLine(canvas, startPoint, endPoint, boxStartPoint, boxEndPoint,
              box1, box2);
        }

        if (box1.bottom.toInt() == box2.top.toInt()) {
          Offset startPoint = Offset(min(box1.left, box2.left), box1.bottom);
          Offset endPoint = Offset(max(box1.right, box2.right), box2.top);
          Offset boxStartPoint = Offset(box1.left, box1.bottom);
          Offset boxEndPoint = Offset(box2.right, box2.top);
          drawLine(canvas, startPoint, endPoint, boxStartPoint, boxEndPoint,
              box1, box2);
        }

        if (box1.left.toInt() == box2.left.toInt()) {
          Offset startPoint = Offset(box1.left, min(box1.top, box2.top));
          Offset endPoint = Offset(box1.left, max(box1.bottom, box2.bottom));
          Offset boxStartPoint = Offset(box1.left, box1.top);
          Offset boxEndPoint = Offset(box2.left, box2.bottom);
          drawLine(canvas, startPoint, endPoint, boxStartPoint, boxEndPoint,
              box1, box2);
        }
        if (box1.left.toInt() == box2.right.toInt()) {
          Offset startPoint = Offset(box1.left, min(box1.top, box2.top));
          Offset endPoint = Offset(box1.left, max(box1.bottom, box2.bottom));
          Offset boxStartPoint = Offset(box1.left, box1.top);
          Offset boxEndPoint = Offset(box2.left, box2.bottom);
          drawLine(canvas, startPoint, endPoint, boxStartPoint, boxEndPoint,
              box1, box2);
        }

        if (box1.right.toInt() == box2.right.toInt()) {
          Offset startPoint = Offset(box1.right, min(box1.top, box2.top));
          Offset endPoint = Offset(box1.right, max(box1.bottom, box2.bottom));
          Offset boxStartPoint = Offset(box1.right, box1.top);
          Offset boxEndPoint = Offset(box2.right, box2.bottom);
          drawLine(canvas, startPoint, endPoint, boxStartPoint, boxEndPoint,
              box1, box2);
        }
        if (box1.right.toInt() == box2.left.toInt()) {
          Offset startPoint = Offset(box1.right, min(box1.top, box2.top));
          Offset endPoint = Offset(box1.right, max(box1.bottom, box2.bottom));
          Offset boxStartPoint = Offset(box1.right, box1.top);
          Offset boxEndPoint = Offset(box2.right, box2.bottom);
          drawLine(canvas, startPoint, endPoint, boxStartPoint, boxEndPoint,
              box1, box2);
        }

        Offset center1 =
            Offset(box1.left + box1.width / 2, box1.top + box1.height / 2);
        Offset center2 =
            Offset(box2.left + box2.width / 2, box2.top + box2.height / 2);

        // Check if the centers are in the same line, considering some tolerance
        if ((center1.dy - center2.dy).abs() < 1.0) {
          connectedCenters.add(center1);
          connectedCenters.add(center2);
        }
        if ((center1.dx - center2.dx).abs() < 1.0) {
          connectedCenters.add(center1);
          connectedCenters.add(center2);
        }
        if ((center1.dy - box2.top).abs() < 1.0) {
          connectedCenters.add(center1);
          connectedCenters.add(Offset(center2.dx, box2.top));
        }
        if ((center1.dy - box2.bottom).abs() < 1.0) {
          connectedCenters.add(center1);
          connectedCenters.add(Offset(center2.dx, box2.bottom));
        }
        if ((center1.dx - box2.left).abs() < 1.0) {
          connectedCenters.add(center1);
          connectedCenters.add(Offset(box2.left, center2.dy));
        }
        if ((center1.dx - box2.right).abs() < 1.0) {
          connectedCenters.add(center1);
          connectedCenters.add(Offset(box2.right, center2.dy));
        }
      }
    }
    if (connectedCenters.isNotEmpty) {
      drawLinesBetweenCenters(canvas, connectedCenters);
    }

    // Draw boxes
    final boxPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke;

    for (var box in boxes) {
      // canvas.drawRect(box.rect, boxPaint);
    }
  }

  void drawLinesBetweenCenters(Canvas canvas, List<Offset> centers) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2.0;

    for (int i = 0; i < centers.length; i += 2) {
      Offset startPoint = centers[i];
      Offset endPoint = centers[i + 1];
      canvas.drawLine(startPoint, endPoint, paint);
      final crossPaint = Paint()
        ..color = Colors.red
        ..strokeWidth = 2.0;
      double sizes_ = -4;
      double sizes = 4;
      canvas.drawLine(
        startPoint + Offset(sizes_, sizes_),
        startPoint + Offset(sizes, sizes),
        crossPaint,
      );
      canvas.drawLine(
        startPoint + Offset(sizes_, sizes),
        startPoint + Offset(sizes, sizes_),
        crossPaint,
      );

      canvas.drawLine(
        endPoint + Offset(sizes_, sizes_),
        endPoint + Offset(sizes, sizes),
        crossPaint,
      );
      canvas.drawLine(
        endPoint + Offset(sizes_, sizes),
        endPoint + Offset(sizes, sizes_),
        crossPaint,
      );
    }
  }

  void drawLine(
    Canvas canvas,
    Offset startPoint,
    Offset endPoint,
    Offset boxStartPoint,
    Offset boxEndPoint,
    Rect box1,
    Rect box2,
  ) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2.0;
    double sizes_ = -4;
    double sizes = 4;
    Size boxSize = Size(selectedBox.rect.width, selectedBox.rect.height);

    /// top to button
    //
    if (box1.top.toInt() != box2.top.toInt() &&
        box1.top.toInt() != box2.bottom.toInt() &&
        box1.bottom.toInt() != box2.bottom.toInt()) {
      canvas.drawLine(
        Offset(startPoint.dx, startPoint.dy + boxSize.height) +
            Offset(sizes_, sizes_),
        Offset(startPoint.dx, startPoint.dy + boxSize.height) +
            Offset(sizes, sizes),
        paint,
      );
      canvas.drawLine(
        Offset(startPoint.dx, startPoint.dy) + Offset(sizes_, sizes_),
        Offset(startPoint.dx, startPoint.dy) + Offset(sizes, sizes),
        paint,
      );
      //
      canvas.drawLine(
        Offset(startPoint.dx, startPoint.dy + boxSize.height) +
            Offset(sizes_, sizes),
        Offset(startPoint.dx, startPoint.dy + boxSize.height) +
            Offset(sizes, sizes_),
        paint,
      );
      canvas.drawLine(
        Offset(startPoint.dx, startPoint.dy) + Offset(sizes_, sizes),
        Offset(startPoint.dx, startPoint.dy) + Offset(sizes, sizes_),
        paint,
      );
      //
      canvas.drawLine(
        Offset(endPoint.dx, endPoint.dy - boxSize.height) +
            Offset(sizes_, sizes),
        Offset(endPoint.dx, endPoint.dy - boxSize.height) +
            Offset(sizes, sizes_),
        paint,
      );
      canvas.drawLine(
        Offset(endPoint.dx, endPoint.dy) + Offset(sizes_, sizes),
        Offset(endPoint.dx, endPoint.dy) + Offset(sizes, sizes_),
        paint,
      );
      //
      canvas.drawLine(
        Offset(endPoint.dx, endPoint.dy - boxSize.height) +
            Offset(sizes_, sizes_),
        Offset(endPoint.dx, endPoint.dy - boxSize.height) +
            Offset(sizes, sizes),
        paint,
      );
      canvas.drawLine(
        Offset(endPoint.dx, endPoint.dy) + Offset(sizes_, sizes_),
        Offset(endPoint.dx, endPoint.dy) + Offset(sizes, sizes),
        paint,
      );
    } else {
      /// other side left right
      //
      canvas.drawLine(
        Offset((boxStartPoint.dx), boxStartPoint.dy) + Offset(sizes_, sizes_),
        Offset((boxStartPoint.dx), boxStartPoint.dy) + Offset(sizes, sizes),
        paint,
      );
      canvas.drawLine(
        Offset((boxStartPoint.dx + boxSize.width), boxStartPoint.dy) +
            Offset(sizes_, sizes_),
        Offset((boxStartPoint.dx + boxSize.width), boxStartPoint.dy) +
            Offset(sizes, sizes),
        paint,
      );
      //
      canvas.drawLine(
        Offset((boxStartPoint.dx), boxStartPoint.dy) + Offset(sizes_, sizes),
        Offset((boxStartPoint.dx), boxStartPoint.dy) + Offset(sizes, sizes_),
        paint,
      );
      canvas.drawLine(
        Offset((boxStartPoint.dx + boxSize.width), boxStartPoint.dy) +
            Offset(sizes_, sizes),
        Offset((boxStartPoint.dx + boxSize.width), boxStartPoint.dy) +
            Offset(sizes, sizes_),
        paint,
      );
      //
      canvas.drawLine(
        Offset(boxEndPoint.dx, boxEndPoint.dy) + Offset(sizes_, sizes_),
        Offset(boxEndPoint.dx, boxEndPoint.dy) + Offset(sizes, sizes),
        paint,
      );
      canvas.drawLine(
        Offset(boxEndPoint.dx - boxSize.width, boxEndPoint.dy) +
            Offset(sizes_, sizes_),
        Offset(boxEndPoint.dx - boxSize.width, boxEndPoint.dy) +
            Offset(sizes, sizes),
        paint,
      );
      //
      canvas.drawLine(
        Offset(boxEndPoint.dx, boxEndPoint.dy) + Offset(sizes_, sizes),
        Offset(boxEndPoint.dx, boxEndPoint.dy) + Offset(sizes, sizes_),
        paint,
      );
      canvas.drawLine(
        Offset(boxEndPoint.dx - boxSize.width, boxEndPoint.dy) +
            Offset(sizes_, sizes),
        Offset(boxEndPoint.dx - boxSize.width, boxEndPoint.dy) +
            Offset(sizes, sizes_),
        paint,
      );
    }
    canvas.drawLine(startPoint, endPoint, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class RectangularPainter extends CustomPainter {
  final Paint _paint;
  final double width;
  final double height;
  final double topLeftRadius;
  final double topRightRadius;
  final double bottomLeftRadius;
  final double bottomRightRadius;
  final double rotation;
  final Color color;

  RectangularPainter({
    required this.width,
    required this.height,
    required this.topLeftRadius,
    required this.topRightRadius,
    required this.bottomLeftRadius,
    required this.bottomRightRadius,
    this.rotation = 0,
    this.color = Colors.blue,
  }) : _paint = Paint()
          ..color = color
          ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    final vertices = [
      Offset(centerX - width / 2, centerY - height / 2),
      Offset(centerX + width / 2, centerY - height / 2),
      Offset(centerX + width / 2, centerY + height / 2),
      Offset(centerX - width / 2, centerY + height / 2),
    ];

    final radii = BorderRadius.only(
      topLeft: Radius.circular(topLeftRadius),
      topRight: Radius.circular(topRightRadius),
      bottomLeft: Radius.circular(bottomLeftRadius),
      bottomRight: Radius.circular(bottomRightRadius),
    );

    final path = Path();
    path.addRRect(RRect.fromRectAndCorners(
      Rect.fromPoints(vertices[0], vertices[2]),
      topLeft: radii.topLeft,
      topRight: radii.topRight,
      bottomLeft: radii.bottomLeft,
      bottomRight: radii.bottomRight,
    ));

    final matrix = Matrix4.identity()..rotateZ(rotation);

    final transformedPath = path.transform(matrix.storage);
    canvas.drawPath(transformedPath, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class CirclePainter extends CustomPainter {
  final Paint _paint;
  final double width;
  final double height;

  CirclePainter(
      {required this.width, required this.height, Color color = Colors.blue})
      : _paint = Paint()
          ..color = color
          ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(centerX, centerY), width: width, height: height),
        _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class StarPainter extends CustomPainter {
  final Paint _paint;
  final double width;
  final double height;

  StarPainter({
    required this.width,
    required this.height,
    Color color = Colors.yellow,
  }) : _paint = Paint()
          ..color = color
          ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    final outerRadiusX = width / 2;
    final outerRadiusY = height / 2;

    final innerRadiusX = outerRadiusX * 0.4;
    final innerRadiusY = outerRadiusY * 0.4;

    final outerVertices = List.generate(10, (i) {
      final radiusX = i.isEven ? outerRadiusX : innerRadiusX;
      final radiusY = i.isEven ? outerRadiusY : innerRadiusY;
      final angle = i * 36 * (pi / 180);
      final x = centerX + radiusX * cos(angle);
      final y = centerY + radiusY * sin(angle);
      return Offset(x, y);
    });

    final innerVertices = List.generate(10, (i) {
      final radiusX = i.isEven ? innerRadiusX : outerRadiusX;
      final radiusY = i.isEven ? innerRadiusY : outerRadiusY;
      final angle = (i * 36 + 18) * (pi / 180);
      final x = centerX + radiusX * cos(angle);
      final y = centerY + radiusY * sin(angle);
      return Offset(x, y);
    });

    final path = Path();
    // path.addPolygon(outerVertices, true);
    path.addPolygon(innerVertices, true);

    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class StretchablePolygonPainter extends CustomPainter {
  final Paint _paint;
  final double width;
  final double height;
  final int numVertices;

  StretchablePolygonPainter({
    required this.width,
    required this.height,
    required this.numVertices,
    Color color = Colors.yellow,
  }) : _paint = Paint()
          ..color = color
          ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    final radiusX = width / 2;
    final radiusY = height / 2;

    final vertices = List.generate(numVertices, (i) {
      final angle = (i * 360 / numVertices) * (pi / 90);
      final x = centerX + radiusX * cos(angle);
      final y = centerY + radiusY * sin(angle);
      return Offset(x, y);
    });

    final path = Path();
    path.addPolygon(vertices, true);

    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

// GestureDetector(
//     onPanStart: (d) {
//       var  offset =d.localPosition;
//       double width = 0.0; // Replace with the desired width
//       double height = 0.0; // Replace with the desired height
//       Rect rect = Rect.fromLTWH(offset.dx, offset.dy, width, height);
//       setState(() {
//         boxes.add(BoxData(
//           name: 'Box 2',
//           imageAsset: Images.image1,
//           rect: rect,
//           flip: Flip.none,
//           constraintsEnabled: true,
//         ));
//       });
//     },
//     child: Container(
//       height: size.height,
//       width: size.width,
//       color: Colors.green,
//     )),
