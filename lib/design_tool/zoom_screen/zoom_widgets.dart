// import 'dart:math' as math;
//
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/physics.dart';
// import 'package:vector_math/vector_math_64.dart' show Quad, Vector3, Matrix4;
//
// typedef ZoomWidgetBuilder = Widget Function(
//     BuildContext context, Quad viewport);
//
// @immutable
// class Zoom extends StatefulWidget {
//   Zoom({
//     this.backgroundColor = Colors.grey,
//     this.canvasColor = Colors.white,
//     this.centerOnScale = true,
//     required this.child,
//     this.colorScrollBars = Colors.black12,
//     this.doubleTapAnimDuration = const Duration(milliseconds: 300),
//     this.doubleTapScaleChange = 1.1,
//     this.doubleTapZoom = true,
//     this.enableScroll = true,
//     this.initPosition,
//     this.initScale,
//     this.initTotalZoomOut = false,
//     Key? key,
//     this.maxScale = 2.5,
//     this.maxZoomHeight,
//     this.maxZoomWidth,
//     this.onPositionUpdate,
//     this.onScaleUpdate,
//     this.onPanUpPosition,
//     this.onMinZoom,
//     this.onTap,
//     this.opacityScrollBars = 0.5,
//     this.radiusScrollBars = 4,
//     this.scrollWeight = 10,
//     this.transformationController,
//     this.zoomSensibility = 1.0,
//   })  : assert(maxScale > 0),
//         assert(!maxScale.isNaN),
//         super(key: key);
//
//   final Color backgroundColor;
//   final Color canvasColor;
//   final bool centerOnScale;
//   final Widget child;
//   final Color colorScrollBars;
//   final Duration doubleTapAnimDuration;
//   final double doubleTapScaleChange;
//   final bool doubleTapZoom;
//   final bool enableScroll;
//   final Offset? initPosition;
//   final double? initScale;
//   final bool initTotalZoomOut;
//   final double maxScale;
//   final double? maxZoomHeight;
//   final double? maxZoomWidth;
//   final Function(Offset)? onPositionUpdate;
//   final Function(double, double)? onScaleUpdate;
//   final Function(Offset)? onPanUpPosition;
//   final Function(bool)? onMinZoom;
//   final Function()? onTap;
//   final double opacityScrollBars;
//   final double radiusScrollBars;
//   final double scrollWeight;
//   final TransformationController? transformationController;
//   final double zoomSensibility;
//
//   static Vector3 getNearestPointOnLine(Vector3 point, Vector3 l1, Vector3 l2) {
//     final double lengthSquared = math.pow(l2.x - l1.x, 2.0).toDouble() +
//         math.pow(l2.y - l1.y, 2.0).toDouble();
//
//     if (lengthSquared == 0) {
//       return l1;
//     }
//
//     final Vector3 l1P = point - l1;
//     final Vector3 l1L2 = l2 - l1;
//     final double fraction = (l1P.dot(l1L2) / lengthSquared).clamp(0.0, 1.0);
//     return l1 + l1L2 * fraction;
//   }
//
//   static Quad getAxisAlignedBoundingBox(Quad quad) {
//     final double minX = math.min(
//       quad.point0.x,
//       math.min(
//         quad.point1.x,
//         math.min(
//           quad.point2.x,
//           quad.point3.x,
//         ),
//       ),
//     );
//     final double minY = math.min(
//       quad.point0.y,
//       math.min(
//         quad.point1.y,
//         math.min(
//           quad.point2.y,
//           quad.point3.y,
//         ),
//       ),
//     );
//     final double maxX = math.max(
//       quad.point0.x,
//       math.max(
//         quad.point1.x,
//         math.max(
//           quad.point2.x,
//           quad.point3.x,
//         ),
//       ),
//     );
//     final double maxY = math.max(
//       quad.point0.y,
//       math.max(
//         quad.point1.y,
//         math.max(
//           quad.point2.y,
//           quad.point3.y,
//         ),
//       ),
//     );
//     return Quad.points(
//       Vector3(minX, minY, 0),
//       Vector3(maxX, minY, 0),
//       Vector3(maxX, maxY, 0),
//       Vector3(minX, maxY, 0),
//     );
//   }
//
//   static bool pointIsInside(Vector3 point, Quad quad) {
//     final Vector3 aM = point - quad.point0;
//     final Vector3 aB = quad.point1 - quad.point0;
//     final Vector3 aD = quad.point3 - quad.point0;
//
//     final double aMAB = aM.dot(aB);
//     final double aBAB = aB.dot(aB);
//     final double aMAD = aM.dot(aD);
//     final double aDAD = aD.dot(aD);
//
//     return 0 <= aMAB && aMAB <= aBAB && 0 <= aMAD && aMAD <= aDAD;
//   }
//
//   static Vector3 getNearestPointInside(Vector3 point, Quad quad) {
//     if (pointIsInside(point, quad)) {
//       return point;
//     }
//
//     final List<Vector3> closestPoints = <Vector3>[
//       Zoom.getNearestPointOnLine(point, quad.point0, quad.point1),
//       Zoom.getNearestPointOnLine(point, quad.point1, quad.point2),
//       Zoom.getNearestPointOnLine(point, quad.point2, quad.point3),
//       Zoom.getNearestPointOnLine(point, quad.point3, quad.point0),
//     ];
//     double minDistance = double.infinity;
//     late Vector3 closestOverall;
//     for (final Vector3 closePoint in closestPoints) {
//       final double distance = math.sqrt(
//         math.pow(point.x - closePoint.x, 2) +
//             math.pow(point.y - closePoint.y, 2),
//       );
//       if (distance < minDistance) {
//         minDistance = distance;
//         closestOverall = closePoint;
//       }
//     }
//     return closestOverall;
//   }
//
//   @override
//   State<Zoom> createState() => _ZoomState();
// }
//
// class _ZoomState extends State<Zoom>
//     with TickerProviderStateMixin, WidgetsBindingObserver {
//   TransformationController? _transformationController;
//
//   final GlobalKey _childKey = GlobalKey();
//   final GlobalKey _parentKey = GlobalKey();
//   Animation<Offset>? _animation;
//   late AnimationController _controller;
//   Animation<double>? _scaleAnimation;
//   late AnimationController _scaleController;
//   Axis? _panAxis;
//   Offset? _referenceFocalPoint;
//   double? _scaleStart;
//   _GestureType? _gestureType;
//   ValueNotifier<_ScrollBarData> verticalScrollNotifier =
//   ValueNotifier(_ScrollBarData(length: 0, position: 0));
//   ValueNotifier<_ScrollBarData> horizontalScrollNotifier =
//   ValueNotifier(_ScrollBarData(length: 0, position: 0));
//   Size parentSize = Size.zero;
//   Size childSize = Size.zero;
//   Orientation? _orientation;
//   Offset? _doubleTapFocalPoint;
//   bool doubleTapZoomIn = true;
//   bool firstDraw = true;
//
//   static const double _kDrag = 0.0000135;
//
//   Rect get _boundaryRect {
//     assert(_childKey.currentContext != null);
//
//     final Rect boundaryRect =
//     EdgeInsets.zero.inflateRect(Offset.zero & childSize);
//     assert(
//     !boundaryRect.isEmpty,
//     "Zoom's child must have nonzero dimensions.",
//     );
//
//     assert(
//     boundaryRect.isFinite ||
//         (boundaryRect.left.isInfinite &&
//             boundaryRect.top.isInfinite &&
//             boundaryRect.right.isInfinite &&
//             boundaryRect.bottom.isInfinite),
//     'boundaryRect must either be infinite in all directions or finite in all directions.',
//     );
//     return boundaryRect;
//   }
//
//   Rect get _viewport {
//     assert(_parentKey.currentContext != null);
//     final RenderBox parentRenderBox =
//     _parentKey.currentContext!.findRenderObject()! as RenderBox;
//     return Offset.zero & parentRenderBox.size;
//   }
//
//   double _getScrollPercent(Matrix4 matrix, {required _ScrollType scrollType}) {
//     switch (scrollType) {
//       case _ScrollType.horizontal:
//         return _getMatrixTranslation(matrix).dx.abs() /
//             ((childSize.width * matrix.getMaxScaleOnAxis()) -
//                 parentSize.width) *
//             100.0;
//
//       case _ScrollType.vertical:
//         return _getMatrixTranslation(matrix).dy.abs() /
//             ((childSize.height * matrix.getMaxScaleOnAxis()) -
//                 parentSize.height) *
//             100.0;
//     }
//   }
//
//   double _getScrollBarLength(Matrix4 matrix,
//       {required _ScrollType scrollType}) {
//     double percent = 0;
//     switch (scrollType) {
//       case _ScrollType.horizontal:
//         percent =
//         (parentSize.width / (childSize.width * matrix.getMaxScaleOnAxis()));
//         return parentSize.width * percent;
//
//       case _ScrollType.vertical:
//         percent = (parentSize.height /
//             (childSize.height * matrix.getMaxScaleOnAxis()));
//         return parentSize.height * percent;
//     }
//   }
//
//   void onDisabledScrolls() {
//     if (horizontalScrollNotifier.value.length == 0 &&
//         horizontalScrollNotifier.value.position == 0 &&
//         verticalScrollNotifier.value.length == 0 &&
//         verticalScrollNotifier.value.position == 0) {
//       widget.onMinZoom?.call(true);
//     } else {
//       widget.onMinZoom?.call(false);
//     }
//   }
//
//   void _updateScroll(Matrix4 matrix) {
//     if (childSize.width * matrix.getMaxScaleOnAxis() >
//         parentSize.width + (parentSize.width * 0.01)) {
//       var horizontalPercent =
//       _getScrollPercent(matrix, scrollType: _ScrollType.horizontal);
//
//       final horizontalLength =
//       _getScrollBarLength(matrix, scrollType: _ScrollType.horizontal);
//
//       horizontalScrollNotifier.value = _ScrollBarData(
//           length: horizontalLength,
//           position: (horizontalPercent / 100.0) *
//               (parentSize.width - horizontalLength));
//     } else {
//       horizontalScrollNotifier.value = _ScrollBarData(length: 0, position: 0);
//       onDisabledScrolls();
//     }
//
//     if (childSize.height * matrix.getMaxScaleOnAxis() >
//         parentSize.height + (parentSize.height * 0.01)) {
//       final verticalPercent =
//       _getScrollPercent(matrix, scrollType: _ScrollType.vertical);
//
//       final verticalLength =
//       _getScrollBarLength(matrix, scrollType: _ScrollType.vertical);
//
//       verticalScrollNotifier.value = _ScrollBarData(
//           length: verticalLength,
//           position:
//           (verticalPercent / 100) * (parentSize.height - verticalLength));
//     } else {
//       verticalScrollNotifier.value = _ScrollBarData(length: 0, position: 0);
//       onDisabledScrolls();
//     }
//   }
//
//   Matrix4 _matrixTranslate(Matrix4 matrix, Offset translation,
//       {bool fixOffset = false}) {
//     if (translation == Offset.zero) {
//       return matrix.clone();
//     }
//
//     final Offset alignedTranslation = translation;
//
//     final Matrix4 nextMatrix = matrix.clone()
//       ..translate(
//         alignedTranslation.dx,
//         alignedTranslation.dy,
//       );
//
//     final Quad nextViewport = _transformViewport(nextMatrix, _viewport);
//
//     if (_boundaryRect.isInfinite && !fixOffset) {
//       _updateScroll(nextMatrix);
//       widget.onPositionUpdate?.call(_getMatrixTranslation(nextMatrix));
//       return nextMatrix;
//     }
//
//     final Quad boundariesAabbQuad = _getAxisAlignedBoundingBoxWithRotation(
//       _boundaryRect,
//       0.0,
//     );
//
//     final Offset offendingDistance =
//     _exceedsBy(boundariesAabbQuad, nextViewport);
//     if (offendingDistance == Offset.zero) {
//       _updateScroll(nextMatrix);
//       widget.onPositionUpdate?.call(_getMatrixTranslation(nextMatrix));
//       return nextMatrix;
//     }
//
//     final Offset nextTotalTranslation = _getMatrixTranslation(nextMatrix);
//     final double currentScale = matrix.getMaxScaleOnAxis();
//     final Offset correctedTotalTranslation = Offset(
//       nextTotalTranslation.dx - offendingDistance.dx * currentScale,
//       nextTotalTranslation.dy - offendingDistance.dy * currentScale,
//     );
//
//     final Matrix4 correctedMatrix = matrix.clone()
//       ..setTranslation(Vector3(
//         correctedTotalTranslation.dx,
//         correctedTotalTranslation.dy,
//         0.0,
//       ));
//
//     final Quad correctedViewport =
//     _transformViewport(correctedMatrix, _viewport);
//     final Offset offendingCorrectedDistance =
//     _exceedsBy(boundariesAabbQuad, correctedViewport);
//     if (offendingCorrectedDistance == Offset.zero && !fixOffset) {
//       _updateScroll(correctedMatrix);
//       widget.onPositionUpdate?.call(_getMatrixTranslation(correctedMatrix));
//       return correctedMatrix;
//     }
//
//     if (offendingCorrectedDistance.dx != 0.0 &&
//         offendingCorrectedDistance.dy != 0.0 &&
//         !fixOffset &&
//         (childSize.width > parentSize.width ||
//             childSize.height > parentSize.height)) {
//       return matrix.clone();
//     }
//
//     final Offset unidirectionalCorrectedTotalTranslation = Offset(
//       offendingCorrectedDistance.dx == 0.0 ? correctedTotalTranslation.dx : 0.0,
//       offendingCorrectedDistance.dy == 0.0 ? correctedTotalTranslation.dy : 0.0,
//     );
//     final verticalMidLength =
//         (parentSize.height - childSize.height * matrix.getMaxScaleOnAxis()) / 2;
//     final horizontalMidLength =
//         (parentSize.width - (childSize.width * matrix.getMaxScaleOnAxis())) / 2;
//
//     double horizontalMid = 0;
//     double verticalMid = 0;
//
//     void calculateMids(bool sizeCondition) {
//       if (sizeCondition) {
//         verticalMid = verticalMidLength;
//         if (childSize.width < parentSize.width) {
//           horizontalMid = horizontalMidLength;
//         }
//       } else {
//         horizontalMid = horizontalMidLength;
//         if (childSize.height < parentSize.height) {
//           verticalMid = verticalMidLength;
//         }
//       }
//     }
//
//     if (childSize.width == childSize.height) {
//       calculateMids(parentSize.height > parentSize.width);
//     } else {
//       calculateMids(childSize.height < childSize.width);
//     }
//
//     final midMatrix = matrix.clone()
//       ..setTranslation(Vector3(
//         unidirectionalCorrectedTotalTranslation.dx +
//             (widget.centerOnScale
//                 ? horizontalMid < 0
//                 ? 0
//                 : horizontalMid
//                 : 0),
//         unidirectionalCorrectedTotalTranslation.dy +
//             (widget.centerOnScale
//                 ? verticalMid < 0
//                 ? 0
//                 : verticalMid
//                 : 0),
//         0.0,
//       ));
//     _updateScroll(midMatrix);
//     widget.onPositionUpdate?.call(_getMatrixTranslation(midMatrix));
//     return midMatrix;
//   }
//
//   Matrix4 _matrixScale(Matrix4 matrix, double scale, {bool fixScale = false}) {
//     double sensibleScale = scale > 1.0
//         ? 1.0 + ((scale - 1.0) * widget.zoomSensibility)
//         : 1.0 - ((1.0 - scale) * widget.zoomSensibility);
//     if (scale == 1.0) {
//       return matrix.clone();
//     }
//     assert(scale != 0.0);
//
//     final nextScale =
//     (matrix.clone()..scale(sensibleScale)).getMaxScaleOnAxis();
//
//     if (childSize.width == childSize.height) {
//       if (parentSize.height > parentSize.width) {
//         if ((childSize.width * nextScale) < parentSize.width &&
//             nextScale < 1.0) {
//           return matrix.clone();
//         }
//       } else {
//         if ((childSize.height * nextScale) < parentSize.height &&
//             nextScale < 1.0) {
//           return matrix.clone();
//         }
//       }
//     } else {
//       if (childSize.height < childSize.width) {
//         if ((childSize.width * nextScale) < parentSize.width &&
//             nextScale < 1.0) {
//           return matrix.clone();
//         }
//       } else {
//         if ((childSize.height * nextScale) < parentSize.height &&
//             nextScale < 1.0) {
//           return matrix.clone();
//         }
//       }
//     }
//
//     if (matrix.getMaxScaleOnAxis() > widget.maxScale && sensibleScale > 1) {
//       return matrix.clone();
//     }
//     final newMatrix = matrix.clone()
//       ..scale(fixScale ? scale : sensibleScale.abs());
//
//     widget.onScaleUpdate?.call(
//       fixScale ? scale : sensibleScale.abs(),
//       newMatrix.getMaxScaleOnAxis(),
//     );
//
//     return newMatrix;
//   }
//
//   bool _gestureIsSupported(_GestureType? gestureType) {
//     switch (gestureType) {
//       case _GestureType.scale:
//         return true;
//
//       case _GestureType.pan:
//       case null:
//         return true;
//     }
//   }
//
//   _GestureType _getGestureType(ScaleUpdateDetails details) {
//     final double scale = details.scale;
//     if ((scale - 1).abs() != 0) {
//       return _GestureType.scale;
//     } else {
//       return _GestureType.pan;
//     }
//   }
//
//   void _onScaleStart(ScaleStartDetails details) {
//     if (_controller.isAnimating) {
//       _controller.stop();
//       _controller.reset();
//       _animation?.removeListener(_onAnimate);
//       _animation = null;
//     }
//
//     _gestureType = null;
//     _panAxis = null;
//     _scaleStart = _transformationController!.value.getMaxScaleOnAxis();
//     _referenceFocalPoint = _transformationController!.toScene(
//       details.localFocalPoint,
//     );
//   }
//
//   void _onScaleUpdate(ScaleUpdateDetails details) {
//     final double scale = _transformationController!.value.getMaxScaleOnAxis();
//     final Offset focalPointScene = _transformationController!.toScene(
//       details.localFocalPoint,
//     );
//
//     if (_gestureType == _GestureType.pan) {
//       _gestureType = _getGestureType(details);
//     } else {
//       _gestureType ??= _getGestureType(details);
//     }
//
//     switch (_gestureType!) {
//       case _GestureType.scale:
//         assert(_scaleStart != null);
//
//         final double desiredScale = _scaleStart! * details.scale;
//         final double scaleChange = desiredScale / scale;
//         _transformationController!.value = _matrixScale(
//           _transformationController!.value,
//           scaleChange,
//         );
//
//         final Offset focalPointSceneScaled = _transformationController!.toScene(
//           details.localFocalPoint,
//         );
//
//         _transformationController!.value = _matrixTranslate(
//           _transformationController!.value,
//           focalPointSceneScaled - _referenceFocalPoint!,
//         );
//
//         final Offset focalPointSceneCheck = _transformationController!.toScene(
//           details.localFocalPoint,
//         );
//         if (_round(_referenceFocalPoint!) != _round(focalPointSceneCheck)) {
//           _referenceFocalPoint = focalPointSceneCheck;
//         }
//         break;
//
//       case _GestureType.pan:
//         assert(_referenceFocalPoint != null);
//
//         _panAxis ??= _getPanAxis(_referenceFocalPoint!, focalPointScene);
//
//         final Offset translationChange =
//             focalPointScene - _referenceFocalPoint!;
//         _transformationController!.value = _matrixTranslate(
//           _transformationController!.value,
//           translationChange,
//         );
//         _referenceFocalPoint = _transformationController!.toScene(
//           details.localFocalPoint,
//         );
//         break;
//     }
//   }
//
//   void _onScaleEnd(ScaleEndDetails details) {
//     _scaleStart = null;
//
//     _animation?.removeListener(_onAnimate);
//     _controller.reset();
//
//     if (!_gestureIsSupported(_gestureType)) {
//       _panAxis = null;
//       return;
//     }
//
//     if (_gestureType != _GestureType.pan ||
//         details.velocity.pixelsPerSecond.distance < kMinFlingVelocity) {
//       _panAxis = null;
//       return;
//     }
//
//     final Vector3 translationVector =
//     _transformationController!.value.getTranslation();
//     final Offset translation = Offset(translationVector.x, translationVector.y);
//     final FrictionSimulation frictionSimulationX = FrictionSimulation(
//       _kDrag,
//       translation.dx,
//       details.velocity.pixelsPerSecond.dx,
//     );
//     final FrictionSimulation frictionSimulationY = FrictionSimulation(
//       _kDrag,
//       translation.dy,
//       details.velocity.pixelsPerSecond.dy,
//     );
//     final double tFinal = _getFinalTime(
//       details.velocity.pixelsPerSecond.distance,
//       _kDrag,
//     );
//     _animation = Tween<Offset>(
//       begin: translation,
//       end: Offset(frictionSimulationX.finalX, frictionSimulationY.finalX),
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: Curves.decelerate,
//     ));
//     _controller.duration = Duration(milliseconds: (tFinal * 1000).round());
//     _animation!.addListener(_onAnimate);
//     _controller.forward();
//   }
//
//   void _receivedPointerSignal(PointerSignalEvent event) {
//     if (event is PointerScrollEvent) {
//       if (event.scrollDelta.dy == 0.0) {
//         return;
//       }
//
//       final double scaleChange = math.exp(-event.scrollDelta.dy / 200);
//
//       final Offset focalPointScene = _transformationController!.toScene(
//         event.localPosition,
//       );
//
//       _transformationController!.value = _matrixScale(
//         _transformationController!.value,
//         scaleChange,
//       );
//
//       final Offset focalPointSceneScaled = _transformationController!.toScene(
//         event.localPosition,
//       );
//       _transformationController!.value = _matrixTranslate(
//         _transformationController!.value,
//         focalPointSceneScaled - focalPointScene,
//       );
//     }
//   }
//
//   void _onDoubleTap() {
//     if (!_scaleController.isAnimating && widget.doubleTapZoom) {
//       doubleTapZoomIn = _transformationController!.value.getMaxScaleOnAxis() <
//           widget.maxScale;
//
//       _scaleAnimation = Tween<double>(
//         begin: _transformationController!.value.getMaxScaleOnAxis(),
//         end: widget.maxScale,
//       ).animate(CurvedAnimation(
//         parent: _scaleController,
//         curve: Curves.decelerate,
//       ));
//       _scaleController.duration = doubleTapZoomIn
//           ? Duration(
//           milliseconds: 100 + widget.doubleTapAnimDuration.inMilliseconds)
//           : widget.doubleTapAnimDuration;
//       _scaleAnimation!.addListener(_onAnimateScale);
//       _scaleController.forward();
//     }
//   }
//
//   void _onAnimate() {
//     if (!_controller.isAnimating) {
//       _panAxis = null;
//       _animation?.removeListener(_onAnimate);
//       _animation = null;
//       _controller.reset();
//       return;
//     }
//
//     final Vector3 translationVector =
//     _transformationController!.value.getTranslation();
//     final Offset translation = Offset(translationVector.x, translationVector.y);
//     final Offset translationScene = _transformationController!.toScene(
//       translation,
//     );
//     final Offset animationScene = _transformationController!.toScene(
//       _animation!.value,
//     );
//     final Offset translationChangeScene = animationScene - translationScene;
//     _transformationController!.value = _matrixTranslate(
//       _transformationController!.value,
//       translationChangeScene,
//     );
//   }
//
//   void _onAnimateScale() {
//     if (!_scaleController.isAnimating) {
//       _scaleAnimation?.removeListener(_onAnimateScale);
//       _scaleAnimation = null;
//       _scaleController.reset();
//       return;
//     }
//     double scaleChange;
//
//     if (widget.doubleTapScaleChange < 1.0) {
//       scaleChange = doubleTapZoomIn ? 1.01 : 0.99;
//     } else {
//       scaleChange = doubleTapZoomIn
//           ? widget.doubleTapScaleChange
//           : 1 - (widget.doubleTapScaleChange - 1);
//     }
//
//     final Offset focalPointScene = _transformationController!.toScene(
//       _doubleTapFocalPoint ?? Offset.zero,
//     );
//
//     _transformationController!.value = _matrixScale(
//       _transformationController!.value,
//       scaleChange,
//       fixScale: true,
//     );
//
//     final Offset focalPointSceneScaled = _transformationController!.toScene(
//       _doubleTapFocalPoint ?? Offset.zero,
//     );
//
//     Offset diference = focalPointSceneScaled - focalPointScene;
//
//     _transformationController!.value = _matrixTranslate(
//       _transformationController!.value,
//       diference,
//     );
//   }
//
//   void _onTransformationControllerChange() {
//     setState(() {});
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//
//     _transformationController =
//         widget.transformationController ?? TransformationController();
//     _transformationController!.addListener(_onTransformationControllerChange);
//     _controller = AnimationController(
//       vsync: this,
//     );
//     _scaleController = AnimationController(
//       vsync: this,
//     );
//   }
//
//   @override
//   void didChangeMetrics() {
//     setState(() {
//       recalculateSizes();
//     });
//   }
//
//   @override
//   void didUpdateWidget(Zoom oldWidget) {
//     super.didUpdateWidget(oldWidget);
//
//     if (oldWidget.transformationController == null) {
//       if (widget.transformationController != null) {
//         _transformationController!
//             .removeListener(_onTransformationControllerChange);
//         _transformationController!.dispose();
//         _transformationController = widget.transformationController;
//         _transformationController!
//             .addListener(_onTransformationControllerChange);
//       }
//     } else {
//       if (widget.transformationController == null) {
//         _transformationController!
//             .removeListener(_onTransformationControllerChange);
//         _transformationController = TransformationController();
//         _transformationController!
//             .addListener(_onTransformationControllerChange);
//       } else if (widget.transformationController !=
//           oldWidget.transformationController) {
//         _transformationController!
//             .removeListener(_onTransformationControllerChange);
//         _transformationController = widget.transformationController;
//         _transformationController!
//             .addListener(_onTransformationControllerChange);
//       }
//     }
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     _scaleController.dispose();
//     _transformationController!
//         .removeListener(_onTransformationControllerChange);
//     WidgetsBinding.instance.removeObserver(this);
//     if (widget.transformationController == null) {
//       _transformationController!.dispose();
//     }
//     super.dispose();
//   }
//
//   void fixScale(double scale) {
//     _transformationController!.value = _matrixScale(
//       _transformationController!.value,
//       scale,
//       fixScale: true,
//     );
//     _transformationController!.toScene(
//       _referenceFocalPoint ?? Offset.zero,
//     );
//     _transformationController!.toScene(
//       _referenceFocalPoint ?? Offset.zero,
//     );
//   }
//
//   void recalculateSizes() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (_parentKey.currentContext?.findRenderObject() == null) {
//         return;
//       }
//
//       final RenderBox parentRenderBox =
//       _parentKey.currentContext!.findRenderObject()! as RenderBox;
//       parentSize = parentRenderBox.size;
//       final RenderBox childRenderBox =
//       _childKey.currentContext!.findRenderObject()! as RenderBox;
//       childSize = childRenderBox.size;
//       double scale = 0;
//
//       final currentScale = _transformationController!.value.getMaxScaleOnAxis();
//
//       _transformationController!.value = _matrixTranslate(
//           _transformationController!.value,
//           Offset(
//             -0.01,
//             -0.01,
//           ),
//           fixOffset: true);
//
//       if (childSize.width == childSize.height) {
//         if (childSize.width > parentSize.width &&
//             ((childSize.width * currentScale) < parentSize.width ||
//                 (childSize.height * currentScale) < parentSize.height)) {
//           scale = parentSize.width / (childSize.width * currentScale);
//           fixScale(scale);
//         }
//       } else {
//         if (childSize.width > childSize.height) {
//           if (childSize.width > parentSize.width &&
//               (childSize.width * currentScale) < parentSize.width) {
//             scale = parentSize.width / (childSize.width * currentScale);
//             fixScale(scale);
//           }
//         } else {
//           if (childSize.height > parentSize.height &&
//               (childSize.height * currentScale) < parentSize.height) {
//             scale = parentSize.height / (childSize.height * currentScale);
//             fixScale(scale);
//           }
//         }
//       }
//
//       _transformationController!.value = _matrixTranslate(
//         _transformationController!.value,
//         Offset(
//           -0.01,
//           -0.01,
//         ),
//       );
//
//       void fitChild(bool condition) {
//         if (condition) {
//           _transformationController!.value = _matrixScale(
//               _transformationController!.value,
//               parentSize.height / childSize.height,
//               fixScale: true);
//
//           _transformationController!.value = _matrixTranslate(
//               _transformationController!.value, Offset(-0.01, -0.01),
//               fixOffset: true);
//         } else {
//           _transformationController!.value = _matrixScale(
//               _transformationController!.value,
//               parentSize.width / childSize.width,
//               fixScale: true);
//
//           _transformationController!.value = _matrixTranslate(
//               _transformationController!.value, Offset(-0.01, -0.01),
//               fixOffset: true);
//         }
//       }
//
//       if (widget.initTotalZoomOut) {
//         if (firstDraw &&
//             (childSize.width > parentSize.width ||
//                 childSize.height > parentSize.height)) {
//           if (childSize.width == childSize.height) {
//             fitChild(parentSize.width > parentSize.height);
//           } else {
//             fitChild(childSize.width < childSize.height);
//           }
//           firstDraw = false;
//         }
//       } else {
//         if (widget.initScale != null) {
//           _transformationController!.value = _matrixScale(
//               _transformationController!.value, widget.initScale ?? 0.0,
//               fixScale: true);
//
//           _transformationController!.value = _matrixTranslate(
//               _transformationController!.value, Offset(-0.01, -0.01),
//               fixOffset: true);
//         }
//         if (widget.initPosition != null) {
//           _transformationController!.value = _matrixTranslate(
//             _transformationController!.value,
//             widget.initPosition ?? Offset.zero,
//           );
//
//           _referenceFocalPoint = _transformationController!.toScene(
//             widget.initPosition ?? Offset.zero,
//           );
//         }
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Widget child;
//     child = _ZoomBuilt(
//       childKey: _childKey,
//       constrained: false,
//       matrix: _transformationController!.value,
//       child: Listener(
//         onPointerUp: (event) {
//           if (widget.onPanUpPosition != null) {
//             widget.onPanUpPosition!(event.localPosition);
//           }
//         },
//         child: (widget.maxZoomWidth == null || widget.maxZoomHeight == null)
//             ? Container(
//           color: widget.canvasColor,
//           child: widget.child,
//         )
//             : Center(
//           child: Container(
//               width: widget.maxZoomWidth,
//               height: widget.maxZoomHeight,
//               color: widget.canvasColor,
//               child: widget.child),
//         ),
//       ),
//     );
//
//     return NotificationListener<SizeChangedLayoutNotification>(
//       onNotification: (notification) {
//         recalculateSizes();
//         return true;
//       },
//       child: OrientationBuilder(builder: (context, orientation) {
//         if (_orientation != orientation) {
//           _orientation = orientation;
//           recalculateSizes();
//         }
//
//         double opacity = widget.opacityScrollBars < 0
//             ? 0
//             : widget.opacityScrollBars > 1
//             ? 1
//             : widget.opacityScrollBars;
//
//         return ClipRect(
//           child: Container(
//             color: widget.backgroundColor,
//             child: Listener(
//               key: _parentKey,
//               onPointerSignal: _receivedPointerSignal,
//               onPointerDown: (PointerDownEvent event) {
//                 _doubleTapFocalPoint = event.localPosition;
//               },
//               child: GestureDetector(
//                 behavior: HitTestBehavior.opaque,
//                 onScaleEnd: _onScaleEnd,
//                 onScaleStart: _onScaleStart,
//                 onScaleUpdate: _onScaleUpdate,
//                 onDoubleTap: _onDoubleTap,
//                 onTap: widget.onTap,
//                 child: widget.enableScroll
//                     ? Stack(
//                   children: [
//                     child,
//                     ValueListenableBuilder<_ScrollBarData>(
//                         valueListenable: horizontalScrollNotifier,
//                         builder: (_, scrollData, __) {
//                           return scrollData.length == 0
//                               ? Container()
//                               : Positioned(
//                             top: parentSize.height -
//                                 widget.scrollWeight,
//                             left: scrollData.position,
//                             child: Container(
//                               decoration: BoxDecoration(
//                                   color: widget.colorScrollBars
//                                       .withAlpha(
//                                       (opacity * 255).toInt()),
//                                   borderRadius: BorderRadius.only(
//                                     topLeft: Radius.circular(
//                                       widget.radiusScrollBars,
//                                     ),
//                                     topRight: Radius.circular(
//                                         widget.radiusScrollBars),
//                                   )),
//                               height: widget.scrollWeight,
//                               width: scrollData.length,
//                             ),
//                           );
//                         }),
//                     ValueListenableBuilder<_ScrollBarData>(
//                         valueListenable: verticalScrollNotifier,
//                         builder: (_, scrollData, __) {
//                           return Positioned(
//                             left: parentSize.width - widget.scrollWeight,
//                             top: scrollData.position,
//                             child: Container(
//                               decoration: BoxDecoration(
//                                   color: widget.colorScrollBars
//                                       .withAlpha((opacity * 255).toInt()),
//                                   borderRadius: BorderRadius.only(
//                                     topLeft: Radius.circular(
//                                         widget.radiusScrollBars),
//                                     bottomLeft: Radius.circular(
//                                         widget.radiusScrollBars),
//                                   )),
//                               height: scrollData.length,
//                               width: widget.scrollWeight,
//                             ),
//                           );
//                         }),
//                   ],
//                 )
//                     : child,
//               ),
//             ),
//           ),
//         );
//       }),
//     );
//   }
// }
//
// class _ZoomBuilt extends StatelessWidget {
//   const _ZoomBuilt({
//     Key? key,
//     required this.child,
//     required this.childKey,
//     required this.constrained,
//     required this.matrix,
//   }) : super(key: key);
//
//   final Widget child;
//   final GlobalKey childKey;
//   final bool constrained;
//   final Matrix4 matrix;
//
//   @override
//   Widget build(BuildContext context) {
//     Widget child = Transform(
//       transform: matrix,
//       child: KeyedSubtree(
//         key: childKey,
//         child: this.child,
//       ),
//     );
//
//     if (!constrained) {
//       child = OverflowBox(
//         alignment: Alignment.topLeft,
//         minWidth: 0.0,
//         minHeight: 0.0,
//         maxWidth: double.infinity,
//         maxHeight: double.infinity,
//         child: child,
//       );
//     }
//
//     return child;
//   }
// }
//
// class TransformationController extends ValueNotifier<Matrix4> {
//   TransformationController([Matrix4? value])
//       : super(value ?? Matrix4.identity());
//
//   Offset toScene(Offset viewportPoint) {
//     final Matrix4 inverseMatrix = Matrix4.inverted(value);
//     final Vector3 untransformed = inverseMatrix.transform3(Vector3(
//       viewportPoint.dx,
//       viewportPoint.dy,
//       0,
//     ));
//     return Offset(untransformed.x, untransformed.y);
//   }
// }
//
// enum _GestureType {
//   pan,
//   scale,
// }
//
// enum _ScrollType {
//   horizontal,
//   vertical,
// }
//
// class _ScrollBarData {
//   _ScrollBarData({
//     required this.length,
//     required this.position,
//   });
//
//   final double position;
//   final double length;
// }
//
// double _getFinalTime(double velocity, double drag) {
//   const double effectivelyMotionless = 10.0;
//   return math.log(effectivelyMotionless / velocity) / math.log(drag / 100);
// }
//
// Offset _getMatrixTranslation(Matrix4 matrix) {
//   final Vector3 nextTranslation = matrix.getTranslation();
//   return Offset(nextTranslation.x, nextTranslation.y);
// }
//
// Quad _transformViewport(Matrix4 matrix, Rect viewport) {
//   final Matrix4 inverseMatrix = matrix.clone()..invert();
//   return Quad.points(
//     inverseMatrix.transform3(Vector3(
//       viewport.topLeft.dx,
//       viewport.topLeft.dy,
//       0.0,
//     )),
//     inverseMatrix.transform3(Vector3(
//       viewport.topRight.dx,
//       viewport.topRight.dy,
//       0.0,
//     )),
//     inverseMatrix.transform3(Vector3(
//       viewport.bottomRight.dx,
//       viewport.bottomRight.dy,
//       0.0,
//     )),
//     inverseMatrix.transform3(Vector3(
//       viewport.bottomLeft.dx,
//       viewport.bottomLeft.dy,
//       0.0,
//     )),
//   );
// }
//
// Quad _getAxisAlignedBoundingBoxWithRotation(Rect rect, double rotation) {
//   final Matrix4 rotationMatrix = Matrix4.identity()
//     ..translate(rect.size.width / 2, rect.size.height / 2)
//     ..rotateZ(rotation)
//     ..translate(-rect.size.width / 2, -rect.size.height / 2);
//   final Quad boundariesRotated = Quad.points(
//     rotationMatrix.transform3(Vector3(rect.left, rect.top, 0.0)),
//     rotationMatrix.transform3(Vector3(rect.right, rect.top, 0.0)),
//     rotationMatrix.transform3(Vector3(rect.right, rect.bottom, 0.0)),
//     rotationMatrix.transform3(Vector3(rect.left, rect.bottom, 0.0)),
//   );
//   return Zoom.getAxisAlignedBoundingBox(boundariesRotated);
// }
//
// Offset _exceedsBy(Quad boundary, Quad viewport) {
//   final List<Vector3> viewportPoints = <Vector3>[
//     viewport.point0,
//     viewport.point1,
//     viewport.point2,
//     viewport.point3,
//   ];
//   Offset largestExcess = Offset.zero;
//   for (final Vector3 point in viewportPoints) {
//     final Vector3 pointInside = Zoom.getNearestPointInside(point, boundary);
//     final Offset excess = Offset(
//       pointInside.x - point.x,
//       pointInside.y - point.y,
//     );
//     if (excess.dx.abs() > largestExcess.dx.abs()) {
//       largestExcess = Offset(excess.dx, largestExcess.dy);
//     }
//     if (excess.dy.abs() > largestExcess.dy.abs()) {
//       largestExcess = Offset(largestExcess.dx, excess.dy);
//     }
//   }
//
//   return _round(largestExcess);
// }
//
// Offset _round(Offset offset) {
//   return Offset(
//     double.parse(offset.dx.toStringAsFixed(9)),
//     double.parse(offset.dy.toStringAsFixed(9)),
//   );
// }
//
// Axis? _getPanAxis(Offset point1, Offset point2) {
//   if (point1 == point2) {
//     return null;
//   }
//   final double x = point2.dx - point1.dx;
//   final double y = point2.dy - point1.dy;
//   return x.abs() > y.abs() ? Axis.horizontal : Axis.vertical;
// }


// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
export 'package:flutter/rendering.dart' show
SliverGridDelegate,
SliverGridDelegateWithFixedCrossAxisCount,
SliverGridDelegateWithMaxCrossAxisExtent;

// Examples can assume:
// late SliverGridDelegateWithMaxCrossAxisExtent _gridDelegate;
// abstract class SomeWidget extends StatefulWidget { const SomeWidget({super.key}); }
// typedef ChildWidget = Placeholder;

/// A callback which produces a semantic index given a widget and the local index.
///
/// Return a null value to prevent a widget from receiving an index.
///
/// A semantic index is used to tag child semantic nodes for accessibility
/// announcements in scroll view.
///
/// See also:
///
///  * [CustomScrollView], for an explanation of scroll semantics.
///  * [SliverChildBuilderDelegate], for an explanation of how this is used to
///    generate indexes.
typedef SemanticIndexCallback = int? Function(Widget widget, int localIndex);

int _kDefaultSemanticIndexCallback(Widget _, int localIndex) => localIndex;

/// A delegate that supplies children for slivers.
///
/// Many slivers lazily construct their box children to avoid creating more
/// children than are visible through the [Viewport]. Rather than receiving
/// their children as an explicit [List], they receive their children using a
/// [SliverChildDelegate].
///
/// It's uncommon to subclass [SliverChildDelegate]. Instead, consider using one
/// of the existing subclasses that provide adaptors to builder callbacks or
/// explicit child lists.
///
/// {@template flutter.widgets.SliverChildDelegate.lifecycle}
/// ## Child elements' lifecycle
///
/// ### Creation
///
/// While laying out the list, visible children's elements, states and render
/// objects will be created lazily based on existing widgets (such as in the
/// case of [SliverChildListDelegate]) or lazily provided ones (such as in the
/// case of [SliverChildBuilderDelegate]).
///
/// ### Destruction
///
/// When a child is scrolled out of view, the associated element subtree, states
/// and render objects are destroyed. A new child at the same position in the
/// sliver will be lazily recreated along with new elements, states and render
/// objects when it is scrolled back.
///
/// ### Destruction mitigation
///
/// In order to preserve state as child elements are scrolled in and out of
/// view, the following options are possible:
///
///  * Moving the ownership of non-trivial UI-state-driving business logic
///    out of the sliver child subtree. For instance, if a list contains posts
///    with their number of upvotes coming from a cached network response, store
///    the list of posts and upvote number in a data model outside the list. Let
///    the sliver child UI subtree be easily recreate-able from the
///    source-of-truth model object. Use [StatefulWidget]s in the child widget
///    subtree to store instantaneous UI state only.
///
///  * Letting [KeepAlive] be the root widget of the sliver child widget subtree
///    that needs to be preserved. The [KeepAlive] widget marks the child
///    subtree's top render object child for keepalive. When the associated top
///    render object is scrolled out of view, the sliver keeps the child's
///    render object (and by extension, its associated elements and states) in a
///    cache list instead of destroying them. When scrolled back into view, the
///    render object is repainted as-is (if it wasn't marked dirty in the
///    interim).
///
///    This only works if the [SliverChildDelegate] subclasses don't wrap the
///    child widget subtree with other widgets such as [AutomaticKeepAlive] and
///    [RepaintBoundary] via `addAutomaticKeepAlives` and
///    `addRepaintBoundaries`.
///
///  * Using [AutomaticKeepAlive] widgets (inserted by default in
///    [SliverChildListDelegate] or [SliverChildListDelegate]).
///    [AutomaticKeepAlive] allows descendant widgets to control whether the
///    subtree is actually kept alive or not. This behavior is in contrast with
///    [KeepAlive], which will unconditionally keep the subtree alive.
///
///    As an example, the [EditableText] widget signals its sliver child element
///    subtree to stay alive while its text field has input focus. If it doesn't
///    have focus and no other descendants signaled for keepalive via a
///    [KeepAliveNotification], the sliver child element subtree will be
///    destroyed when scrolled away.
///
///    [AutomaticKeepAlive] descendants typically signal it to be kept alive by
///    using the [AutomaticKeepAliveClientMixin], then implementing the
///    [AutomaticKeepAliveClientMixin.wantKeepAlive] getter and calling
///    [AutomaticKeepAliveClientMixin.updateKeepAlive].
///
/// ## Using more than one delegate in a [Viewport]
///
/// If multiple delegates are used in a single scroll view, the first child of
/// each delegate will always be laid out, even if it extends beyond the
/// currently viewable area. This is because at least one child is required in
/// order to [estimateMaxScrollOffset] for the whole scroll view, as it uses the
/// currently built children to estimate the remaining children's extent.
/// {@endtemplate}
///
/// See also:
///
///  * [SliverChildBuilderDelegate], which is a delegate that uses a builder
///    callback to construct the children.
///  * [SliverChildListDelegate], which is a delegate that has an explicit list
///    of children.
abstract class SliverChildDelegate {
  /// Abstract const constructor. This constructor enables subclasses to provide
  /// const constructors so that they can be used in const expressions.
  const SliverChildDelegate();

  /// Returns the child with the given index.
  ///
  /// Should return null if asked to build a widget with a greater
  /// index than exists. If this returns null, [estimatedChildCount]
  /// must subsequently return a precise non-null value (which is then
  /// used to implement [RenderSliverBoxChildManager.childCount]).
  ///
  /// Subclasses typically override this function and wrap their children in
  /// [AutomaticKeepAlive], [IndexedSemantics], and [RepaintBoundary] widgets.
  ///
  /// The values returned by this method are cached. To indicate that the
  /// widgets have changed, a new delegate must be provided, and the new
  /// delegate's [shouldRebuild] method must return true.
  Widget? build(BuildContext context, int index);

  /// Returns an estimate of the number of children this delegate will build.
  ///
  /// Used to estimate the maximum scroll offset if [estimateMaxScrollOffset]
  /// returns null.
  ///
  /// Return null if there are an unbounded number of children or if it would
  /// be too difficult to estimate the number of children.
  ///
  /// This must return a precise number once [build] has returned null, as it
  /// used to implement [RenderSliverBoxChildManager.childCount].
  int? get estimatedChildCount => null;

  /// Returns an estimate of the max scroll extent for all the children.
  ///
  /// Subclasses should override this function if they have additional
  /// information about their max scroll extent.
  ///
  /// The default implementation returns null, which causes the caller to
  /// extrapolate the max scroll offset from the given parameters.
  double? estimateMaxScrollOffset(
      int firstIndex,
      int lastIndex,
      double leadingScrollOffset,
      double trailingScrollOffset,
      ) => null;

  /// Called at the end of layout to indicate that layout is now complete.
  ///
  /// The `firstIndex` argument is the index of the first child that was
  /// included in the current layout. The `lastIndex` argument is the index of
  /// the last child that was included in the current layout.
  ///
  /// Useful for subclasses that which to track which children are included in
  /// the underlying render tree.
  void didFinishLayout(int firstIndex, int lastIndex) { }

  /// Called whenever a new instance of the child delegate class is
  /// provided to the sliver.
  ///
  /// If the new instance represents different information than the old
  /// instance, then the method should return true, otherwise it should return
  /// false.
  ///
  /// If the method returns false, then the [build] call might be optimized
  /// away.
  bool shouldRebuild(covariant SliverChildDelegate oldDelegate);

  /// Find index of child element with associated key.
  ///
  /// This will be called during `performRebuild` in [SliverMultiBoxAdaptorElement]
  /// to check if a child has moved to a different position. It should return the
  /// index of the child element with associated key, null if not found.
  ///
  /// If not provided, a child widget may not map to its existing [RenderObject]
  /// when the order of children returned from the children builder changes.
  /// This may result in state-loss.
  int? findIndexByKey(Key key) => null;

  @override
  String toString() {
    final List<String> description = <String>[];
    debugFillDescription(description);
    return '${describeIdentity(this)}(${description.join(", ")})';
  }

  /// Add additional information to the given description for use by [toString].
  @protected
  @mustCallSuper
  void debugFillDescription(List<String> description) {
    try {
      final int? children = estimatedChildCount;
      if (children != null) {
        description.add('estimated child count: $children');
      }
    } catch (e) {
      // The exception is forwarded to widget inspector.
      description.add('estimated child count: EXCEPTION (${e.runtimeType})');
    }
  }
}

class _SaltedValueKey extends ValueKey<Key> {
  const _SaltedValueKey(super.value);
}

/// Called to find the new index of a child based on its `key` in case of
/// reordering.
///
/// If the child with the `key` is no longer present, null is returned.
///
/// Used by [SliverChildBuilderDelegate.findChildIndexCallback].
typedef ChildIndexGetter = int? Function(Key key);

/// A delegate that supplies children for slivers using a builder callback.
///
/// Many slivers lazily construct their box children to avoid creating more
/// children than are visible through the [Viewport]. This delegate provides
/// children using a [NullableIndexedWidgetBuilder] callback, so that the children do
/// not even have to be built until they are displayed.
///
/// The widgets returned from the builder callback are automatically wrapped in
/// [AutomaticKeepAlive] widgets if [addAutomaticKeepAlives] is true (the
/// default) and in [RepaintBoundary] widgets if [addRepaintBoundaries] is true
/// (also the default).
///
/// ## Accessibility
///
/// The [CustomScrollView] requires that its semantic children are annotated
/// using [IndexedSemantics]. This is done by default in the delegate with
/// the `addSemanticIndexes` parameter set to true.
///
/// If multiple delegates are used in a single scroll view, then the indexes
/// will not be correct by default. The `semanticIndexOffset` can be used to
/// offset the semantic indexes of each delegate so that the indexes are
/// monotonically increasing. For example, if a scroll view contains two
/// delegates where the first has 10 children contributing semantics, then the
/// second delegate should offset its children by 10.
///
/// {@tool snippet}
///
/// This sample code shows how to use `semanticIndexOffset` to handle multiple
/// delegates in a single scroll view.
///
/// ```dart
/// CustomScrollView(
///   semanticChildCount: 4,
///   slivers: <Widget>[
///     SliverGrid(
///       gridDelegate: _gridDelegate,
///       delegate: SliverChildBuilderDelegate(
///         (BuildContext context, int index) {
///            return const Text('...');
///          },
///          childCount: 2,
///        ),
///      ),
///     SliverGrid(
///       gridDelegate: _gridDelegate,
///       delegate: SliverChildBuilderDelegate(
///         (BuildContext context, int index) {
///            return const Text('...');
///          },
///          childCount: 2,
///          semanticIndexOffset: 2,
///        ),
///      ),
///   ],
/// )
/// ```
/// {@end-tool}
///
/// In certain cases, only a subset of child widgets should be annotated
/// with a semantic index. For example, in [ListView.separated()] the
/// separators do not have an index associated with them. This is done by
/// providing a `semanticIndexCallback` which returns null for separators
/// indexes and rounds the non-separator indexes down by half.
///
/// {@tool snippet}
///
/// This sample code shows how to use `semanticIndexCallback` to handle
/// annotating a subset of child nodes with a semantic index. There is
/// a [Spacer] widget at odd indexes which should not have a semantic
/// index.
///
/// ```dart
/// CustomScrollView(
///   semanticChildCount: 5,
///   slivers: <Widget>[
///     SliverGrid(
///       gridDelegate: _gridDelegate,
///       delegate: SliverChildBuilderDelegate(
///         (BuildContext context, int index) {
///            if (index.isEven) {
///              return const Text('...');
///            }
///            return const Spacer();
///          },
///          semanticIndexCallback: (Widget widget, int localIndex) {
///            if (localIndex.isEven) {
///              return localIndex ~/ 2;
///            }
///            return null;
///          },
///          childCount: 10,
///        ),
///      ),
///   ],
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [SliverChildListDelegate], which is a delegate that has an explicit list
///    of children.
///  * [IndexedSemantics], for an example of manually annotating child nodes
///    with semantic indexes.
class SliverChildBuilderDelegate extends SliverChildDelegate {
  /// Creates a delegate that supplies children for slivers using the given
  /// builder callback.
  ///
  /// The [builder], [addAutomaticKeepAlives], [addRepaintBoundaries],
  /// [addSemanticIndexes], and [semanticIndexCallback] arguments must not be
  /// null.
  ///
  /// If the order in which [builder] returns children ever changes, consider
  /// providing a [findChildIndexCallback]. This allows the delegate to find the
  /// new index for a child that was previously located at a different index to
  /// attach the existing state to the [Widget] at its new location.
  const SliverChildBuilderDelegate(
      this.builder, {
        this.findChildIndexCallback,
        this.childCount,
        this.addAutomaticKeepAlives = true,
        this.addRepaintBoundaries = true,
        this.addSemanticIndexes = true,
        this.semanticIndexCallback = _kDefaultSemanticIndexCallback,
        this.semanticIndexOffset = 0,
      });

  /// Called to build children for the sliver.
  ///
  /// Will be called only for indices greater than or equal to zero and less
  /// than [childCount] (if [childCount] is non-null).
  ///
  /// Should return null if asked to build a widget with a greater index than
  /// exists.
  ///
  /// May result in an infinite loop or run out of memory if [childCount] is null
  /// and the [builder] always provides a zero-size widget (such as `Container()`
  /// or `SizedBox.shrink()`). If possible, provide children with non-zero size,
  /// return null from [builder], or set a [childCount].
  ///
  /// The delegate wraps the children returned by this builder in
  /// [RepaintBoundary] widgets.
  final NullableIndexedWidgetBuilder builder;

  /// The total number of children this delegate can provide.
  ///
  /// If null, the number of children is determined by the least index for which
  /// [builder] returns null.
  ///
  /// May result in an infinite loop or run out of memory if [childCount] is null
  /// and the [builder] always provides a zero-size widget (such as `Container()`
  /// or `SizedBox.shrink()`). If possible, provide children with non-zero size,
  /// return null from [builder], or set a [childCount].
  final int? childCount;

  /// {@template flutter.widgets.SliverChildBuilderDelegate.addAutomaticKeepAlives}
  /// Whether to wrap each child in an [AutomaticKeepAlive].
  ///
  /// Typically, children in lazy list are wrapped in [AutomaticKeepAlive]
  /// widgets so that children can use [KeepAliveNotification]s to preserve
  /// their state when they would otherwise be garbage collected off-screen.
  ///
  /// This feature (and [addRepaintBoundaries]) must be disabled if the children
  /// are going to manually maintain their [KeepAlive] state. It may also be
  /// more efficient to disable this feature if it is known ahead of time that
  /// none of the children will ever try to keep themselves alive.
  ///
  /// Defaults to true.
  /// {@endtemplate}
  final bool addAutomaticKeepAlives;

  /// {@template flutter.widgets.SliverChildBuilderDelegate.addRepaintBoundaries}
  /// Whether to wrap each child in a [RepaintBoundary].
  ///
  /// Typically, children in a scrolling container are wrapped in repaint
  /// boundaries so that they do not need to be repainted as the list scrolls.
  /// If the children are easy to repaint (e.g., solid color blocks or a short
  /// snippet of text), it might be more efficient to not add a repaint boundary
  /// and instead always repaint the children during scrolling.
  ///
  /// Defaults to true.
  /// {@endtemplate}
  final bool addRepaintBoundaries;

  /// {@template flutter.widgets.SliverChildBuilderDelegate.addSemanticIndexes}
  /// Whether to wrap each child in an [IndexedSemantics].
  ///
  /// Typically, children in a scrolling container must be annotated with a
  /// semantic index in order to generate the correct accessibility
  /// announcements. This should only be set to false if the indexes have
  /// already been provided by an [IndexedSemantics] widget.
  ///
  /// Defaults to true.
  ///
  /// See also:
  ///
  ///  * [IndexedSemantics], for an explanation of how to manually
  ///    provide semantic indexes.
  /// {@endtemplate}
  final bool addSemanticIndexes;

  /// {@template flutter.widgets.SliverChildBuilderDelegate.semanticIndexOffset}
  /// An initial offset to add to the semantic indexes generated by this widget.
  ///
  /// Defaults to zero.
  /// {@endtemplate}
  final int semanticIndexOffset;

  /// {@template flutter.widgets.SliverChildBuilderDelegate.semanticIndexCallback}
  /// A [SemanticIndexCallback] which is used when [addSemanticIndexes] is true.
  ///
  /// Defaults to providing an index for each widget.
  /// {@endtemplate}
  final SemanticIndexCallback semanticIndexCallback;

  /// {@template flutter.widgets.SliverChildBuilderDelegate.findChildIndexCallback}
  /// Called to find the new index of a child based on its key in case of reordering.
  ///
  /// If not provided, a child widget may not map to its existing [RenderObject]
  /// when the order of children returned from the children builder changes.
  /// This may result in state-loss.
  ///
  /// This callback should take an input [Key], and it should return the
  /// index of the child element with that associated key, or null if not found.
  /// {@endtemplate}
  final ChildIndexGetter? findChildIndexCallback;

  @override
  int? findIndexByKey(Key key) {
    if (findChildIndexCallback == null) {
      return null;
    }
    final Key childKey;
    if (key is _SaltedValueKey) {
      final _SaltedValueKey saltedValueKey = key;
      childKey = saltedValueKey.value;
    } else {
      childKey = key;
    }
    return findChildIndexCallback!(childKey);
  }

  @override
  @pragma('vm:notify-debugger-on-exception')
  Widget? build(BuildContext context, int index) {
    if (index < 0 || (childCount != null && index >= childCount!)) {
      return null;
    }
    Widget? child;
    try {
      child = builder(context, index);
    } catch (exception, stackTrace) {
      child = _createErrorWidget(exception, stackTrace);
    }
    if (child == null) {
      return null;
    }
    final Key? key = child.key != null ? _SaltedValueKey(child.key!) : null;
    if (addRepaintBoundaries) {
      child = RepaintBoundary(child: child);
    }
    if (addSemanticIndexes) {
      final int? semanticIndex = semanticIndexCallback(child, index);
      if (semanticIndex != null) {
        child = IndexedSemantics(index: semanticIndex + semanticIndexOffset, child: child);
      }
    }
    if (addAutomaticKeepAlives) {
      child = AutomaticKeepAlive(child: _SelectionKeepAlive(child: child));
    }
    return KeyedSubtree(key: key, child: child);
  }

  @override
  int? get estimatedChildCount => childCount;

  @override
  bool shouldRebuild(covariant SliverChildBuilderDelegate oldDelegate) => true;
}

/// A delegate that supplies children for slivers using an explicit list.
///
/// Many slivers lazily construct their box children to avoid creating more
/// children than are visible through the [Viewport]. This delegate provides
/// children using an explicit list, which is convenient but reduces the benefit
/// of building children lazily.
///
/// In general building all the widgets in advance is not efficient. It is
/// better to create a delegate that builds them on demand using
/// [SliverChildBuilderDelegate] or by subclassing [SliverChildDelegate]
/// directly.
///
/// This class is provided for the cases where either the list of children is
/// known well in advance (ideally the children are themselves compile-time
/// constants, for example), and therefore will not be built each time the
/// delegate itself is created, or the list is small, such that it's likely
/// always visible (and thus there is nothing to be gained by building it on
/// demand). For example, the body of a dialog box might fit both of these
/// conditions.
///
/// The widgets in the given [children] list are automatically wrapped in
/// [AutomaticKeepAlive] widgets if [addAutomaticKeepAlives] is true (the
/// default) and in [RepaintBoundary] widgets if [addRepaintBoundaries] is true
/// (also the default).
///
/// ## Accessibility
///
/// The [CustomScrollView] requires that its semantic children are annotated
/// using [IndexedSemantics]. This is done by default in the delegate with
/// the `addSemanticIndexes` parameter set to true.
///
/// If multiple delegates are used in a single scroll view, then the indexes
/// will not be correct by default. The `semanticIndexOffset` can be used to
/// offset the semantic indexes of each delegate so that the indexes are
/// monotonically increasing. For example, if a scroll view contains two
/// delegates where the first has 10 children contributing semantics, then the
/// second delegate should offset its children by 10.
///
/// In certain cases, only a subset of child widgets should be annotated
/// with a semantic index. For example, in [ListView.separated()] the
/// separators do not have an index associated with them. This is done by
/// providing a `semanticIndexCallback` which returns null for separators
/// indexes and rounds the non-separator indexes down by half.
///
/// See [SliverChildBuilderDelegate] for sample code using
/// `semanticIndexOffset` and `semanticIndexCallback`.
///
/// See also:
///
///  * [SliverChildBuilderDelegate], which is a delegate that uses a builder
///    callback to construct the children.
class SliverChildListDelegate extends SliverChildDelegate {
  /// Creates a delegate that supplies children for slivers using the given
  /// list.
  ///
  /// The [children], [addAutomaticKeepAlives], [addRepaintBoundaries],
  /// [addSemanticIndexes], and [semanticIndexCallback] arguments must not be
  /// null.
  ///
  /// If the order of children never changes, consider using the constant
  /// [SliverChildListDelegate.fixed] constructor.
  SliverChildListDelegate(
      this.children, {
        this.addAutomaticKeepAlives = true,
        this.addRepaintBoundaries = true,
        this.addSemanticIndexes = true,
        this.semanticIndexCallback = _kDefaultSemanticIndexCallback,
        this.semanticIndexOffset = 0,
      }) : _keyToIndex = <Key?, int>{null: 0};

  /// Creates a constant version of the delegate that supplies children for
  /// slivers using the given list.
  ///
  /// If the order of the children will change, consider using the regular
  /// [SliverChildListDelegate] constructor.
  ///
  /// The [children], [addAutomaticKeepAlives], [addRepaintBoundaries],
  /// [addSemanticIndexes], and [semanticIndexCallback] arguments must not be
  /// null.
  const SliverChildListDelegate.fixed(
      this.children, {
        this.addAutomaticKeepAlives = true,
        this.addRepaintBoundaries = true,
        this.addSemanticIndexes = true,
        this.semanticIndexCallback = _kDefaultSemanticIndexCallback,
        this.semanticIndexOffset = 0,
      }) : _keyToIndex = null;

  /// {@macro flutter.widgets.SliverChildBuilderDelegate.addAutomaticKeepAlives}
  final bool addAutomaticKeepAlives;

  /// {@macro flutter.widgets.SliverChildBuilderDelegate.addRepaintBoundaries}
  final bool addRepaintBoundaries;

  /// {@macro flutter.widgets.SliverChildBuilderDelegate.addSemanticIndexes}
  final bool addSemanticIndexes;

  /// {@macro flutter.widgets.SliverChildBuilderDelegate.semanticIndexOffset}
  final int semanticIndexOffset;

  /// {@macro flutter.widgets.SliverChildBuilderDelegate.semanticIndexCallback}
  final SemanticIndexCallback semanticIndexCallback;

  /// The widgets to display.
  ///
  /// If this list is going to be mutated, it is usually wise to put a [Key] on
  /// each of the child widgets, so that the framework can match old
  /// configurations to new configurations and maintain the underlying render
  /// objects.
  ///
  /// Also, a [Widget] in Flutter is immutable, so directly modifying the
  /// [children] such as `someWidget.children.add(...)` or
  /// passing a reference of the original list value to the [children] parameter
  /// will result in incorrect behaviors. Whenever the
  /// children list is modified, a new list object must be provided.
  ///
  /// The following code corrects the problem mentioned above.
  ///
  /// ```dart
  /// class SomeWidgetState extends State<SomeWidget> {
  ///   final List<Widget> _children = <Widget>[];
  ///
  ///   void someHandler() {
  ///     setState(() {
  ///       // The key here allows Flutter to reuse the underlying render
  ///       // objects even if the children list is recreated.
  ///       _children.add(ChildWidget(key: UniqueKey()));
  ///     });
  ///   }
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     // Always create a new list of children as a Widget is immutable.
  ///     return PageView(children: List<Widget>.of(_children));
  ///   }
  /// }
  /// ```
  final List<Widget> children;

  /// A map to cache key to index lookup for children.
  ///
  /// _keyToIndex[null] is used as current index during the lazy loading process
  /// in [_findChildIndex]. _keyToIndex should never be used for looking up null key.
  final Map<Key?, int>? _keyToIndex;

  bool get _isConstantInstance => _keyToIndex == null;

  int? _findChildIndex(Key key) {
    if (_isConstantInstance) {
      return null;
    }
    // Lazily fill the [_keyToIndex].
    if (!_keyToIndex!.containsKey(key)) {
      int index = _keyToIndex![null]!;
      while (index < children.length) {
        final Widget child = children[index];
        if (child.key != null) {
          _keyToIndex![child.key] = index;
        }
        if (child.key == key) {
          // Record current index for next function call.
          _keyToIndex![null] = index + 1;
          return index;
        }
        index += 1;
      }
      _keyToIndex![null] = index;
    } else {
      return _keyToIndex![key];
    }
    return null;
  }

  @override
  int? findIndexByKey(Key key) {
    final Key childKey;
    if (key is _SaltedValueKey) {
      final _SaltedValueKey saltedValueKey = key;
      childKey = saltedValueKey.value;
    } else {
      childKey = key;
    }
    return _findChildIndex(childKey);
  }

  @override
  Widget? build(BuildContext context, int index) {
    if (index < 0 || index >= children.length) {
      return null;
    }
    Widget child = children[index];
    final Key? key = child.key != null? _SaltedValueKey(child.key!) : null;
    if (addRepaintBoundaries) {
      child = RepaintBoundary(child: child);
    }
    if (addSemanticIndexes) {
      final int? semanticIndex = semanticIndexCallback(child, index);
      if (semanticIndex != null) {
        child = IndexedSemantics(index: semanticIndex + semanticIndexOffset, child: child);
      }
    }
    if (addAutomaticKeepAlives) {
      child = AutomaticKeepAlive(child: _SelectionKeepAlive(child: child));
    }

    return KeyedSubtree(key: key, child: child);
  }

  @override
  int? get estimatedChildCount => children.length;

  @override
  bool shouldRebuild(covariant SliverChildListDelegate oldDelegate) {
    return children != oldDelegate.children;
  }
}

class _SelectionKeepAlive extends StatefulWidget {
  /// Creates a widget that listens to [KeepAliveNotification]s and maintains a
  /// [KeepAlive] widget appropriately.
  const _SelectionKeepAlive({
    required this.child,
  });

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget child;

  @override
  State<_SelectionKeepAlive> createState() => _SelectionKeepAliveState();
}

class _SelectionKeepAliveState extends State<_SelectionKeepAlive> with AutomaticKeepAliveClientMixin implements SelectionRegistrar {
  Set<Selectable>? _selectablesWithSelections;
  Map<Selectable, VoidCallback>? _selectableAttachments;
  SelectionRegistrar? _registrar;

  @override
  bool get wantKeepAlive => _wantKeepAlive;
  bool _wantKeepAlive = false;
  set wantKeepAlive(bool value) {
    if (_wantKeepAlive != value) {
      _wantKeepAlive = value;
      updateKeepAlive();
    }
  }

  VoidCallback listensTo(Selectable selectable) {
    return () {
      if (selectable.value.hasSelection) {
        _updateSelectablesWithSelections(selectable, add: true);
      } else {
        _updateSelectablesWithSelections(selectable, add: false);
      }
    };
  }

  void _updateSelectablesWithSelections(Selectable selectable, {required bool add}) {
    if (add) {
      assert(selectable.value.hasSelection);
      _selectablesWithSelections ??= <Selectable>{};
      _selectablesWithSelections!.add(selectable);
    } else {
      _selectablesWithSelections?.remove(selectable);
    }
    wantKeepAlive = _selectablesWithSelections?.isNotEmpty ?? false;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final SelectionRegistrar? newRegistrar = SelectionContainer.maybeOf(context);
    if (_registrar != newRegistrar) {
      if (_registrar != null) {
        _selectableAttachments?.keys.forEach(_registrar!.remove);
      }
      _registrar = newRegistrar;
      if (_registrar != null) {
        _selectableAttachments?.keys.forEach(_registrar!.add);
      }
    }
  }

  @override
  void add(Selectable selectable) {
    final VoidCallback attachment = listensTo(selectable);
    selectable.addListener(attachment);
    _selectableAttachments ??= <Selectable, VoidCallback>{};
    _selectableAttachments![selectable] = attachment;
    _registrar!.add(selectable);
    if (selectable.value.hasSelection) {
      _updateSelectablesWithSelections(selectable, add: true);
    }
  }

  @override
  void remove(Selectable selectable) {
    if (_selectableAttachments == null) {
      return;
    }
    assert(_selectableAttachments!.containsKey(selectable));
    final VoidCallback attachment = _selectableAttachments!.remove(selectable)!;
    selectable.removeListener(attachment);
    _registrar!.remove(selectable);
    _updateSelectablesWithSelections(selectable, add: false);
  }

  @override
  void dispose() {
    if (_selectableAttachments != null) {
      for (final Selectable selectable in _selectableAttachments!.keys) {
        _registrar!.remove(selectable);
        selectable.removeListener(_selectableAttachments![selectable]!);
      }
      _selectableAttachments = null;
    }
    _selectablesWithSelections = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_registrar == null) {
      return widget.child;
    }
    return SelectionRegistrarScope(
      registrar: this,
      child: widget.child,
    );
  }
}

// Return a Widget for the given Exception
Widget _createErrorWidget(Object exception, StackTrace stackTrace) {
  final FlutterErrorDetails details = FlutterErrorDetails(
    exception: exception,
    stack: stackTrace,
    library: 'widgets library',
    context: ErrorDescription('building'),
  );
  FlutterError.reportError(details);
  return ErrorWidget.builder(details);
}

// TODO(Piinks): Come back and add keep alive support, https://github.com/flutter/flutter/issues/126297
/// A delegate that supplies children for scrolling in two dimensions.
///
/// A [TwoDimensionalScrollView] lazily constructs its box children to avoid
/// creating more children than are visible through the
/// [TwoDimensionalViewport]. Rather than receiving children as an
/// explicit [List], it receives its children using a
/// [TwoDimensionalChildDelegate].
///
/// As a ChangeNotifier, this delegate allows subclasses to notify its listeners
/// (typically as a subclass of [RenderTwoDimensionalViewport]) to rebuild when
/// aspects of the delegate change. When values returned by getters or builders
/// on this delegate change, [notifyListeners] should be called. This signals to
/// the [RenderTwoDimensionalViewport] that the getters and builders need to be
/// re-queried to update the layout of children in the viewport.
///
/// See also:
///
///   * [TwoDimensionalChildBuilderDelegate], an concrete subclass of this that
///     lazily builds children on demand.
///   * [TwoDimensionalChildListDelegate], an concrete subclass of this that
///     uses a two dimensional array to layout children.
abstract class TwoDimensionalChildDelegate extends ChangeNotifier {
  /// Returns the child with the given [ChildVicinity], which is described in
  /// terms of x and y indices.
  ///
  /// Subclasses must implement this function and will typically wrap their
  /// children in [RepaintBoundary] widgets.
  ///
  /// The values returned by this method are cached. To indicate that the
  /// widgets have changed, a new delegate must be provided, and the new
  /// delegate's [shouldRebuild] method must return true. Alternatively,
  /// calling [notifyListeners] will allow the same delegate to be used.
  Widget? build(BuildContext context, ChildVicinity vicinity);

  /// Called whenever a new instance of the child delegate class is
  /// provided.
  ///
  /// If the new instance represents different information than the old
  /// instance, then the method should return true, otherwise it should return
  /// false.
  ///
  /// If the method returns false, then the [build] call might be optimized
  /// away.
  bool shouldRebuild(covariant TwoDimensionalChildDelegate oldDelegate);
}

/// A delegate that supplies children for a [TwoDimensionalScrollView] using a
/// builder callback.
///
/// The widgets returned from the builder callback are automatically wrapped in
/// [RepaintBoundary] widgets if [addRepaintBoundaries] is true
/// (also the default).
///
/// See also:
///
///  * [TwoDimensionalChildListDelegate], which is a similar delegate that has an
///    explicit two dimensional array of children.
///  * [SliverChildBuilderDelegate], which is a delegate that uses a builder
///    callback to construct the children in one dimension instead of two.
///  * [SliverChildListDelegate], which is a delegate that has an explicit list
///    of children in one dimension instead of two.
class TwoDimensionalChildBuilder extends TwoDimensionalChildDelegate {
  /// Creates a delegate that supplies children for a [TwoDimensionalScrollView]
  /// using the given builder callback.
  TwoDimensionalChildBuilder({
    this.addRepaintBoundaries = true,
    required this.builder,
    int? maxXIndex,
    int? maxYIndex,
  }) : assert(maxYIndex == null || maxYIndex >= 0),
        assert(maxXIndex == null || maxXIndex >= 0),
        _maxYIndex = maxYIndex,
        _maxXIndex = maxXIndex;

  /// Called to build children on demand.
  ///
  /// Implementors of [RenderTwoDimensionalViewport.layoutChildSequence]
  /// call this builder to create the children of the viewport. For
  /// [ChildVicinity] indices greater than [maxXIndex] or [maxYIndex], null will
  /// be returned by the default [build] implementation. This default behavior
  /// can be changed by overriding the build method.
  ///
  /// Must return null if asked to build a widget with a [ChildVicinity] that
  /// does not exist.
  ///
  /// The delegate wraps the children returned by this builder in
  /// [RepaintBoundary] widgets if [addRepaintBoundaries] is true.
  final TwoDimensionalIndexedWidgetBuilder builder;

  /// The maximum [ChildVicinity.xIndex] for children in the x axis.
  ///
  /// {@template flutter.widgets.twoDimensionalChildBuilderDelegate.maxIndex}
  /// For each [ChildVicinity], the child's relative location is described in
  /// terms of x and y indices to facilitate a consistent visitor pattern for
  /// all children in the viewport.
  ///
  /// This is fairly straightforward in the context of a table implementation,
  /// where there is usually the same number of columns in every row and vice
  /// versa, each aligned one after the other.
  ///
  /// When plotting children more abstractly in two dimensional space, there may
  /// be more x indices for a given y index than another y index. An example of
  /// this would be a scatter plot where there are more children at the top of
  /// the graph than at the bottom.
  ///
  /// If null, subclasses of [RenderTwoDimensionalViewport] can continue call on
  /// the [builder] until null has been returned for each known index of x and
  /// y. In some cases, null may not be a terminating result, such as a table
  /// with a merged cell spanning multiple indices. Refer to the
  /// [TwoDimensionalViewport] subclass to learn how this value is applied in
  /// the specific use case.
  ///
  /// If not null, the value must be non-negative.
  ///
  /// If the value changes, the delegate will call [notifyListeners]. This
  /// informs the [RenderTwoDimensionalViewport] that any cached information
  /// from the delegate is invalid.
  /// {@endtemplate}
  ///
  /// This value represents the greatest x index of all [ChildVicinity]s for the
  /// two dimensional scroll view.
  ///
  /// See also:
  ///
  ///   * [RenderTwoDimensionalViewport.buildOrObtainChildFor], the method that
  ///     leads to calling on the delegate to build a child of the given
  ///     [ChildVicinity].
  int? get maxXIndex => _maxXIndex;
  int? _maxXIndex;
  set maxXIndex(int? value) {
    if (value == maxXIndex) {
      return;
    }
    assert(value == null || value >= 0);
    _maxXIndex = value;
    notifyListeners();
  }

  /// The maximum [ChildVicinity.yIndex] for children in the y axis.
  ///
  /// {@macro flutter.widgets.twoDimensionalChildBuilderDelegate.maxIndex}
  ///
  /// This value represents the greatest y index of all [ChildVicinity]s for the
  /// two dimensional scroll view.
  ///
  /// See also:
  ///
  ///   * [RenderTwoDimensionalViewport.buildOrObtainChildFor], the method that
  ///     leads to calling on the delegate to build a child of the given
  ///     [ChildVicinity].
  int? get maxYIndex => _maxYIndex;
  int? _maxYIndex;
  set maxYIndex(int? value) {
    if (maxYIndex == value) {
      return;
    }
    assert(value == null || value >= 0);
    _maxYIndex = value;
    notifyListeners();
  }

  /// {@macro flutter.widgets.SliverChildBuilderDelegate.addRepaintBoundaries}
  final bool addRepaintBoundaries;

  @override
  Widget? build(BuildContext context, ChildVicinity vicinity) {
    // If we have exceeded explicit upper bounds, return null.
    if (vicinity.xIndex < 0 || (maxXIndex != null && vicinity.xIndex > maxXIndex!)) {
      return null;
    }
    if (vicinity.yIndex < 0 || (maxYIndex != null && vicinity.yIndex > maxYIndex!)) {
      return null;
    }

    Widget? child;
    try {
      child = builder(context, vicinity);
    } catch (exception, stackTrace) {
      child = _createErrorWidget(exception, stackTrace);
    }
    if (child == null) {
      return null;
    }
    if (addRepaintBoundaries) {
      child = RepaintBoundary(child: child);
    }
    return child;
  }

  @override
  bool shouldRebuild(covariant TwoDimensionalChildDelegate oldDelegate) => true;
}

/// A delegate that supplies children for a [TwoDimensionalViewport] using an
/// explicit two dimensional array.
///
/// In general, building all the widgets in advance is not efficient. It is
/// better to create a delegate that builds them on demand using
/// [TwoDimensionalChildBuilderDelegate] or by subclassing
/// [TwoDimensionalChildDelegate] directly.
///
/// This class is provided for the cases where either the list of children is
/// known well in advance (ideally the children are themselves compile-time
/// constants, for example), and therefore will not be built each time the
/// delegate itself is created, or the array is small, such that it's likely
/// always visible (and thus there is nothing to be gained by building it on
/// demand).
///
/// The widgets in the given [children] list are automatically wrapped in
/// [RepaintBoundary] widgets if [addRepaintBoundaries] is true
/// (also the default).
///
/// The [children] are accessed for each [ChildVicinity.yIndex] and
/// [ChildVicinity.xIndex] of the [TwoDimensionalViewport] as
/// `children[vicinity.yIndex][vicinity.xIndex]`.
///
/// See also:
///
///  * [TwoDimensionalChildBuilderDelegate], which is a delegate that uses a
///    builder callback to construct the children.
///  * [SliverChildBuilderDelegate], which is a delegate that uses a builder
///    callback to construct the children in one dimension instead of two.
///  * [SliverChildListDelegate], which is a delegate that has an explicit list
///    of children in one dimension instead of two.
class TwoDimensionalChildListDelegate extends TwoDimensionalChildDelegate {
  /// Creates a delegate that supplies children for a [TwoDimensionalScrollView].
  ///
  /// The [children] and [addRepaintBoundaries] must not be
  /// null.
  TwoDimensionalChildListDelegate({
    this.addRepaintBoundaries = true,
    required this.children,
  });

  /// The widgets to display.
  ///
  /// Also, a [Widget] in Flutter is immutable, so directly modifying the
  /// [children] such as `someWidget.children.add(...)` or
  /// passing a reference of the original list value to the [children] parameter
  /// will result in incorrect behaviors. Whenever the
  /// children list is modified, a new list object must be provided.
  ///
  /// The [children] are accessed for each [ChildVicinity.yIndex] and
  /// [ChildVicinity.xIndex] of the [TwoDimensionalViewport] as
  /// `children[vicinity.yIndex][vicinity.xIndex]`.
  final List<List<Widget>> children;

  /// {@macro flutter.widgets.SliverChildBuilderDelegate.addRepaintBoundaries}
  final bool addRepaintBoundaries;

  @override
  Widget? build(BuildContext context, ChildVicinity vicinity) {
    // If we have exceeded explicit upper bounds, return null.
    if (vicinity.yIndex < 0 || vicinity.yIndex >= children.length) {
      return null;
    }
    if (vicinity.xIndex < 0 || vicinity.xIndex >= children[vicinity.yIndex].length) {
      return null;
    }

    Widget child = children[vicinity.yIndex][vicinity.xIndex];
    if (addRepaintBoundaries) {
      child = RepaintBoundary(child: child);
    }

    return child;
  }

  @override
  bool shouldRebuild(covariant TwoDimensionalChildListDelegate oldDelegate) {
    return children != oldDelegate.children;
  }
}


abstract class TwoDimensionalScrollViews extends StatelessWidget {
  /// Creates a widget that scrolls in both dimensions.
  ///
  /// The [primary] argument is associated with the [mainAxis]. The main axis
  /// [ScrollableDetails.controller] must be null if [primary] is configured for
  /// that axis. If [primary] is true, the nearest [PrimaryScrollController]
  /// surrounding the widget is attached to the scroll position of that axis.
  const TwoDimensionalScrollViews({
    super.key,
    this.primary,
    this.mainAxis = Axis.vertical,
    this.verticalDetails = const ScrollableDetails.vertical(),
    this.horizontalDetails = const ScrollableDetails.horizontal(),
    required this.delegate,
    this.cacheExtent,
    this.diagonalDragBehavior = DiagonalDragBehavior.none,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.clipBehavior = Clip.hardEdge,
  });

  /// A delegate that provides the children for the [TwoDimensionalScrollView].
  final TwoDimensionalChildDelegate delegate;

  /// {@macro flutter.rendering.RenderViewportBase.cacheExtent}
  final double? cacheExtent;

  /// Whether scrolling gestures should lock to one axes, allow free movement
  /// in both axes, or be evaluated on a weighted scale.
  ///
  /// Defaults to [DiagonalDragBehavior.none], locking axes to receive input one
  /// at a time.
  final DiagonalDragBehavior diagonalDragBehavior;

  /// {@macro flutter.widgets.scroll_view.primary}
  final bool? primary;

  /// The main axis of the two.
  ///
  /// Used to determine how to apply [primary] when true.
  ///
  /// This value should also be provided to the subclass of
  /// [TwoDimensionalViewport], where it is used to determine paint order of
  /// children.
  final Axis mainAxis;

  /// The configuration of the vertical Scrollable.
  ///
  /// These [ScrollableDetails] can be used to set the [AxisDirection],
  /// [ScrollController], [ScrollPhysics] and more for the vertical axis.
  final ScrollableDetails verticalDetails;

  /// The configuration of the horizontal Scrollable.
  ///
  /// These [ScrollableDetails] can be used to set the [AxisDirection],
  /// [ScrollController], [ScrollPhysics] and more for the horizontal axis.
  final ScrollableDetails horizontalDetails;

  /// {@macro flutter.widgets.scrollable.dragStartBehavior}
  final DragStartBehavior dragStartBehavior;

  /// {@macro flutter.widgets.scroll_view.keyboardDismissBehavior}
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  /// {@macro flutter.material.Material.clipBehavior}
  ///
  /// Defaults to [Clip.hardEdge].
  final Clip clipBehavior;

  /// Build the two dimensional viewport.
  ///
  /// Subclasses may override this method to change how the viewport is built,
  /// likely a subclass of [TwoDimensionalViewport].
  ///
  /// The `verticalOffset` and `horizontalOffset` arguments are the values
  /// obtained from [TwoDimensionalScrollable.viewportBuilder].
  Widget buildViewport(
      BuildContext context,
      ViewportOffset verticalOffset,
      ViewportOffset horizontalOffset,
      );

  @override
  Widget build(BuildContext context) {
    assert(
    axisDirectionToAxis(verticalDetails.direction) == Axis.vertical,
    'TwoDimensionalScrollView.verticalDetails are not Axis.vertical.'
    );
    assert(
    axisDirectionToAxis(horizontalDetails.direction) == Axis.horizontal,
    'TwoDimensionalScrollView.horizontalDetails are not Axis.horizontal.'
    );

    ScrollableDetails mainAxisDetails = switch (mainAxis) {
      Axis.vertical => verticalDetails,
      Axis.horizontal => horizontalDetails,
    };

    final bool effectivePrimary = primary
        ?? mainAxisDetails.controller == null && PrimaryScrollController.shouldInherit(
          context,
          mainAxis,
        );

    if (effectivePrimary) {
      // Using PrimaryScrollController for mainAxis.
      assert(
      mainAxisDetails.controller == null,
      'TwoDimensionalScrollView.primary was explicitly set to true, but a '
          'ScrollController was provided in the ScrollableDetails of the '
          'TwoDimensionalScrollView.mainAxis.'
      );
      mainAxisDetails = mainAxisDetails.copyWith(
        controller: PrimaryScrollController.of(context),
      );
    }

    final TwoDimensionalScrollable scrollable = TwoDimensionalScrollable(
      horizontalDetails : switch (mainAxis) {
        Axis.horizontal => mainAxisDetails,
        Axis.vertical => horizontalDetails,
      },
      verticalDetails: switch (mainAxis) {
        Axis.vertical => mainAxisDetails,
        Axis.horizontal => verticalDetails,
      },
      diagonalDragBehavior: diagonalDragBehavior,
      viewportBuilder: buildViewport,
      dragStartBehavior: dragStartBehavior,
    );

    final Widget scrollableResult = effectivePrimary
    // Further descendant ScrollViews will not inherit the same PrimaryScrollController
        ? PrimaryScrollController.none(child: scrollable)
        : scrollable;

    if (keyboardDismissBehavior == ScrollViewKeyboardDismissBehavior.onDrag) {
      return NotificationListener<ScrollUpdateNotification>(
        child: scrollableResult,
        onNotification: (ScrollUpdateNotification notification) {
          final FocusScopeNode focusScope = FocusScope.of(context);
          if (notification.dragDetails != null && focusScope.hasFocus) {
            focusScope.unfocus();
          }
          return false;
        },
      );
    }
    return scrollableResult;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<Axis>('mainAxis', mainAxis));
    properties.add(EnumProperty<DiagonalDragBehavior>('diagonalDragBehavior', diagonalDragBehavior));
    properties.add(FlagProperty('primary', value: primary, ifTrue: 'using primary controller', showName: true));
    properties.add(DiagnosticsProperty<ScrollableDetails>('verticalDetails', verticalDetails, showName: false));
    properties.add(DiagnosticsProperty<ScrollableDetails>('horizontalDetails', horizontalDetails, showName: false));
  }
}
