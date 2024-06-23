import 'dart:math';

import 'package:flutter/material.dart';
import '../demo.dart';
import '../design_tool/box_resizer/src/enums.dart';
import '../design_tool/design_dashboard_screen.dart';
import '../design_tool/flutter_box_resizer/src/handle_builders.dart';
import '../design_tool/flutter_box_resizer/src/handles.dart';
import '../design_tool/flutter_box_resizer/src/transformable_box.dart';
import '../design_tool/resources/images.dart';
import '../utils/enum.dart';
import 'drag_screen/drag_main_screen.dart';
import 'models/box_properties.dart';
import 'models/line_properties.dart';

class MyRectangularBox extends StatefulWidget {
  @override
  _MyRectangularBoxState createState() => _MyRectangularBoxState();
}

class _MyRectangularBoxState extends State<MyRectangularBox> {
  List<BoxProperties> boxes = [];
  List<LineProperties> linerList = [];
  bool draging = true;

  @override
  void initState() {
    super.initState();
    // Add some initial boxes
    double dx = 10;
    double dy = 10;
    double h = 200;
    double w = 200;
    double left = dx;
    double right = dx + w;
    double top = dy;
    double button = dy + h;
    double centerX = (left + right) / 2;
    double centerY = (top + button) / 2;
    var lineProperties = LineProperties(
      centerX: centerX,
      centerY: centerY,
      left: left,
      top: top,
      button: button,
      right: right,
    );
    boxes.add(BoxProperties(w, h, true, Offset(dx, dy), lineProperties, false));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        setState(() {
          for (var box in boxes) {
            box.isSelected = false;
          }
        });
      },
      child: Scaffold(
        body:
        Stack(
          children: [

            // if (boxes.isNotEmpty)
            //   CustomPaint(
            //     size: const Size(1500, 1500), // Adjust the size as needed
            //     painter: BoxConnectionPainter(boxes, boxes[0]),
            //   ),
            for (var box in boxes)
              DraggableBox(
                box: box,
                onTap: () {
                  setState(() {
                    for (var box in boxes) {
                      box.isSelected = false;
                    }
                    box.isSelected = true;
                  });
                },
                onDrag: (newPosition) {
                  setState(() {
                    if (draging) {
                      for (var box in boxes) {
                        box.isSelected = false;
                      }
                      box.isSelected = true;
                      box.position = newPosition;
                      double left = newPosition.dx;
                      double right = newPosition.dx + box.width;
                      double top = newPosition.dy;
                      double bottom = newPosition.dy + box.height;
                      double centerX = (left + right) / 2;
                      double centerY = (top + bottom) / 2;
                      var newLineProperties = LineProperties(
                          left: left,
                          top: top,
                          button: bottom,
                          right: right,
                          centerX: centerX,
                          centerY: centerY);
                      box.lineProperties = newLineProperties;

                      // Iterate through the boxes and update matching lines
                      for (var otherBox in boxes) {
                        if (otherBox != box) {
                          if (otherBox.lineProperties.top.toInt() ==
                              top.toInt()) {
                            box.lineProperties = LineProperties(
                                left: min(left, otherBox.lineProperties.left),
                                top: top,
                                button:
                                    max(bottom, otherBox.lineProperties.button),
                                right:
                                    max(right, otherBox.lineProperties.right),
                                centerX: centerX,
                                centerY: centerY,
                                isTop: true);
                            // Pause the dragging for 5 milliseconds
                            draging = false;
                            Future.delayed(const Duration(milliseconds: 100),
                                () {
                              draging = true;
                            });
                          }
                          if (otherBox.lineProperties.button.toInt() ==
                              bottom.toInt()) {
                            box.lineProperties = LineProperties(
                                left: min(left, otherBox.lineProperties.left),
                                top: top,
                                button: bottom,
                                right:
                                    max(right, otherBox.lineProperties.right),
                                centerX: centerX,
                                centerY: centerY,
                                isButton: true);
                            draging = false;
                            Future.delayed(const Duration(milliseconds: 100),
                                () {
                              draging = true;
                            });
                          }
                          if (otherBox.lineProperties.left.toInt() ==
                              left.toInt()) {
                            box.lineProperties = LineProperties(
                                left: left,
                                top: min(top, otherBox.lineProperties.top),
                                button:
                                    max(bottom, otherBox.lineProperties.button),
                                right: right,
                                centerX: centerX,
                                centerY: centerY,
                                isLeft: true);
                            draging = false;
                            Future.delayed(const Duration(milliseconds: 100),
                                () {
                              draging = true;
                            });
                          }
                          if (otherBox.lineProperties.right.toInt() ==
                              right.toInt()) {
                            box.lineProperties = LineProperties(
                                left: left,
                                top: min(top, otherBox.lineProperties.top),
                                button:
                                    max(bottom, otherBox.lineProperties.button),
                                right:
                                    min(right, otherBox.lineProperties.right),
                                centerX: centerX,
                                centerY: centerY,
                                isRight: true);
                            draging = false;
                            Future.delayed(const Duration(milliseconds: 100),
                                () {
                              draging = true;
                            });
                          } if (otherBox.lineProperties.centerX.toInt() ==
                              centerX.toInt()) {
                            box.lineProperties = LineProperties(
                                left: left,
                                top: min(top, otherBox.lineProperties.top),
                                button:
                                    max(bottom, otherBox.lineProperties.button),
                                right:
                                    min(right, otherBox.lineProperties.right),
                                centerX: otherBox.lineProperties.centerX,
                                centerY: otherBox.lineProperties.centerY,
                                isRight: true);
                            draging = false;
                            Future.delayed(const Duration(milliseconds: 100),
                                () {
                              draging = true;
                            });
                          }
                        }
                      }
                    }
                  });
                },
                lineProperties: box.lineProperties,
              ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Add a new box

            setState(() {
              for (var box in boxes) {
                box.isSelected = false;
              }

              double dx = 10;
              double dy = 10;
              double h = 200;
              double w = 200;
              double left = dx;
              double right = dx + w;
              double top = dy;
              double button = dy + h;
              double centerX = (left + right) / 2;
              double centerY = (top + button) / 2;
              var lineProperties = LineProperties(
                centerX: centerX,
                centerY: centerY,
                left: left,
                top: top,
                button: button,
                right: right,
              );
              boxes.add(BoxProperties(
                  w, h, true, Offset(dx, dy), lineProperties, false));
            });
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
/*final Rect rect = Rect.fromLTRB(10, 10, 10, 10);
var box=   BoxData(
  name: 'Box 1',
  imageAsset: Images.image1,
  rect: Rect.fromLTWH(
    (100 - kInitialWidth) / 2,
    (100 - kInitialHeight) / 2,
    kInitialWidth,
    kInitialHeight,
  ),
  flip: Flip.none,
  constraintsEnabled: true,
  constraints: const BoxConstraints(
    minWidth: 100,
    minHeight: 100,
    maxWidth: 500,
    maxHeight: 500,
  ),
);*/
/*     TransformableBox(
              key: ValueKey('image-box-${box.name}'),
              rect: box.rect,
              flip: box.flip,
              // clampingRect: model.clampingEnabled ? model.clampingRect : null,
              constraints: box.constraintsEnabled ? box.constraints : null,
              onChanged: (result, event) {
                // print(result.rect);
                setState(() {

                });
                // widget.onChanged?.call(result);
                // largestClampingBox = result.largestRect;
                // setState(() {});
                // lastResult = result;
                // model.onRectChanged(result);

              },
              // resizable: widget.selected && box.resizable,
              // visibleHandles:
              // !widget.selected || !box.resizable ? {} : box.visibleHandles,
              // enabledHandles:
              // !widget.selected || !box.resizable ? {} : box.enabledHandles,
              // draggable: widget.selected && box.draggable,
              allowContentFlipping: box.flipChild,
              allowFlippingWhileResizing: box.flipRectWhileResizing,
              cornerHandleBuilder: (context, handle) => AngularHandle(
                handle: handle,
                color: Colors.red,
                hasShadow: false,
              ),
              sideHandleBuilder: (context, handle) => AngularHandle(
                handle: handle,
                color: Colors.red,
                hasShadow: false,
              ),
              onResizeStart: (handle, event) {
                // if (!showTestRecorder || !recorder.isRecording) return;
                //
                // log('Recording resize action');
                // currentAction = recorder.onAction(
                //   resizeMode: currentResizeMode,
                //   flip: box.flip,
                //   rect: box.rect,
                //   handle: handle,
                //   cursorPosition: event.localPosition,
                //   clampingRect: model.clampingEnabled ? model.clampingRect : null,
                //   constraints: box.constraintsEnabled ? box.constraints : null,
                //   flipRect: box.flipRectWhileResizing,
                // );
              },
              onResizeEnd: (handle, event) {
                // if (!showTestRecorder ||
                //     currentAction == null ||
                //     !recorder.isRecording ||
                //     lastResult == null) {
                //   return;
                // }
                // log('Recording resize action result');
                // recorder.onResult(
                //   action: currentAction!,
                //   result: lastResult!,
                //   localPosition: event.localPosition,
                // );
              },
              onTerminalSizeReached: (
                  bool reachedMinWidth,
                  bool reachedMaxWidth,
                  bool reachedMinHeight,
                  bool reachedMaxHeight,
                  ) {
                // if (minWidthReached == reachedMinWidth &&
                //     minHeightReached == reachedMinHeight &&
                //     maxWidthReached == reachedMaxWidth &&
                //     maxHeightReached == reachedMaxHeight) return;
                //
                // setState(() {
                //   minWidthReached = reachedMinWidth;
                //   minHeightReached = reachedMinHeight;
                //   maxWidthReached = reachedMaxWidth;
                //   maxHeightReached = reachedMaxHeight;
                // });
              },
              contentBuilder: (context, rect, flip) => GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  // setState(() {});
                  // if (widget.selected) return;
                  // widget.onSelected();
                },
                child:
                Container(
                  key: ValueKey('image-box-${box.name}-content'),
                  width: rect.width,
                  height: rect.height,
                  decoration: BoxDecoration(
                    color: Colors.white,

                    // shape: BoxShape.circle,
                    // border: Border.all(color: Colors.red)
                    // borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),)
                    // image: DecorationImage(
                    //   image: AssetImage(box.imageAsset),
                    //   fit: BoxFit.fill,
                    // ),
                  ),
                  // child: CustomPaint(
                  //   size: Size(rect.width, rect.height),
                  //   // Set the size of the rectangle
                  //   // painter: PinkRectanglePainter(),
                  //   painter: PinkRectanglePainter(
                  //       box: BoxProperties(
                  //           height: rect.height, top: 0, left: 0, width: rect.width),
                  //       screenSize: size),
                  // ),
                  foregroundDecoration: BoxDecoration(
                    // border: widget.selected
                    //     ? Border.symmetric(
                    //   horizontal: BorderSide(
                    //     color: minHeightReached
                    //         ? Colors.orange
                    //         : maxHeightReached
                    //         ? Colors.red
                    //         : handleColor,
                    //     width: 2,
                    //     // TODO: Due to flutter issue in 3.7.10, this doesn't work in debug mode.
                    //     // strokeAlign: BorderSide.strokeAlignCenter,
                    //   ),
                    //   vertical: BorderSide(
                    //     color: minWidthReached
                    //         ? Colors.orange
                    //         : maxWidthReached
                    //         ? Colors.red
                    //         : handleColor,
                    //     width: 2,
                    //     // TODO: Due to flutter issue in 3.7.10, this doesn't work in debug mode.
                    //     // strokeAlign: BorderSide.strokeAlignCenter,
                    //   ),
                    // )
                    //     : null,
                  ),
                ),
              ),
            ),*/