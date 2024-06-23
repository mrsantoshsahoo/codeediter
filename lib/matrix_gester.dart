
import 'dart:ui';
import 'package:codeediter/utils/image_paths.dart';
import 'package:flutter/material.dart';

class RotatableContainer extends StatefulWidget {
  @override
  _RotatableContainerState createState() => _RotatableContainerState();
}

class _RotatableContainerState extends State<RotatableContainer> {
  double _rotationAngle = 0.0;
  Offset _startRotationPoint = Offset(0, 0);
  bool _isRotating = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        // Check if the drag starts from the corner
        if (_isCorner(details.localPosition)) {
          _startRotationPoint = details.localPosition;
          _isRotating = true;
        }
      },
      onPanUpdate: (details) {
        if (_isRotating) {
          // Calculate the angle of rotation based on the drag movement
          final currentRotationPoint = details.localPosition;
          final deltaX = currentRotationPoint.dx - _startRotationPoint.dx;
          final deltaY = currentRotationPoint.dy - _startRotationPoint.dy;
          final angleInRadians = -deltaX / 100;

          // Update the rotation angle
          setState(() {
            _rotationAngle += angleInRadians;
          });

          // Update the start point for the next frame
          _startRotationPoint = currentRotationPoint;
        }
      },
      onPanEnd: (_) {
        _isRotating = false;
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.rotate(
            angle: _rotationAngle,
            origin: Offset(0, 0), // Rotate around the center of the container
            child: Container(
              width: 200,
              height: 200,
              color: Colors.blue,
              child: Center(
                child: Text("Drag from corners to rotate"),
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: 40,
              height: 40,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  bool _isCorner(Offset position) {
    return position.dx <= 40 && position.dy <= 40;
  }
}

void main() {
  runApp(MaterialApp(
    scrollBehavior: MaterialScrollBehavior().copyWith(
      scrollbars: true,
      dragDevices: {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      },
    ),
    home: Scaffold(
      appBar: AppBar(
        title: Text('Rotatable Container'),
      ),
      body: Center(
        child: TransformDemo(),
      ),
    ),
  ));
}

class TransformDemo extends StatefulWidget {
  @override
  State<TransformDemo> createState() => _TransformDemoState();
}

class _TransformDemoState extends State<TransformDemo> {
  final ValueNotifier<Matrix4> notifier = ValueNotifier(Matrix4.identity());

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey,
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: MatrixGestureDetector(
          onMatrixUpdate: (m, tm, sm, rm) {
            notifier.value = m;
            print(m);
          },
          child: AnimatedBuilder(
            animation: notifier,
            builder: (ctx, child) {
              return Transform(
                transform: notifier.value,
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: 100,
                      width: 100,
                      alignment: Alignment.center,
                      color: Colors.red,
                      child: Text(
                        'Rotate',
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),

                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
