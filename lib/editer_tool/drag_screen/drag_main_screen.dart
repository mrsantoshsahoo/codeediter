import 'package:flutter/material.dart';

import '../../utils/enum.dart';
import '../box_painter/box_painter.dart';
import '../box_painter/line_painter.dart';
import '../models/box_properties.dart';
import '../models/line_properties.dart';

class DraggableBox extends StatefulWidget {
  final BoxProperties box;
  final LineProperties lineProperties;
  final Function(Offset) onDrag;
  final Function() onTap;

  // final Function(Offset) onDragEnd;

  DraggableBox({
    required this.box,
    required this.onDrag,
    required this.lineProperties,
    required this.onTap,
    // required this.onDragEnd
  });

  @override
  _DraggableBoxState createState() => _DraggableBoxState();
}

class _DraggableBoxState extends State<DraggableBox> {
  bool isDragging = false;
  Offset startDragOffset = Offset(0, 0);
  BorderDrag? borderDrag; // To track which border is being dragged

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Positioned(
      left: widget.box.position.dx,
      top: widget.box.position.dy,
      child: Stack(
        children: [
      MouseRegion(
        cursor: SystemMouseCursors.resizeLeftRight,
        onEnter: (v) {
          setState(() {
            widget.box.isHover = true;
          });
        },
        onExit: (v) {
          setState(() {
            widget.box.isHover = false;
          });
        },
        child: GestureDetector(
          onTap: () {
            widget.onTap();
          },
          onPanStart: (details) {
            setState(() {
              isDragging = true;
              startDragOffset = details.localPosition - widget.box.position;
              // Determine which border is being dragged based on the touch position
              if (details.localPosition.dx < 10) {
                if (details.localPosition.dy < 10) {
                  borderDrag = BorderDrag.leftTop;
                } else if (details.localPosition.dy >
                    widget.box.height - 10) {
                  borderDrag = BorderDrag.leftBottom;
                } else {
                  borderDrag = BorderDrag.left;
                }
              } else if (details.localPosition.dx > widget.box.width - 10) {
                if (details.localPosition.dy < 10) {
                  borderDrag = BorderDrag.rightTop;
                } else if (details.localPosition.dy >
                    widget.box.height - 10) {
                  borderDrag = BorderDrag.rightBottom;
                } else {
                  borderDrag = BorderDrag.right;
                }
              } else if (details.localPosition.dy < 10) {
                borderDrag = BorderDrag.top;
              } else if (details.localPosition.dy >
                  widget.box.height - 10) {
                borderDrag = BorderDrag.bottom;
              }
            });
          },
          onPanUpdate: (details) {
            if (isDragging) {
              final newPosition = details.localPosition - startDragOffset;

              if (borderDrag == BorderDrag.leftTop) {
                widget.box.width = widget.box.width - newPosition.dx + widget.box.position.dx;
                widget.box.height = widget.box.height - newPosition.dy + widget.box.position.dy;
                widget.box.position = newPosition;
              } else if (borderDrag == BorderDrag.rightTop) {
                widget.box.width = newPosition.dx - widget.box.position.dx;
                widget.box.height = widget.box.height - newPosition.dy + widget.box.position.dy;
                widget.box.position = Offset(widget.box.position.dx, newPosition.dy);
              } else if (borderDrag == BorderDrag.leftBottom) {
                widget.box.width = widget.box.width - newPosition.dx + widget.box.position.dx;
                widget.box.height = newPosition.dy - widget.box.position.dy;
                widget.box.position = Offset(newPosition.dx, widget.box.position.dy);
              } else if (borderDrag == BorderDrag.rightBottom) {
                widget.box.width = newPosition.dx - widget.box.position.dx;
                widget.box.height = newPosition.dy - widget.box.position.dy;
              } else if (borderDrag == BorderDrag.left) {
                widget.box.width = widget.box.width - newPosition.dx + widget.box.position.dx;
                widget.box.position = newPosition;
              } else if (borderDrag == BorderDrag.right) {
                widget.box.width = newPosition.dx - widget.box.position.dx;
              } else if (borderDrag == BorderDrag.top) {
                widget.box.height = widget.box.height - newPosition.dy + widget.box.position.dy;
                widget.box.position = newPosition;
              } else if (borderDrag == BorderDrag.bottom) {
                widget.box.height = newPosition.dy - widget.box.position.dy;
              }

              widget.onDrag(newPosition);
            }
          },
          onPanEnd: (dragDetails) {
            setState(() {
              isDragging = false;
              borderDrag = null;
            });
          },
          child: Container(
            width: widget.box.width,
            height: widget.box.height,
            decoration: BoxWithCornersDecoration(
                box: widget.box,
                isDragging: isDragging,
                isSelected: widget.box.isSelected,
                lineProperties: widget.lineProperties),

          ),
        ),
      ),

          // GestureDetector(
          //   onPanStart: (details) {
          //     setState(() {
          //       isDragging = true;
          //       startDragOffset = details.localPosition - widget.box.position;
          //     });
          //   },
          //   onPanUpdate: (details) {
          //     if (isDragging) {
          //       final newPosition = details.localPosition - startDragOffset;
          //       widget.box.width =
          //           widget.box.width - newPosition.dx + widget.box.position.dx;
          //       widget.box.height =
          //           widget.box.height - newPosition.dy + widget.box.position.dy;
          //       widget.box.position = newPosition;
          //       widget.onDrag(newPosition);
          //     }
          //   },
          //   onPanEnd: (dragDetails) {
          //     setState(() {
          //       isDragging = false;
          //       borderDrag = null;
          //     });
          //   },
          //   child: MouseRegion(
          //     cursor: SystemMouseCursors.resizeColumn,
          //     child: CustomPaint(
          //       size: Size(6, 6),
          //       painter: CustomBorderPainter(widget.box, BorderDrag.leftTop),
          //     ),
          //   ),
          // ),
          // GestureDetector(
          //   onPanStart: (details) {
          //     setState(() {
          //       isDragging = true;
          //       startDragOffset = details.localPosition - widget.box.position;
          //     });
          //   },
          //   onPanUpdate: (details) {
          //     if (isDragging) {
          //       final newPosition = details.localPosition - startDragOffset;
          //       widget.box.width =
          //           widget.box.width - newPosition.dx + widget.box.position.dx;
          //       widget.box.height =
          //           widget.box.height - newPosition.dy + widget.box.position.dy;
          //       widget.box.position = newPosition;
          //       widget.onDrag(newPosition);
          //     }
          //   },
          //   onPanEnd: (dragDetails) {
          //     setState(() {
          //       isDragging = false;
          //       borderDrag = null;
          //     });
          //   },
          //   child: MouseRegion(
          //     cursor: SystemMouseCursors.resizeColumn,
          //     child: CustomPaint(
          //       size: Size(600, 600),
          //       painter: CustomBorderPainter(widget.box, BorderDrag.rightTop),
          //     ),
          //   ),
          // ),


          // MouseRegion(
          //   cursor: SystemMouseCursors.resizeColumn,
          //   child: GestureDetector(
          //     onPanStart: (details) {
          //       setState(() {
          //         isDragging = true;
          //         startDragOffset = details.localPosition - widget.box.position;
          //
          //         // Determine which border is being dragged based on the touch position
          //         if (details.localPosition.dx < 10) {
          //           borderDrag = BorderDrag.left;
          //         } else if (details.localPosition.dx > widget.box.width - 10) {
          //           borderDrag = BorderDrag.right;
          //         } else if (details.localPosition.dy < 10) {
          //           borderDrag = BorderDrag.top;
          //         } else if (details.localPosition.dy >
          //             widget.box.height - 10) {
          //           borderDrag = BorderDrag.bottom;
          //         }
          //       });
          //     },
          //     onPanUpdate: (details) {
          //       if (isDragging) {
          //         final newPosition = details.localPosition - startDragOffset;
          //
          //         // Adjust the width and height based on which border is being dragged
          //         if (borderDrag == BorderDrag.left) {
          //           widget.box.width = widget.box.width +
          //               (widget.box.position.dx - newPosition.dx);
          //           widget.box.position = newPosition;
          //         } else if (borderDrag == BorderDrag.right) {
          //           widget.box.width = newPosition.dx - widget.box.position.dx;
          //         } else if (borderDrag == BorderDrag.top) {
          //           widget.box.height = widget.box.height +
          //               (widget.box.position.dy - newPosition.dy);
          //           widget.box.position = newPosition;
          //         } else if (borderDrag == BorderDrag.bottom) {
          //           widget.box.height = newPosition.dy - widget.box.position.dy;
          //         }
          //
          //         widget.onDrag(newPosition);
          //       }
          //     },
          //     onPanEnd: (dragDetails) {
          //       setState(() {
          //         isDragging = false;
          //         borderDrag = null;
          //       });
          //       // widget.onDragEnd(newPosition);
          //     },
          //     onTap: () {
          //       print("top");
          //     },
          //     // child:CustomPaint(size: Size(widget.box.width, 3),painter: LeftLinePainter(box: widget.box),)
          //     child: Container(
          //       height: 10,
          //       width: widget.box.width,
          //       decoration: LineBoxDecoration(
          //           box: widget.box, borderDrag: BorderDrag.top),
          //     ),
          //   ),
          // ),
          // MouseRegion(
          //   cursor: SystemMouseCursors.resizeColumn,
          //   child: GestureDetector(
          //     onPanStart: (details) {
          //       setState(() {
          //         isDragging = true;
          //         startDragOffset = details.localPosition - widget.box.position;
          //
          //         // Determine which border is being dragged based on the touch position
          //         if (details.localPosition.dx < 10) {
          //           borderDrag = BorderDrag.left;
          //         } else if (details.localPosition.dx > widget.box.width - 10) {
          //           borderDrag = BorderDrag.right;
          //         } else if (details.localPosition.dy < 10) {
          //           borderDrag = BorderDrag.top;
          //         } else if (details.localPosition.dy >
          //             widget.box.height - 10) {
          //           borderDrag = BorderDrag.bottom;
          //         }
          //       });
          //     },
          //     onPanUpdate: (details) {
          //       if (isDragging) {
          //         final newPosition = details.localPosition - startDragOffset;
          //
          //         // Adjust the width and height based on which border is being dragged
          //         if (borderDrag == BorderDrag.left) {
          //           widget.box.width = widget.box.width +
          //               (widget.box.position.dx - newPosition.dx);
          //           widget.box.position = newPosition;
          //         } else if (borderDrag == BorderDrag.right) {
          //           widget.box.width = newPosition.dx - widget.box.position.dx;
          //         } else if (borderDrag == BorderDrag.top) {
          //           widget.box.height = widget.box.height +
          //               (widget.box.position.dy - newPosition.dy);
          //           widget.box.position = newPosition;
          //         } else if (borderDrag == BorderDrag.bottom) {
          //           widget.box.height = newPosition.dy - widget.box.position.dy;
          //         }
          //
          //         widget.onDrag(newPosition);
          //       }
          //     },
          //     onPanEnd: (dragDetails) {
          //       setState(() {
          //         isDragging = false;
          //         borderDrag = null;
          //       });
          //       // widget.onDragEnd(newPosition);
          //     },
          //     onTap: () {
          //       print("top");
          //     },
          //     // child:CustomPaint(size: Size(widget.box.width, 3),painter: LeftLinePainter(box: widget.box),)
          //     child: Container(
          //       height: widget.box.height,
          //       width: 10,
          //       decoration: LineBoxDecoration(
          //           box: widget.box, borderDrag: BorderDrag.left),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
