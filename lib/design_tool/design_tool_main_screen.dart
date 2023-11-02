import 'dart:math' as math;

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:codeediter/design_tool/zoom_screen/zoom_widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'design_dashboard_screen.dart';

class MyAppZoom extends StatelessWidget {
  const MyAppZoom({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: Colors.blue,
        inputDecorationTheme: InputDecorationTheme(
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
      dark: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.blue,
        inputDecorationTheme: InputDecorationTheme(
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
      initial: AdaptiveThemeMode.system,
      builder: (theme, darkTheme) => MaterialApp(
          title: 'Box Transform Playground',
          debugShowCheckedModeBanner: false,
          theme: theme,
          darkTheme: darkTheme,
          home: MyHomePage()
          // home: MyDraggableBox()
          ),
    );

    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        scrollbarTheme: ScrollbarThemeData(
          // Customize the appearance of the scrollbar here.
          thumbColor: MaterialStateProperty.all(Colors.blue), // Thumb color
          radius: Radius.circular(8), // Thumb radius
          thickness: MaterialStateProperty.all(8), // Thumb thickness
        ),
      ),
      scrollBehavior: const MaterialScrollBehavior().copyWith(
          // Mouse dragging enabled for this demo
          // dragDevices: PointerDeviceKind.values.toSet(),
          ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ScrollController scrollController = ScrollController();

  ScrollController scrollController2 = ScrollController();

  final viewTransformationController = TransformationController();
  List<BoxProperties> boxes = [];
  BoxProperties? currentBox;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return
      Scrollbar(
      controller: scrollController2,
      trackVisibility: true,
      child: Scrollbar(
        controller: scrollController,
        trackVisibility: true,
        child: InteractiveViewer(
          transformationController: viewTransformationController,
          maxScale: 80,
          minScale: 0.1,
          panEnabled: false,
          scaleEnabled: true,
          child: GridPaper(
            color: Theme.of(context).brightness == Brightness.dark
                ? kGridColor.withOpacity(0.03)
                : kGridColor.withOpacity(0.1),
            child: Container(
              height: 600,

              width: 300,
              color: Colors.white,
            )
           ,
          ),
        ),
      ),
    );

    Scaffold(
      body: Scrollbar(
        controller: scrollController2,
        trackVisibility: true,
        child: Scrollbar(
          controller: scrollController,
          trackVisibility: true,
          child: InteractiveViewer(
            transformationController: viewTransformationController,
            maxScale: 10,
            minScale: 0.1,
            panEnabled: false,
            scaleEnabled: true,
            child: GridPaper(
              color: Theme.of(context).brightness == Brightness.dark
                  ? kGridColor.withOpacity(0.03)
                  : kGridColor.withOpacity(0.1),
              child: TwoDimensionalGridView(
                diagonalDragBehavior: DiagonalDragBehavior.free,
                mainAxis: Axis.horizontal,
                verticalDetails:
                    ScrollableDetails.vertical(controller: scrollController2),
                horizontalDetails:
                    ScrollableDetails.horizontal(controller: scrollController),
                width: 2500,
                height: 1500,
                delegate: TwoDimensionalChildBuilderDelegate(
                    maxXIndex: 0,
                    maxYIndex: 0,
                    addRepaintBoundaries: true,
                    builder: (BuildContext context, ChildVicinity vicinity) {
                      return GestureDetector(
                        onPanDown: (details) {
                          // Create a new box when the user taps.
                          final newBox = BoxProperties(
                            left: details.localPosition.dx,
                            top: details.localPosition.dy,
                            width: 0,
                            height: 0,
                          );
                          setState(() {
                            // if(newBox.top)
                            boxes.add(newBox);
                            currentBox = newBox;
                          });
                        },
                        onPanUpdate: (details) {
                          // Update the current box's properties as it's being dragged.
                          if (currentBox != null) {
                            setState(() {
                              currentBox!.width =
                                  details.localPosition.dx - currentBox!.left;
                              currentBox!.height =
                                  details.localPosition.dy - currentBox!.top;
                            });
                          }
                        },
                        onPanEnd: (_) {
                          // Stop dragging the current box.
                          currentBox = null;
                        },
                        child: Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              height: double.infinity,
                              color: Colors.transparent,
                            ),
                            for (var box in boxes)
                              Positioned(
                                left: box.left,
                                top: box.top,
                                child: Container(
                                  width: box.width,
                                  height: box.height,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 2.0, color: Colors.blue),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    }),
              ),
            ),
          ),
        ),
      ),
    );
    Scrollbar(
      controller: scrollController,
      trackVisibility: true,
      child: SingleChildScrollView(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        child: Scrollbar(
          controller: scrollController2,
          trackVisibility: true,
          child: SingleChildScrollView(
            controller: scrollController2,
            scrollDirection: Axis.vertical,
            child: Container(
              height: 2000,
              width: 2000,
              // color: Colors.white,
              child: GridPaper(),
            ),
          ),
        ),
      ),
    );
  }
}

class TwoDimensionalGridView extends TwoDimensionalScrollView {
  const TwoDimensionalGridView({
    super.key,
    super.primary,
    super.mainAxis = Axis.vertical,
    super.verticalDetails = const ScrollableDetails.vertical(),
    super.horizontalDetails = const ScrollableDetails.horizontal(),
    required TwoDimensionalChildBuilderDelegate delegate,
    this.width = 200,
    this.height = 200,
    super.cacheExtent,
    super.diagonalDragBehavior = DiagonalDragBehavior.none,
    super.dragStartBehavior = DragStartBehavior.start,
    super.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    super.clipBehavior = Clip.hardEdge,
  }) : super(delegate: delegate);

  final double height;
  final double width;

  @override
  Widget buildViewport(
    BuildContext context,
    ViewportOffset verticalOffset,
    ViewportOffset horizontalOffset,
  ) {
    return TwoDimensionalGridViewport(
      horizontalOffset: horizontalOffset,
      horizontalAxisDirection: horizontalDetails.direction,
      verticalOffset: verticalOffset,
      width: width,
      height: height,
      verticalAxisDirection: verticalDetails.direction,
      mainAxis: mainAxis,
      delegate: delegate as TwoDimensionalChildBuilderDelegate,
      cacheExtent: cacheExtent,
      clipBehavior: clipBehavior,
    );
  }

// @override
// Widget build(BuildContext context) {
//   return Container(
//     height: 5000,
//     width: 5000,
//     decoration:
//         BoxDecoration(
//             // color: Colors.white12 ,
//             border: Border.all(color: Colors.white, width: 5)),
//   );
//
// }
}

class TwoDimensionalGridViewport extends TwoDimensionalViewport {
  const TwoDimensionalGridViewport({
    super.key,
    required super.verticalOffset,
    required super.verticalAxisDirection,
    required super.horizontalOffset,
    required super.horizontalAxisDirection,
    required TwoDimensionalChildBuilderDelegate super.delegate,
    required super.mainAxis,
    super.cacheExtent,
    required this.width,
    required this.height,
    super.clipBehavior = Clip.hardEdge,
  });

  final double height;
  final double width;

  @override
  RenderTwoDimensionalViewport createRenderObject(BuildContext context) {
    return RenderTwoDimensionalGridViewport(
      horizontalOffset: horizontalOffset,
      horizontalAxisDirection: horizontalAxisDirection,
      verticalOffset: verticalOffset,
      verticalAxisDirection: verticalAxisDirection,
      mainAxis: mainAxis,
      height: height,
      width: width,
      delegate: delegate as TwoDimensionalChildBuilderDelegate,
      childManager: context as TwoDimensionalChildManager,
      cacheExtent: cacheExtent,
      clipBehavior: clipBehavior,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderTwoDimensionalGridViewport renderObject,
  ) {
    renderObject
      ..horizontalOffset = horizontalOffset
      ..horizontalAxisDirection = horizontalAxisDirection
      ..verticalOffset = verticalOffset
      ..verticalAxisDirection = verticalAxisDirection
      ..mainAxis = mainAxis
      ..delegate = delegate
      ..cacheExtent = cacheExtent
      ..clipBehavior = clipBehavior;
  }
}

class RenderTwoDimensionalGridViewport extends RenderTwoDimensionalViewport {
  RenderTwoDimensionalGridViewport({
    required super.horizontalOffset,
    required super.horizontalAxisDirection,
    required super.verticalOffset,
    required super.verticalAxisDirection,
    required TwoDimensionalChildBuilderDelegate delegate,
    required super.mainAxis,
    required super.childManager,
    super.cacheExtent,
    required this.width,
    required this.height,
    super.clipBehavior = Clip.hardEdge,
  }) : super(delegate: delegate);

  final double height;
  final double width;

  @override
  void layoutChildSequence() {
    final double horizontalPixels = horizontalOffset.pixels;
    final double verticalPixels = verticalOffset.pixels;
    final double viewportWidth = viewportDimension.width + cacheExtent;
    final double viewportHeight = viewportDimension.height + cacheExtent;
    final TwoDimensionalChildBuilderDelegate builderDelegate =
        delegate as TwoDimensionalChildBuilderDelegate;

    final int maxRowIndex = builderDelegate.maxYIndex!;
    final int maxColumnIndex = builderDelegate.maxXIndex!;

    final int leadingColumn = math.max((horizontalPixels / width).floor(), 0);
    final int leadingRow = math.max((verticalPixels / height).floor(), 0);
    final int trailingColumn = math.min(
      ((horizontalPixels + viewportWidth) / width).ceil(),
      maxColumnIndex,
    );
    final int trailingRow = math.min(
      ((verticalPixels + viewportHeight) / height).ceil(),
      maxRowIndex,
    );

    double xLayoutOffset = (leadingColumn * width) - horizontalOffset.pixels;
    for (int column = leadingColumn; column <= trailingColumn; column++) {
      double yLayoutOffset = (leadingRow * height) - verticalOffset.pixels;
      for (int row = leadingRow; row <= trailingRow; row++) {
        final ChildVicinity vicinity =
            ChildVicinity(xIndex: column, yIndex: row);
        final RenderBox child = buildOrObtainChildFor(vicinity)!;
        child.layout(constraints.tighten(width: width, height: height));

        // Subclasses only need to set the normalized layout offset. The super
        // class adjusts for reversed axes.
        parentDataOf(child).layoutOffset = Offset(xLayoutOffset, yLayoutOffset);
        yLayoutOffset += height;
      }
      xLayoutOffset += width;
    }

    // Set the min and max scroll extents for each axis.
    final double verticalExtent = height * (maxRowIndex + 1);
    verticalOffset.applyContentDimensions(
      0.0,
      clampDouble(
          verticalExtent - viewportDimension.height, 0.0, double.infinity),
    );
    final double horizontalExtent = width * (maxColumnIndex + 1);
    horizontalOffset.applyContentDimensions(
      0.0,
      clampDouble(
          horizontalExtent - viewportDimension.width, 0.0, double.infinity),
    );
    // Super class handles garbage collection too!
  }
}

class MyDraggableBox extends StatefulWidget {
  @override
  _MyDraggableBoxState createState() => _MyDraggableBoxState();
}

class _MyDraggableBoxState extends State<MyDraggableBox> {
  // List to store rectangular boxes.
  List<BoxProperties> boxes = [];
  BoxProperties? currentBox; // The box currently being dragged.

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Multiple Draggable Boxes Example'),
      ),
      body: GestureDetector(
        onPanDown: (details) {
          // Create a new box when the user taps.
          final newBox = BoxProperties(
            left: details.localPosition.dx,
            top: details.localPosition.dy,
            width: 0,
            height: 0,
          );

          setState(() {
            boxes.add(newBox);
            currentBox = newBox;
          });
        },
        onPanUpdate: (details) {
          // Update the current box's properties as it's being dragged.
          if (currentBox != null) {
            setState(() {
              currentBox!.width = details.localPosition.dx - currentBox!.left;
              currentBox!.height = details.localPosition.dy - currentBox!.top;
            });
          }
        },
        onPanEnd: (_) {
          // Stop dragging the current box.
          currentBox = null;
        },
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white,
            ),
            for (var box in boxes)
              Positioned(
                left: box.left,
                top: box.top,
                child: Container(
                  width: box.width,
                  height: box.height,
                  decoration: BoxDecoration(
                    border: Border.all(width: 2.0, color: Colors.blue),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class BoxProperties {
  double left;
  double top;
  double width;
  double height;

  BoxProperties({
    required this.left,
    required this.top,
    required this.width,
    required this.height,
  });
}
