// import 'dart:math';
//
// import 'package:desktop_window/desktop_window.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'demo.dart';
// import 'editer_tool/editer_tool_dashboard_screen.dart';
//
// void main() async {
//   // WidgetsFlutterBinding.ensureInitialized();
//   // await testWindowFunctions();
//   // await windowManager.setSize(Size(800, 600));
//   // if (!kIsWeb) {
//     // await DesktopWindow.setWindowSize(const Size(1440.0, 809.0));
//     // await DesktopWindow.setMinWindowSize(const Size(800.0, 600.0));
//   // }
//   // runApp(const DesignTool());
//   runApp(const MyApp());
// }
//
// Future testWindowFunctions() async {
//   Size size = await DesktopWindow.getWindowSize();
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       debugShowCheckedModeBanner: false,
//       darkTheme: ThemeData.dark(),
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       // home: MyRectangularBox(),
//       home: MyRectangularBoxs(),
//     );
//   }
// }




///

import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:codeediter/src/controllers/controllers.dart';
import 'package:codeediter/src/extensions/extensions.dart';
import 'package:codeediter/src/views/views.dart';
import 'package:codeediter/start_screen.dart';
import 'package:codeediter/template_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_painter_v2/flutter_painter.dart';

import 'dart:ui' as ui;

import 'demo.dart';
import 'design_tool/design_dashboard_screen.dart';
import 'design_tool/design_tool_main_screen.dart';
import 'drag_content.dart';
import 'editer_tool/editer_tool_dashboard_screen.dart';
import 'editer_tool/models/line_properties.dart';
import 'new prod/new_resizer.dart';
import 'new_project.dart';
import 'utils/enum.dart';


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Flutter Painter Example",
      theme: ThemeData(
          primaryColor: Colors.brown, ),
      // home:  MyRectangularBox(),
      home:  MyRectangularBoxs(),
      // home:   DraggableContainerScreen(),
      // home:  StartScreen()
    );
  }
}

class FlutterPainterExample extends StatefulWidget {
  const FlutterPainterExample({Key? key}) : super(key: key);

  @override
  _FlutterPainterExampleState createState() => _FlutterPainterExampleState();
}
class _FlutterPainterExampleState extends State<FlutterPainterExample> {
  static const Color red = Color(0xFFFF0000);
  FocusNode textFocusNode = FocusNode();
  late PainterController controller;
  ui.Image? backgroundImage;
  Paint shapePaint = Paint()
    ..strokeWidth = 5
    ..color = Colors.red
    ..style = PaintingStyle.stroke
    // ..strokeCap = StrokeCap.round
  ;

  static const List<String> imageLinks = [
    "https://i.imgur.com/btoI5OX.png",
    "https://i.imgur.com/EXTQFt7.png",
    "https://i.imgur.com/EDNjJYL.png",
    "https://i.imgur.com/uQKD6NL.png",
    "https://i.imgur.com/cMqVRbl.png",
    "https://i.imgur.com/1cJBAfI.png",
    "https://i.imgur.com/eNYfHKL.png",
    "https://i.imgur.com/c4Ag5yt.png",
    "https://i.imgur.com/GhpCJuf.png",
    "https://i.imgur.com/XVMeluF.png",
    "https://i.imgur.com/mt2yO6Z.png",
    "https://i.imgur.com/rw9XP1X.png",
    "https://i.imgur.com/pD7foZ8.png",
    "https://i.imgur.com/13Y3vp2.png",
    "https://i.imgur.com/ojv3yw1.png",
    "https://i.imgur.com/f8ZNJJ7.png",
    "https://i.imgur.com/BiYkHzw.png",
    "https://i.imgur.com/snJOcEz.png",
    "https://i.imgur.com/b61cnhi.png",
    "https://i.imgur.com/FkDFzYe.png",
    "https://i.imgur.com/P310x7d.png",
    "https://i.imgur.com/5AHZpua.png",
    "https://i.imgur.com/tmvJY4r.png",
    "https://i.imgur.com/PdVfGkV.png",
    "https://i.imgur.com/1PRzwBf.png",
    "https://i.imgur.com/VeeMfBS.png",
  ];

  @override
  void initState() {
    super.initState();
    controller = PainterController(
        settings: PainterSettings(
            text: TextSettings(
              focusNode: textFocusNode,
              textStyle: const TextStyle(
                  fontWeight: FontWeight.bold, color: red, fontSize: 18),
            ),
            freeStyle: const FreeStyleSettings(
              color: red,
              strokeWidth: 5,
            ),
            shape: ShapeSettings(
              paint: shapePaint,
            ),
            scale: const ScaleSettings(
              enabled: true,
              minScale: 1,
              maxScale: 5,
            )));
    // Listen to focus events of the text field
    textFocusNode.addListener(onFocus);
    // Initialize background
    initBackground();
  }

  /// Fetches image from an [ImageProvider] (in this example, [NetworkImage])
  /// to use it as a background
  void initBackground() async {
    // Extension getter (.image) to get [ui.Image] from [ImageProvider]
    final image =
    await const NetworkImage('https://picsum.photos/1920/1080/').image;

    setState(() {
      backgroundImage = image;
      controller.background = image.backgroundDrawable;
    });
  }

  /// Updates UI when the focus changes
  void onFocus() {
    setState(() {});
  }

  Widget buildDefault(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size(double.infinity, kToolbarHeight),
          // Listen to the controller and update the UI when it updates.
          child: ValueListenableBuilder<PainterControllerValue>(
              valueListenable: controller,
              child: const Text("Flutter Painter Example"),
              builder: (context, _, child) {
                return AppBar(
                  title: child,
                  actions: [
                    // Delete the selected drawable
                    IconButton(
                      icon: const Icon(
                        Icons.abc,
                      ),
                      onPressed: controller.selectedObjectDrawable == null
                          ? null
                          : removeSelectedDrawable,
                    ),
                    // Delete the selected drawable
                    IconButton(
                      icon: const Icon(
                        Icons.flip,
                      ),
                      onPressed: controller.selectedObjectDrawable != null &&
                          controller.selectedObjectDrawable is ImageDrawable
                          ? flipSelectedImageDrawable
                          : null,
                    ),
                    // Redo action
                    IconButton(
                      icon: const Icon(
                        Icons.abc,
                      ),
                      onPressed: controller.canRedo ? redo : null,
                    ),
                    // Undo action
                    IconButton(
                      icon: const Icon(
                        Icons.abc,
                      ),
                      onPressed: controller.canUndo ? undo : null,
                    ),
                  ],
                );
              }),
        ),
        // Generate image
        floatingActionButton: FloatingActionButton(
          child: const Icon(
            Icons.abc,
          ),
          onPressed: renderAndDisplayImage,
        ),
        body: Stack(
          children: [
            if (backgroundImage != null)
            // Enforces constraints

              Positioned.fill(
                child: Center(
                  child: AspectRatio(
                    aspectRatio: backgroundImage!.width / backgroundImage!.height,
                    child: FlutterPainter(
                      controller: controller,
                    ),
                  ),
                ),
              ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: ValueListenableBuilder(
                valueListenable: controller,
                builder: (context, _, __) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Container(
                        constraints: const BoxConstraints(
                          maxWidth: 400,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: const BoxDecoration(
                          borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                          color: Colors.white54,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (controller.freeStyleMode !=
                                FreeStyleMode.none) ...[
                              const Divider(),
                              const Text("Free Style Settings"),
                              // Control free style stroke width
                              Row(
                                children: [
                                  const Expanded(
                                      flex: 1, child: Text("Stroke Width")),
                                  Expanded(
                                    flex: 3,
                                    child: Slider.adaptive(
                                        min: 2,
                                        max: 25,
                                        value: controller.freeStyleStrokeWidth,
                                        onChanged: setFreeStyleStrokeWidth),
                                  ),
                                ],
                              ),
                              if (controller.freeStyleMode ==
                                  FreeStyleMode.draw)
                                Row(
                                  children: [
                                    const Expanded(
                                        flex: 1, child: Text("Color")),
                                    // Control free style color hue
                                    Expanded(
                                      flex: 3,
                                      child: Slider.adaptive(
                                          min: 0,
                                          max: 359.99,
                                          value: HSVColor.fromColor(
                                              controller.freeStyleColor)
                                              .hue,
                                          activeColor:
                                          controller.freeStyleColor,
                                          onChanged: setFreeStyleColor),
                                    ),
                                  ],
                                ),
                            ],
                            if (textFocusNode.hasFocus) ...[
                              const Divider(),
                              const Text("Text settings"),
                              // Control text font size
                              Row(
                                children: [
                                  const Expanded(
                                      flex: 1, child: Text("Font Size")),
                                  Expanded(
                                    flex: 3,
                                    child: Slider.adaptive(
                                        min: 8,
                                        max: 96,
                                        value:
                                        controller.textStyle.fontSize ?? 14,
                                        onChanged: setTextFontSize),
                                  ),
                                ],
                              ),

                              // Control text color hue
                              Row(
                                children: [
                                  const Expanded(flex: 1, child: Text("Color")),
                                  Expanded(
                                    flex: 3,
                                    child: Slider.adaptive(
                                        min: 0,
                                        max: 359.99,
                                        value: HSVColor.fromColor(
                                            controller.textStyle.color ??
                                                red)
                                            .hue,
                                        activeColor: controller.textStyle.color,
                                        onChanged: setTextColor),
                                  ),
                                ],
                              ),
                            ],
                            if (controller.shapeFactory != null) ...[
                              const Divider(),
                              const Text("Shape Settings"),

                              // Control text color hue
                              Row(
                                children: [
                                  const Expanded(
                                      flex: 1, child: Text("Stroke Width")),
                                  Expanded(
                                    flex: 3,
                                    child: Slider.adaptive(
                                        min: 2,
                                        max: 25,
                                        value: controller
                                            .shapePaint?.strokeWidth ??
                                            shapePaint.strokeWidth,
                                        onChanged: (value) =>
                                            setShapeFactoryPaint(
                                                (controller.shapePaint ??
                                                    shapePaint)
                                                    .copyWith(
                                                  strokeWidth: value,
                                                ))),
                                  ),
                                ],
                              ),

                              // Control shape color hue
                              Row(
                                children: [
                                  const Expanded(flex: 1, child: Text("Color")),
                                  Expanded(
                                    flex: 3,
                                    child: Slider.adaptive(
                                        min: 0,
                                        max: 359.99,
                                        value: HSVColor.fromColor(
                                            (controller.shapePaint ??
                                                shapePaint)
                                                .color)
                                            .hue,
                                        activeColor: (controller.shapePaint ??
                                            shapePaint)
                                            .color,
                                        onChanged: (hue) =>
                                            setShapeFactoryPaint(
                                                (controller.shapePaint ??
                                                    shapePaint)
                                                    .copyWith(
                                                  color: HSVColor.fromAHSV(
                                                      1, hue, 1, 1)
                                                      .toColor(),
                                                ))),
                                  ),
                                ],
                              ),

                              Row(
                                children: [
                                  const Expanded(
                                      flex: 1, child: Text("Fill shape")),
                                  Expanded(
                                    flex: 3,
                                    child: Center(
                                      child: Switch(
                                          value: (controller.shapePaint ??
                                              shapePaint)
                                              .style ==
                                              PaintingStyle.fill,
                                          onChanged: (value) =>
                                              setShapeFactoryPaint(
                                                  (controller.shapePaint ??
                                                      shapePaint)
                                                      .copyWith(
                                                    style: value
                                                        ? PaintingStyle.fill
                                                        : PaintingStyle.stroke,
                                                  ))),
                                    ),
                                  ),
                                ],
                              ),
                            ]
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: ValueListenableBuilder(
          valueListenable: controller,
          builder: (context, _, __) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Free-style eraser
              IconButton(
                icon: Icon(
                  Icons.ac_unit_rounded,
                  color: controller.freeStyleMode == FreeStyleMode.erase
                      ? Theme.of(context).canvasColor
                      : null,
                ),
                onPressed: toggleFreeStyleErase,
              ),
              // Free-style drawing
              IconButton(
                icon: Icon(
                  Icons.abc,
                  color: controller.freeStyleMode == FreeStyleMode.draw
                      ? Theme.of(context).canvasColor
                      : null,
                ),
                onPressed: toggleFreeStyleDraw,
              ),
              // Add text
              IconButton(
                icon: Icon(
                  Icons.text_decrease,
                  color: textFocusNode.hasFocus
                      ? Theme.of(context).canvasColor
                      : null,
                ),
                onPressed: addText,
              ),
              // Add sticker image
              IconButton(
                icon: const Icon(
                  Icons.add,
                ),
                onPressed: addSticker,
              ),
              // Add shapes
              if (controller.shapeFactory == null)
                PopupMenuButton<ShapeFactory?>(
                  tooltip: "Add shape",
                  itemBuilder: (context) => <ShapeFactory, String>{
                    LineFactory(): "Line",
                    ArrowFactory(): "Arrow",
                    DoubleArrowFactory(): "Double Arrow",
                    RectangleFactory(): "Rectangle",
                    OvalFactory(): "Oval",
                  }
                      .entries
                      .map((e) => PopupMenuItem(
                      value: e.key,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            getShapeIcon(e.key),
                            color: Colors.black,
                          ),
                          Text(" ${e.value}")
                        ],
                      )))
                      .toList(),
                  onSelected: selectShape,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      getShapeIcon(controller.shapeFactory),
                      color: controller.shapeFactory != null
                          ? Theme.of(context).canvasColor
                          : null,
                    ),
                  ),
                )
              else
                IconButton(
                  icon: Icon(
                    getShapeIcon(controller.shapeFactory),
                    color: Theme.of(context).canvasColor,
                  ),
                  onPressed: () => selectShape(null),
                ),
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return buildDefault(context);
  }

  static IconData getShapeIcon(ShapeFactory? shapeFactory) {
    // if (shapeFactory is LineFactory) return PhosphorIcons.lineSegment;
    // if (shapeFactory is ArrowFactory) return PhosphorIcons.arrowUpRight;
    // if (shapeFactory is DoubleArrowFactory) {
    //   return PhosphorIcons.arrowsHorizontal;
    // }
    // if (shapeFactory is RectangleFactory) return PhosphorIcons.rectangle;
    // if (shapeFactory is OvalFactory) return PhosphorIcons.circle;
    return Icons.polyline;
  }

  void undo() {
    controller.undo();
  }

  void redo() {
    controller.redo();
  }

  void toggleFreeStyleDraw() {
    controller.freeStyleMode = controller.freeStyleMode != FreeStyleMode.draw
        ? FreeStyleMode.draw
        : FreeStyleMode.none;
  }

  void toggleFreeStyleErase() {
    controller.freeStyleMode = controller.freeStyleMode != FreeStyleMode.erase
        ? FreeStyleMode.erase
        : FreeStyleMode.none;
  }

  void addText() {
    if (controller.freeStyleMode != FreeStyleMode.none) {
      controller.freeStyleMode = FreeStyleMode.none;
    }
    controller.addText();
  }

  void addSticker() async {
    final imageLink = await showDialog<String>(
        context: context,
        builder: (context) => const SelectStickerImageDialog(
          imagesLinks: imageLinks,
        ));
    if (imageLink == null) return;
    controller.addImage(
        await NetworkImage(imageLink).image, const Size(100, 100));
  }

  void setFreeStyleStrokeWidth(double value) {
    controller.freeStyleStrokeWidth = value;
  }

  void setFreeStyleColor(double hue) {
    controller.freeStyleColor = HSVColor.fromAHSV(1, hue, 1, 1).toColor();
  }

  void setTextFontSize(double size) {
    // Set state is just to update the current UI, the [FlutterPainter] UI updates without it
    setState(() {
      controller.textSettings = controller.textSettings.copyWith(
          textStyle:
          controller.textSettings.textStyle.copyWith(fontSize: size));
    });
  }

  void setShapeFactoryPaint(Paint paint) {
    // Set state is just to update the current UI, the [FlutterPainter] UI updates without it
    setState(() {
      controller.shapePaint = paint;
    });
  }

  void setTextColor(double hue) {
    controller.textStyle = controller.textStyle
        .copyWith(color: HSVColor.fromAHSV(1, hue, 1, 1).toColor());
  }

  void selectShape(ShapeFactory? factory) {
    controller.shapeFactory = factory;
  }

  void renderAndDisplayImage() {
    if (backgroundImage == null) return;
    final backgroundImageSize = Size(
        backgroundImage!.width.toDouble(), backgroundImage!.height.toDouble());

    // Render the image
    // Returns a [ui.Image] object, convert to to byte data and then to Uint8List
    final imageFuture = controller
        .renderImage(backgroundImageSize)
        .then<Uint8List?>((ui.Image image) => image.pngBytes);

    // From here, you can write the PNG image data a file or do whatever you want with it
    // For example:
    // ```dart
    // final file = File('${(await getTemporaryDirectory()).path}/img.png');
    // await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    // ```
    // I am going to display it using Image.memory

    // Show a dialog with the image
    showDialog(
        context: context,
        builder: (context) => RenderedImageDialog(imageFuture: imageFuture));
  }

  void removeSelectedDrawable() {
    final selectedDrawable = controller.selectedObjectDrawable;
    if (selectedDrawable != null) controller.removeDrawable(selectedDrawable);
  }

  void flipSelectedImageDrawable() {
    final imageDrawable = controller.selectedObjectDrawable;
    if (imageDrawable is! ImageDrawable) return;

    controller.replaceDrawable(
        imageDrawable, imageDrawable.copyWith(flipped: !imageDrawable.flipped));
  }
}
class RenderedImageDialog extends StatelessWidget {
  final Future<Uint8List?> imageFuture;

  const RenderedImageDialog({Key? key, required this.imageFuture})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Rendered Image"),
      content: FutureBuilder<Uint8List?>(
        future: imageFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const SizedBox(
              height: 50,
              child: Center(child: CircularProgressIndicator.adaptive()),
            );
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const SizedBox();
          }
          return InteractiveViewer(
              maxScale: 10, child: Image.memory(snapshot.data!));
        },
      ),
    );
  }
}
class SelectStickerImageDialog extends StatelessWidget {
  final List<String> imagesLinks;

  const SelectStickerImageDialog({Key? key, this.imagesLinks = const []})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Select sticker"),
      content: imagesLinks.isEmpty
          ? const Text("No images")
          : FractionallySizedBox(
        heightFactor: 0.5,
        child: SingleChildScrollView(
          child: Wrap(
            children: [
              for (final imageLink in imagesLinks)
                InkWell(
                  onTap: () => Navigator.pop(context, imageLink),
                  child: FractionallySizedBox(
                    widthFactor: 1 / 4,
                    child: Image.network(imageLink),
                  ),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: const Text("Cancel"),
          onPressed: () => Navigator.pop(context),
        )
      ],
    );
  }
}
///
// class BoxProperties {
//   double left;
//   double top;
//   double width;
//   double height;
//   bool isSelected;
//   bool isDragAble;
//   Offset dragOffset;
//
//   BoxProperties({
//     required this.left,
//     required this.top,
//     required this.width,
//     required this.height,
//     this.isSelected = false,
//     this.isDragAble = false,
//     this.dragOffset = const Offset(0, 0),
//   });
//
//   @override
//   String toString() {
//     return 'BoxProperties{left: $left, top: $top, width: $width, height: $height}';
//   }
// }
//
// class ResizableBoxPainter extends CustomPainter {
//   final BoxProperties box;
//   final Size screenSize;
//   final double handleSize = 5.0; // Size of the handles
//
//   ResizableBoxPainter({required this.box, required this.screenSize});
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final rect = Rect.fromLTWH(box.left, box.top, box.width, box.height);
//
//     final fillPaint = Paint()
//       ..color = Colors.white24
//       ..style = PaintingStyle.fill;
//
//     final strokePaint = Paint()
//       ..color = Colors.blue
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 2.0;
//
//     // Draw the resizable box
//     canvas.drawRect(rect, fillPaint);
//     canvas.drawRect(rect, strokePaint);
//
//     // Draw a circle in the center of the box
//     final centerX = box.left + box.width / 2;
//     final centerY = box.top + box.height / 2;
//     final radius = 2.0; // Size of the circle
//     // final circlePaint = Paint()
//     //   ..color = Colors.red
//     //   ..style = PaintingStyle.fill;
//     // canvas.drawCircle(Offset(centerX, centerY), radius, circlePaint);
//
//     // Draw lines from the circle to the edges of the screen
//     final linePaint = Paint()
//       ..color = Colors.transparent
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 2.0;
//
//     //  Bottom line
//     canvas.drawLine(Offset(centerX, centerY + radius),
//         Offset(centerX, box.top + box.height), linePaint);
//
//     //  Right line
//     canvas.drawLine(Offset(centerX + radius, centerY),
//         Offset(box.left + box.width, centerY), linePaint);
//
//     // Top line
//     canvas.drawLine(Offset(centerX, centerY),
//         Offset(centerX, screenSize.height), linePaint);
//     canvas.drawLine(Offset(centerX, centerY), Offset(centerX, 0), linePaint);
//
//     // Left line
//     canvas.drawLine(Offset(centerX, centerY), Offset(0, centerY), linePaint);
//     canvas.drawLine(
//         Offset(centerX, centerY), Offset(screenSize.width, centerY), linePaint);
//
//     // Draw handles at each corner
//     drawHandles(canvas, box.left, box.top, size.width, size.height); // Top-left
//     drawHandles(canvas, box.left + box.width, box.top, size.width,
//         size.height); // Top-right
//     drawHandles(canvas, box.left, box.top + box.height, size.width,
//         size.height); // Bottom-left
//     drawHandles(canvas, box.left + box.width, box.top + box.height, size.width,
//         size.height); // Bottom-right
//   }
//
//   void drawHandles(Canvas canvas, double x, double y, double screenWidth,
//       double screenHeight) {
//     final paint = Paint()
//       ..color = Colors.blue
//       ..style = PaintingStyle.fill;
//
//     final linePaint = Paint()
//       ..color = Colors.transparent
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 0.5;
//
//     // Draw a circular handle at the specified position
//
//     // Lines for all four sides of the box
//     // canvas.drawLine(Offset(x, y - handleSize), Offset(x, y + handleSize), linePaint); // Vertical line (top to bottom)
//     // canvas.drawLine(Offset(x - handleSize, y), Offset(x + handleSize, y), linePaint); // Horizontal line (left to right)
//
//     // Lines from the circle to the edges of the screen
//
//     canvas.drawLine(Offset(x, y - handleSize), Offset(x, screenSize.height),
//         linePaint); // Top line
//     canvas.drawLine(Offset(x, y + handleSize), Offset(x, screenHeight),
//         linePaint); // Bottom line
//     canvas.drawLine(Offset(x - handleSize, y), Offset(screenSize.width, y),
//         linePaint); // Left line
//     canvas.drawLine(Offset(x + handleSize, y), Offset(screenWidth, y),
//         linePaint); // Right line
//     canvas.drawCircle(Offset(x, y), handleSize, paint);
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return false;
//   }
// }
//
// class ResizableBoxPainter2 extends CustomPainter {
//   final BoxProperties box;
//   final Size screenSize;
//   final double handleSize = 5.0; // Size of the handles
//
//   ResizableBoxPainter2({required this.box, required this.screenSize});
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final rect = Rect.fromLTWH(box.left, box.top, box.width, box.height);
//
//     final fillPaint = Paint()
//       ..color = Colors.blueAccent.withOpacity(0.2)
//       ..style = PaintingStyle.fill;
//
//     final strokePaint = Paint()
//       ..color = Colors.blueAccent
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 1.0;
//
//     // Draw the resizable box
//     canvas.drawRect(rect, fillPaint);
//     canvas.drawRect(rect, strokePaint);
//
//     // Draw a circle in the center of the box
//     final centerX = box.left + box.width / 2;
//     final centerY = box.top + box.height / 2;
//     final radius = 2.0; // Size of the circle
//     // final circlePaint = Paint()
//     //   ..color = Colors.red
//     //   ..style = PaintingStyle.fill;
//     // canvas.drawCircle(Offset(centerX, centerY), radius, circlePaint);
//
//     // Draw lines from the circle to the edges of the screen
//     final linePaint = Paint()
//       ..color = Colors.transparent
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 2.0;
//
//     //  Bottom line
//     canvas.drawLine(Offset(centerX, centerY + radius),
//         Offset(centerX, box.top + box.height), linePaint);
//
//     //  Right line
//     canvas.drawLine(Offset(centerX + radius, centerY),
//         Offset(box.left + box.width, centerY), linePaint);
//
//     // Top line
//     canvas.drawLine(Offset(centerX, centerY),
//         Offset(centerX, screenSize.height), linePaint);
//     canvas.drawLine(Offset(centerX, centerY), Offset(centerX, 0), linePaint);
//
//     // Left line
//     canvas.drawLine(Offset(centerX, centerY), Offset(0, centerY), linePaint);
//     canvas.drawLine(
//         Offset(centerX, centerY), Offset(screenSize.width, centerY), linePaint);
//
//     // Draw handles at each corner
//     drawHandles(canvas, box.left, box.top, size.width, size.height); // Top-left
//     drawHandles(canvas, box.left + box.width, box.top, size.width,
//         size.height); // Top-right
//     drawHandles(canvas, box.left, box.top + box.height, size.width,
//         size.height); // Bottom-left
//     drawHandles(canvas, box.left + box.width, box.top + box.height, size.width,
//         size.height); // Bottom-right
//   }
//
//   void drawHandles(Canvas canvas, double x, double y, double screenWidth,
//       double screenHeight) {
//     final paint = Paint()
//       ..color = Colors.blue
//       ..style = PaintingStyle.fill;
//
//     final linePaint = Paint()
//       ..color = Colors.transparent
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 0.5;
//
//     // Draw a circular handle at the specified position
//
//     // Lines for all four sides of the box
//     // canvas.drawLine(Offset(x, y - handleSize), Offset(x, y + handleSize), linePaint); // Vertical line (top to bottom)
//     // canvas.drawLine(Offset(x - handleSize, y), Offset(x + handleSize, y), linePaint); // Horizontal line (left to right)
//
//     // Lines from the circle to the edges of the screen
//
//     canvas.drawLine(Offset(x, y - handleSize), Offset(x, screenSize.height),
//         linePaint); // Top line
//     canvas.drawLine(Offset(x, y + handleSize), Offset(x, screenHeight),
//         linePaint); // Bottom line
//     canvas.drawLine(Offset(x - handleSize, y), Offset(screenSize.width, y),
//         linePaint); // Left line
//     canvas.drawLine(Offset(x + handleSize, y), Offset(screenWidth, y),
//         linePaint); // Right line
//     // canvas.drawCircle(Offset(x, y), handleSize, paint);
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return false;
//   }
// }
//
// class ScreenZoom extends StatefulWidget {
//   const ScreenZoom({Key? key}) : super(key: key);
//
//   @override
//   _ScreenZoomState createState() => _ScreenZoomState();
// }
//
// class _ScreenZoomState extends State<ScreenZoom> {
//   List<BoxProperties> boxes = [];
//   BoxProperties? currentBox;
//   Offset? startDragOffset;
//   BoxProperties? tempBox;
//   bool isCreateBox = false;
//   Offset position = Offset(100, 100);
//   bool isDragging = true;
//   Offset dragOffset = Offset(0, 0);
//
//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     return Scaffold(
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Stack(
//             children: [
//               GestureDetector(
//                 onTap: () {},
//                 onPanDown: (details) {
//                   if (isCreateBox) {
//                     final newBox = BoxProperties(
//                       left: details.localPosition.dx,
//                       top: details.localPosition.dy,
//                       width: 0,
//                       height: 0,
//                     );
//                     setState(() {
//                       boxes.add(newBox);
//                       currentBox = newBox;
//                       startDragOffset = details.localPosition;
//                       tempBox = newBox; // Initialize tempBox
//                     });
//                   } else {
//                     // print("object");
//                   }
//                 },
//                 onPanUpdate: (details) {
//                   if (isCreateBox) {
//                     if (currentBox != null) {
//                       final newWidth =
//                           details.localPosition.dx - currentBox!.left;
//                       final newHeight =
//                           details.localPosition.dy - currentBox!.top;
//
//                       if (newWidth >= 0 && newHeight >= 0) {
//                         setState(() {
//                           currentBox!.width = newWidth;
//                           currentBox!.height = newHeight;
//                         });
//                       }
//                     }
//                     // Update tempBox to show the box while dragging.
//                     if (tempBox != null) {
//                       tempBox!.width =
//                           details.localPosition.dx - startDragOffset!.dx;
//                       tempBox!.height =
//                           details.localPosition.dy - startDragOffset!.dy;
//                     }
//                   } else {
//                     setState(() {});
//                     print("sjsjs");
//                   }
//                 },
//                 onPanEnd: (_) {
//                   if (isCreateBox) {
//                     currentBox = null;
//                     tempBox = null;
//                     setState(() {});
//                   } else {}
//                 },
//               ),
//               for (var box in boxes)
//                 Positioned(
//                   left: box.left,
//                   top: box.top,
//                   child:
//                   Container(
//                     width: box.width.abs(),
//                     height: box.height.abs(),
//                     decoration: BoxDecoration(
//                       // color: Colors.white,
//                       border: Border.all(width: 2.0, color: Colors.blue),
//                     ),
//
//                   ),
//                 ),
//                 // CustomPaint(
//                 //   painter: ResizableBoxPainter(box: box, screenSize: size),
//                 //   // painter: PinkRectanglePainter(box: box, screenSize: size),
//                 // ),
//               // if (tempBox != null)
//               //   CustomPaint(
//               //     painter: ResizableBoxPainter(box: tempBox!, screenSize: size),
//               //   ),
//               // if (tempBox != null)
//               //   Positioned(
//               //     left: tempBox!.left,
//               //     top: tempBox!.top,
//               //     child: CustomPaint(
//               //       isComplex: true,
//               //       willChange: true,
//               //       painter:
//               //           ResizableBoxPainter(box: tempBox!, screenSize: size),
//               //     ),
//               //   ),
//             ],
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           setState(() {
//             isCreateBox = !isCreateBox;
//             isDragging = !isDragging;
//           });
//         },
//         child: Icon(!isCreateBox ? Icons.play_arrow_sharp : Icons.pause),
//       ),
//     );
//   }
// }


//
// class MyRectangularBox extends StatefulWidget {
//   @override
//   _MyRectangularBoxState createState() => _MyRectangularBoxState();
// }
//
// class _MyRectangularBoxState extends State<MyRectangularBox> {
//   List<BoxProperties> boxes = [];
//   BoxProperties? currentBox;
//   Offset? startDragOffset;
//   BoxProperties? tempBox;
//   bool isCreateBox = false;
//   Offset position = Offset(0, 0);
//   bool isDragging = true;
//
//   // Offset dragOffset = Offset(0, 0);
// var box= BoxData(
//   name: 'Box 1',
//   imageAsset: Images.image1,
//   rect: Rect.fromLTWH(
//     (1000 - kInitialWidth) / 2,
//     (1000 - kInitialHeight) / 2,
//     kInitialWidth,
//     kInitialHeight,
//   ),
//   flip: Flip.none,
//   constraintsEnabled: true,
//   constraints: const BoxConstraints(
//     minWidth: 10,
//     minHeight: 10,
//     maxWidth: 500,
//     maxHeight: 500,
//   ),
// );
//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     // print(boxes[0].toString());
//     return Scaffold(
//       // appBar: AppBar(
//       //   title: Text('Draggable and Resizable Box'),
//       // ),
//       body: SizedBox(
//         height: 1000,
//         width: 5000,
//         child:  Stack(
//           children: [
//             TransformableBox(
//               rect: box.rect,
//               flip: box.flip,
//               onDragUpdate: (v,c){
//                 setState(() {
//
//                 });
//               },
//               onResizeUpdate: (d,c){
//                 setState(() {
//
//                 });
//               },
//               onDragEnd: (d){
//                 setState(() {
//
//                 });
//               },
//               // clampingRect: model.clampingEnabled ? model.clampingRect : null,
//               // constraints: box.constraintsEnabled ? box.constraints : null,
//               // onChanged: (result, event) {
//               //   widget.onChanged?.call(result);
//               //   largestClampingBox = result.largestRect;
//               //   setState(() {});
//               //   lastResult = result;
//               //   model.onRectChanged(result);
//               // },
//               // resizable: widget.selected && box.resizable,
//               // visibleHandles:
//               // !widget.selected || !box.resizable ? {} : box.visibleHandles,
//               // enabledHandles:
//               // !widget.selected || !box.resizable ? {} : box.enabledHandles,
//               // draggable: widget.selected && box.draggable,
//               // allowContentFlipping: box.flipChild,
//               // allowFlippingWhileResizing: box.flipRectWhileResizing,
//               cornerHandleBuilder: (context, handle) => AngularHandle(
//                 handle: handle,
//                 color: Colors.red,
//                 hasShadow: false,
//               ),
//               sideHandleBuilder: (context, handle) => AngularHandle(
//                 handle: handle,
//                 color: Colors.red,
//                 hasShadow: false,
//               ),
//
//               // onResizeStart: (handle, event) {
//               //   if (!showTestRecorder || !recorder.isRecording) return;
//               //
//               //   log('Recording resize action');
//               //   currentAction = recorder.onAction(
//               //     resizeMode: currentResizeMode,
//               //     flip: box.flip,
//               //     rect: box.rect,
//               //     handle: handle,
//               //     cursorPosition: event.localPosition,
//               //     clampingRect: model.clampingEnabled ? model.clampingRect : null,
//               //     constraints: box.constraintsEnabled ? box.constraints : null,
//               //     flipRect: box.flipRectWhileResizing,
//               //   );
//               // },
//               // onResizeEnd: (handle, event) {
//               //   if (!showTestRecorder ||
//               //       currentAction == null ||
//               //       !recorder.isRecording ||
//               //       lastResult == null) {
//               //     return;
//               //   }
//               //   log('Recording resize action result');
//               //   // recorder.onResult(
//               //   //   action: currentAction!,
//               //   //   result: lastResult!,
//               //   //   localPosition: event.localPosition,
//               //   // );
//               // },
//               // onTerminalSizeReached: (
//               //     bool reachedMinWidth,
//               //     bool reachedMaxWidth,
//               //     bool reachedMinHeight,
//               //     bool reachedMaxHeight,
//               //     ) {
//               //   if (minWidthReached == reachedMinWidth &&
//               //       minHeightReached == reachedMinHeight &&
//               //       maxWidthReached == reachedMaxWidth &&
//               //       maxHeightReached == reachedMaxHeight) return;
//               //
//               //   setState(() {
//               //     minWidthReached = reachedMinWidth;
//               //     minHeightReached = reachedMinHeight;
//               //     maxWidthReached = reachedMaxWidth;
//               //     maxHeightReached = reachedMaxHeight;
//               //   });
//               // },
//               contentBuilder: (context, rect, flip) => GestureDetector(
//                 behavior: HitTestBehavior.translucent,
//                 onTap: () {
//                   setState(() {});
//
//                 },
//                 child:
//                 Container(
//                   width: rect.width,
//                   height: rect.height,
//                   decoration: BoxDecoration(
//                     color: Colors.white24,
//                     // shape: BoxShape.circle,
//                     //   border: Border.all(color: Colors.red)
//                     // borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),)
//                     // image: DecorationImage(
//                     //   image: AssetImage(box.imageAsset),
//                     //   fit: BoxFit.fill,
//                     // ),
//                   ),
//                   // child: CustomPaint(
//                   //   size: Size(rect.width, rect.height),
//                   //   // Set the size of the rectangle
//                   //   // painter: PinkRectanglePainter(),
//                   //   painter: PinkRectanglePainter(
//                   //       box: BoxProperties(    height: rect.height, top: 0, left: 0, width: rect.width),
//                   //       screenSize: size),
//                   // ),
//
//
//                 ),
//               ),
//             ),
//             // TransformableBox(
//             //   rect: box.rect,
//             //   flip: box.flip,
//             //   onDragUpdate: (v,c){
//             //     setState(() {
//             //
//             //     });
//             //   },
//             //   onResizeUpdate: (d,c){
//             //     setState(() {
//             //
//             //     });
//             //   },
//             //   onDragEnd: (d){
//             //     setState(() {
//             //
//             //     });
//             //   },
//             //   // clampingRect: model.clampingEnabled ? model.clampingRect : null,
//             //   // constraints: box.constraintsEnabled ? box.constraints : null,
//             //   // onChanged: (result, event) {
//             //   //   widget.onChanged?.call(result);
//             //   //   largestClampingBox = result.largestRect;
//             //   //   setState(() {});
//             //   //   lastResult = result;
//             //   //   model.onRectChanged(result);
//             //   // },
//             //   // resizable: widget.selected && box.resizable,
//             //   // visibleHandles:
//             //   // !widget.selected || !box.resizable ? {} : box.visibleHandles,
//             //   // enabledHandles:
//             //   // !widget.selected || !box.resizable ? {} : box.enabledHandles,
//             //   // draggable: widget.selected && box.draggable,
//             //   // allowContentFlipping: box.flipChild,
//             //   // allowFlippingWhileResizing: box.flipRectWhileResizing,
//             //   cornerHandleBuilder: (context, handle) => AngularHandle(
//             //     handle: handle,
//             //     color: Colors.red,
//             //     hasShadow: false,
//             //   ),
//             //   sideHandleBuilder: (context, handle) => AngularHandle(
//             //     handle: handle,
//             //     color: Colors.red,
//             //     hasShadow: false,
//             //   ),
//             //
//             //   // onResizeStart: (handle, event) {
//             //   //   if (!showTestRecorder || !recorder.isRecording) return;
//             //   //
//             //   //   log('Recording resize action');
//             //   //   currentAction = recorder.onAction(
//             //   //     resizeMode: currentResizeMode,
//             //   //     flip: box.flip,
//             //   //     rect: box.rect,
//             //   //     handle: handle,
//             //   //     cursorPosition: event.localPosition,
//             //   //     clampingRect: model.clampingEnabled ? model.clampingRect : null,
//             //   //     constraints: box.constraintsEnabled ? box.constraints : null,
//             //   //     flipRect: box.flipRectWhileResizing,
//             //   //   );
//             //   // },
//             //   // onResizeEnd: (handle, event) {
//             //   //   if (!showTestRecorder ||
//             //   //       currentAction == null ||
//             //   //       !recorder.isRecording ||
//             //   //       lastResult == null) {
//             //   //     return;
//             //   //   }
//             //   //   log('Recording resize action result');
//             //   //   // recorder.onResult(
//             //   //   //   action: currentAction!,
//             //   //   //   result: lastResult!,
//             //   //   //   localPosition: event.localPosition,
//             //   //   // );
//             //   // },
//             //   // onTerminalSizeReached: (
//             //   //     bool reachedMinWidth,
//             //   //     bool reachedMaxWidth,
//             //   //     bool reachedMinHeight,
//             //   //     bool reachedMaxHeight,
//             //   //     ) {
//             //   //   if (minWidthReached == reachedMinWidth &&
//             //   //       minHeightReached == reachedMinHeight &&
//             //   //       maxWidthReached == reachedMaxWidth &&
//             //   //       maxHeightReached == reachedMaxHeight) return;
//             //   //
//             //   //   setState(() {
//             //   //     minWidthReached = reachedMinWidth;
//             //   //     minHeightReached = reachedMinHeight;
//             //   //     maxWidthReached = reachedMaxWidth;
//             //   //     maxHeightReached = reachedMaxHeight;
//             //   //   });
//             //   // },
//             //   contentBuilder: (context, rect, flip) => GestureDetector(
//             //     behavior: HitTestBehavior.translucent,
//             //     onTap: () {
//             //       setState(() {});
//             //
//             //     },
//             //     child:
//             //     Container(
//             //       width: rect.width,
//             //       height: rect.height,
//             //       decoration: BoxDecoration(
//             //         color: Colors.white24,
//             //         // shape: BoxShape.circle,
//             //         //   border: Border.all(color: Colors.red)
//             //         // borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),)
//             //         // image: DecorationImage(
//             //         //   image: AssetImage(box.imageAsset),
//             //         //   fit: BoxFit.fill,
//             //         // ),
//             //       ),
//             //       // child: CustomPaint(
//             //       //   size: Size(rect.width, rect.height),
//             //       //   // Set the size of the rectangle
//             //       //   // painter: PinkRectanglePainter(),
//             //       //   painter: PinkRectanglePainter(
//             //       //       box: BoxProperties(    height: rect.height, top: 0, left: 0, width: rect.width),
//             //       //       screenSize: size),
//             //       // ),
//             //
//             //     ),
//             //   ),
//             // ),
//
//           ],
//         )
//         // Stack(
//         //   children: [
//         //     GestureDetector(
//         //       onTap: () {},
//         //       onPanDown: (details) {
//         //         if (isCreateBox) {
//         //           final newBox = BoxProperties(
//         //               left: details.localPosition.dx,
//         //               top: details.localPosition.dy,
//         //               width: 0,
//         //               height: 0,
//         //               // dragOffset: Offset(details.localPosition.dy, details.localPosition.dx),
//         //               isDragAble: true);
//         //           setState(() {
//         //             boxes.add(newBox);
//         //             currentBox = newBox;
//         //             startDragOffset = details.localPosition;
//         //             tempBox = newBox; // Initialize tempBox
//         //           });
//         //         } else {
//         //           // print("object");
//         //         }
//         //       },
//         //       onPanUpdate: (details) {
//         //         if (isCreateBox) {
//         //           if (currentBox != null) {
//         //             final newWidth = details.localPosition.dx - currentBox!.left;
//         //             final newHeight = details.localPosition.dy - currentBox!.top;
//         //
//         //             if (newWidth >= 0 && newHeight >= 0) {
//         //               setState(() {
//         //                 currentBox!.width = newWidth;
//         //                 currentBox!.height = newHeight;
//         //               });
//         //             }
//         //           }
//         //           // Update tempBox to show the box while dragging.
//         //           if (tempBox != null) {
//         //             tempBox!.width =
//         //                 details.localPosition.dx - startDragOffset!.dx;
//         //             tempBox!.height =
//         //                 details.localPosition.dy - startDragOffset!.dy;
//         //           }
//         //         } else {
//         //           setState(() {});
//         //           print("sjsjs");
//         //         }
//         //       },
//         //       onPanEnd: (_) {
//         //         if (isCreateBox) {
//         //           currentBox = null;
//         //           tempBox = null;
//         //           setState(() {});
//         //         } else {}
//         //       },
//         //     ),
//         //     ...boxes.map(
//         //       (e) {
//         //         // print(
//         //         //   "left : ${position.dx + dragOffset.dx}",
//         //         // );
//         //         // print(
//         //         //   "top : ${position.dy + dragOffset.dy}",
//         //         // );
//         //
//         //         return Positioned(
//         //           // left: dragOffset.dx,
//         //           // top: dragOffset.dy,
//         //           left: e.dragOffset.dx,
//         //           top: e.dragOffset.dy,
//         //           child: GestureDetector(
//         //             onPanUpdate: (details) async {
//         //               if (isDragging) {
//         //                 setState(() {
//         //                   e.dragOffset = Offset(
//         //                     e.dragOffset.dx + details.delta.dx,
//         //                     e.dragOffset.dy + details.delta.dy,
//         //                   );
//         //
//         //                   // boxes[0] = BoxProperties(
//         //                   //   width: 200,
//         //                   //   height: 200,
//         //                   //   left: dragOffset.dy + details.delta.dx,
//         //                   //   top: dragOffset.dx + details.delta.dy,
//         //                   // );
//         //                   // boxes[0] = BoxProperties(
//         //                   //   width: 200,
//         //                   //   height: 200,
//         //                   //   left: ( dragOffset.dy + details.delta.dy)+ position.dx,
//         //                   //   top: (dragOffset.dx + details.delta.dx)+position.dy,
//         //                   // );
//         //                 });
//         //               }
//         //             },
//         //             onPanEnd: (details) {
//         //               setState(() {
//         //                 // isDragging = false;
//         //               });
//         //             },
//         //             child: CustomPaint(
//         //               size: Size(e.width, e.height),
//         //               // Set the size of the rectangle
//         //               // painter: PinkRectanglePainter(),
//         //               painter: PinkRectanglePainter(box: e, screenSize: size),
//         //             ),
//         //           ),
//         //         );
//         //       },
//         //     )
//         //   ],
//         // ),
//       ),
//       floatingActionButton: Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           FloatingActionButton(
//             onPressed: () {
//               setState(
//                 () {
//                   boxes.add(
//                     BoxProperties(
//                         height: 200,
//                         width: 200,
//                         top: 0,
//                         left: 0,
//                         isSelected: true),
//                   );
//                 },
//               );
//             },
//             child: Icon(Icons.add),
//           ),
//           FloatingActionButton(
//             onPressed: () {
//               setState(() {
//                 isCreateBox = !isCreateBox;
//                 isDragging = !isDragging;
//               });
//             },
//             child: Icon(!isCreateBox ? Icons.play_arrow_sharp : Icons.pause),
//           ),
//         ],
//       ),
//     );
//   }
// }

//
// class PinkRectanglePainter extends CustomPainter {
//   final BoxProperties box;
//   final Size screenSize;
//   final double handleSize = 5.0; // Size of the handles
//
//   PinkRectanglePainter({required this.box, required this.screenSize});
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final rect = Rect.fromLTWH(box.left, box.top, box.width, box.height);
//
//     final fillPaint = Paint()
//       ..color = Colors.white24
//       ..style = PaintingStyle.fill;
//
//     final strokePaint = Paint()
//       ..color = Colors.blue
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 1.0;
//
//     // Draw the resizable box
//     canvas.drawRect(rect, fillPaint);
//     canvas.drawRect(rect, strokePaint);
//
//     // Draw a circle in the center of the box
//     final centerX = box.left + box.width / 2;
//     final centerY = box.top + box.height / 2;
//     final radius = 2.0; // Size of the circle
//     // final circlePaint = Paint()
//     //   ..color = Colors.red
//     //   ..style = PaintingStyle.fill;
//     // canvas.drawCircle(Offset(centerX, centerY), radius, circlePaint);
//
//     // Draw lines from the circle to the edges of the screen
//     final linePaint = Paint()
//       ..color = Colors.red
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 1;
//
//     //  Bottom line
//     canvas.drawLine(Offset(centerX, centerY + radius),
//         Offset(centerX, box.top + box.height), linePaint);
//
//     //  Right line
//     canvas.drawLine(Offset(centerX + radius, centerY),
//         Offset(box.left + box.width, centerY), linePaint);
//
//     // Top line
//     canvas.drawLine(Offset(centerX, centerY),
//         Offset(centerX, screenSize.height), linePaint);
//     canvas.drawLine(Offset(centerX, centerY), Offset(centerX, 0), linePaint);
//
//     // Left line
//     canvas.drawLine(Offset(centerX, centerY), Offset(0, centerY), linePaint);
//     canvas.drawLine(
//         Offset(centerX, centerY), Offset(screenSize.width, centerY), linePaint);
//
//     // Draw handles at each corner
//     drawHandles(canvas, box.left, box.top, size.width, size.height); // Top-left
//     drawHandles(canvas, box.left + box.width, box.top, size.width,
//         size.height); // Top-right
//     drawHandles(canvas, box.left, box.top + box.height, size.width,
//         size.height); // Bottom-left
//     drawHandles(canvas, box.left + box.width, box.top + box.height, size.width,
//         size.height); // Bottom-right
//   }
//
//   void drawHandles(Canvas canvas, double x, double y, double screenWidth,
//       double screenHeight) {
//     final paint = Paint()
//       ..color = Colors.blue
//       ..style = PaintingStyle.fill;
//
//     final linePaint = Paint()
//       ..color = Colors.red
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 1;
//
//     // Draw a circular handle at the specified position
//
//     // Lines for all four sides of the box
//     // canvas.drawLine(Offset(x, y - handleSize), Offset(x, y + handleSize), linePaint); // Vertical line (top to bottom)
//     // canvas.drawLine(Offset(x - handleSize, y), Offset(x + handleSize, y), linePaint); // Horizontal line (left to right)
//
//     // Lines from the circle to the edges of the screen
//
//     canvas.drawLine(Offset(x, y - handleSize), Offset(x, screenSize.height),
//         linePaint); // Top line
//     canvas.drawLine(Offset(x, y + handleSize), Offset(x, screenHeight),
//         linePaint); // Bottom line
//     canvas.drawLine(Offset(x - handleSize, y), Offset(screenSize.width, y),
//         linePaint); // Left line
//     canvas.drawLine(Offset(x + handleSize, y), Offset(screenWidth, y),
//         linePaint); // Right line
//     canvas.drawCircle(Offset(x, y), handleSize, paint);
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return false;
//   }
// }
//
// class PinkRectanglePainterss extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.white24
//       ..style = PaintingStyle.fill;
//
//     final strokePaint = Paint()
//       ..color = Colors.blue
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 1.0;
//
//     // Draw the resizable box
//     canvas.drawRect(Rect.fromPoints(Offset(0, 0), Offset(size.width, size.height)), strokePaint);
//     canvas.drawRect(Rect.fromPoints(Offset(0, 0), Offset(size.width, size.height)), paint);
//
//     final centerX = size.width / 2;
//     final centerY = size.height / 2;
//
//     // Draw horizontal lines
//     canvas.drawLine(Offset(0, centerY), Offset(size.width, centerY), strokePaint);
//     canvas.drawLine(Offset(centerX, 0), Offset(centerX, size.height), strokePaint);
//
//     // Draw white rectangle in the left-top corner
//     final cornerSize = 20.0;
//     final cornerPaint = Paint()..color = Colors.white;
//
//     canvas.drawRect(
//         Rect.fromPoints(Offset(0, 0), Offset(cornerSize, cornerSize)),
//         cornerPaint);
//
//     // Add a GestureDetector to handle taps in the left-top corner
//   //   GestureDetector(
//   //     onTap: () {
//   //       print("clicks");
//   //     },
//   //     child: SizedBox(
//   //       width: cornerSize,
//   //       height: cornerSize,
//   //       child: CustomPaint(
//   //         painter: PinkRectanglePainter(),
//   //       ),
//   //     ),
//   //   );
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return false;
//   }
// }

//
// import 'dart:math';
//
// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: MyRectangularBox(),
//     );
//   }
// }
//
// class MyRectangularBox extends StatefulWidget {
//   @override
//   _MyRectangularBoxState createState() => _MyRectangularBoxState();
// }
//
// class _MyRectangularBoxState extends State<MyRectangularBox> {
//   List<BoxProperties> boxes = [];
//   List<LineProperties> linerList = [];
//   bool draging = true;
//
//   @override
//   void initState() {
//     super.initState();
//     // Add some initial boxes
//     double dx = 10;
//     double dy = 10;
//     double h = 200;
//     double w = 200;
//     double left = dx;
//     double right = dx + w;
//     double top = dy;
//     double button = dy + h;
//     var lineProperties =
//         LineProperties(left: left, top: top, button: button, right: right);
//     boxes.add(BoxProperties(w, h, true, Offset(dx, dy), lineProperties, false));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           for (var box in boxes) {
//             box.isSelected = false;
//           }
//         });
//       },
//       child: Scaffold(
//         body: Stack(
//           children: [
//             for (var box in boxes)
//               DraggableBox(
//                 box: box,
//                 onTap: () {
//                   setState(() {
//                     for (var box in boxes) {
//                       box.isSelected = false;
//                     }
//                     box.isSelected = true;
//                   });
//                 },
//                 onDrag: (newPosition) {
//                   setState(() {
//                     if (draging) {
//                       for (var box in boxes) {
//                         box.isSelected = false;
//                       }
//                       box.isSelected = true;
//                       box.position = newPosition;
//                       double left = newPosition.dx;
//                       double right = newPosition.dx + box.width;
//                       double top = newPosition.dy;
//                       double bottom = newPosition.dy + box.height;
//                       var newLineProperties = LineProperties(
//                         left: left,
//                         top: top,
//                         button: bottom,
//                         right: right,
//                       );
//                       box.lineProperties = newLineProperties;
//
//                       // Iterate through the boxes and update matching lines
//                       for (var otherBox in boxes) {
//                         if (otherBox != box) {
//                           if (otherBox.lineProperties.top.toInt() ==
//                               top.toInt()) {
//                             box.lineProperties = LineProperties(
//                                 left: min(left, otherBox.lineProperties.left),
//                                 top: top,
//                                 button:
//                                     max(bottom, otherBox.lineProperties.button),
//                                 right:
//                                     max(right, otherBox.lineProperties.right),
//                                 isTop: true);
//
//                             // Pause the dragging for 5 milliseconds
//                             draging = false;
//                             Future.delayed(const Duration(milliseconds: 100),
//                                 () {
//                               draging = true;
//                             });
//                           }
//                           if (otherBox.lineProperties.button.toInt() ==
//                               bottom.toInt()) {
//                             box.lineProperties = LineProperties(
//                                 left: min(left, otherBox.lineProperties.left),
//                                 top: top,
//                                 button: bottom,
//                                 right:
//                                     max(right, otherBox.lineProperties.right),
//                                 isButton: true);
//                             draging = false;
//                             Future.delayed(const Duration(milliseconds: 100),
//                                 () {
//                               draging = true;
//                             });
//                           }
//                           if (otherBox.lineProperties.left.toInt() ==
//                               left.toInt()) {
//                             box.lineProperties = LineProperties(
//                                 left: left,
//                                 top: min(top, otherBox.lineProperties.top),
//                                 button:
//                                     max(bottom, otherBox.lineProperties.button),
//                                 right: right,
//                                 isLeft: true);
//                             draging = false;
//                             Future.delayed(const Duration(milliseconds: 100),
//                                 () {
//                               draging = true;
//                             });
//                           }
//                           if (otherBox.lineProperties.right.toInt() ==
//                               right.toInt()) {
//                             box.lineProperties = LineProperties(
//                                 left: left,
//                                 top: min(top, otherBox.lineProperties.top),
//                                 button:
//                                     max(bottom, otherBox.lineProperties.button),
//                                 right:
//                                     min(right, otherBox.lineProperties.right),
//                                 isRight: true);
//                             draging = false;
//                             Future.delayed(const Duration(milliseconds: 100),
//                                 () {
//                               draging = true;
//                             });
//                           }
//                         }
//                       }
//                     }
//                   });
//                 },
//                 lineProperties: box.lineProperties,
//               ),
//           ],
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             // Add a new box
//
//             setState(() {
//               for (var box in boxes) {
//                 box.isSelected = false;
//               }
//
//               double dx = 10;
//               double dy = 10;
//               double h = 200;
//               double w = 200;
//               double left = dx;
//               double right = dx + w;
//               double top = dy;
//               double button = dy + h;
//               var lineProperties = LineProperties(
//                   left: left, top: top, button: button, right: right);
//               boxes.add(BoxProperties(
//                   w, h, true, Offset(dx, dy), lineProperties, false));
//             });
//           },
//           child: Icon(Icons.add),
//         ),
//       ),
//     );
//   }
// }
//
// class BoxProperties {
//   double width;
//   double height;
//   bool isSelected;
//   bool isHover;
//   Offset position;
//   LineProperties lineProperties;
//
//   BoxProperties(this.width, this.height, this.isSelected, this.position,
//       this.lineProperties, this.isHover);
// }
//
// class LineProperties {
//   double top;
//   double left;
//   double button;
//   double right;
//   bool isTop;
//   bool isLeft;
//   bool isButton;
//   bool isRight;
//
//   LineProperties({
//     required this.top,
//     required this.left,
//     required this.button,
//     required this.right,
//     this.isTop = false,
//     this.isButton = false,
//     this.isLeft = false,
//     this.isRight = false,
//   });
// }
//
// class DraggableBox extends StatefulWidget {
//   final BoxProperties box;
//   final LineProperties lineProperties;
//   final Function(Offset) onDrag;
//   final Function() onTap;
//
//   // final Function(Offset) onDragEnd;
//
//   DraggableBox({
//     required this.box,
//     required this.onDrag,
//     required this.lineProperties,
//     required this.onTap,
//     // required this.onDragEnd
//   });
//
//   @override
//   _DraggableBoxState createState() => _DraggableBoxState();
// }
//
// class _DraggableBoxState extends State<DraggableBox> {
//   bool isDragging = false;
//   Offset startDragOffset = Offset(0, 0);
//   BorderDrag? borderDrag; // To track which border is being dragged
//
//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     return Positioned(
//       left: widget.box.position.dx,
//       top: widget.box.position.dy,
//       child: Stack(
//         children: [
//           MouseRegion(
//             onEnter: (v) {
//               setState(() {
//                 widget.box.isHover = true;
//               });
//               print("onEnter");
//             },
//             onExit: (v) {
//               setState(() {
//                 widget.box.isHover = false;
//               });
//               print("onExit");
//             },
//             child: GestureDetector(
//               onTap: () {
//                 widget.onTap();
//               },
//               onPanStart: (details) {
//                 setState(() {
//                   isDragging = true;
//                   startDragOffset = details.localPosition - widget.box.position;
//                   // Determine which border is being dragged based on the touch position
//                   if (details.localPosition.dx < 10) {
//                     borderDrag = BorderDrag.left;
//                   } else if (details.localPosition.dx > widget.box.width - 10) {
//                     borderDrag = BorderDrag.right;
//                   } else if (details.localPosition.dy < 10) {
//                     borderDrag = BorderDrag.top;
//                   } else if (details.localPosition.dy >
//                       widget.box.height - 10) {
//                     borderDrag = BorderDrag.bottom;
//                   }
//                 });
//               },
//               onPanUpdate: (details) {
//                 if (isDragging) {
//                   final newPosition = details.localPosition - startDragOffset;
//
//                   // Adjust the width and height based on which border is being dragged
//                   if (borderDrag == BorderDrag.left) {
//                     widget.box.width = widget.box.width +
//                         (widget.box.position.dx - newPosition.dx);
//                     widget.box.position = newPosition;
//                   } else if (borderDrag == BorderDrag.right) {
//                     widget.box.width = newPosition.dx - widget.box.position.dx;
//                   } else if (borderDrag == BorderDrag.top) {
//                     widget.box.height = widget.box.height +
//                         (widget.box.position.dy - newPosition.dy);
//                     widget.box.position = newPosition;
//                   } else if (borderDrag == BorderDrag.bottom) {
//                     widget.box.height = newPosition.dy - widget.box.position.dy;
//                   }
//
//                   widget.onDrag(newPosition);
//                 }
//               },
//               onPanEnd: (dragDetails) {
//                 setState(() {
//                   isDragging = false;
//                   borderDrag = null;
//                 });
//               },
//               child: Container(
//                 width: widget.box.width,
//                 height: widget.box.height,
//                 decoration: BoxWithCornersDecoration(
//                     box: widget.box,
//                     isDragging: isDragging,
//                     isSelected: widget.box.isSelected,
//                     lineProperties: widget.lineProperties),
//               ),
//             ),
//
//           ),
//           MouseRegion(
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
//       decoration: LineBoxDecoration(box: widget.box,borderDrag: BorderDrag.top),
//     ),
//   ),
// ),
//         ],
//       ),
//     );
//   }
// }
//
// enum BorderDrag { left, right, top, bottom }
class BoxWithCornersDecoration extends Decoration {
  final BoxProperties box;
  final LineProperties lineProperties;
  final double cornerRadius;
  final Color borderColor;
  final Color cornerColor;
  final bool isDragging;
  final bool isSelected;

  BoxWithCornersDecoration({
    required this.box,
    required this.lineProperties,
    required this.isDragging,
    required this.isSelected,
    this.cornerRadius = 4.0,
    this.borderColor = Colors.black,
    this.cornerColor = Colors.red,
  });

  @override
  BoxWithCornersPainter createBoxPainter([VoidCallback? onChanged]) {
    return BoxWithCornersPainter(box, isDragging, isSelected, lineProperties,
        cornerRadius, borderColor, cornerColor);
  }
}
class BoxWithCornersPainter extends BoxPainter {
  final BoxProperties box;
  final LineProperties lineProperties;
  final double cornerRadius;
  final Color borderColor;
  final Color cornerColor;
  final bool isDragging;
  final bool isSelected;

  BoxWithCornersPainter(
    this.box,
    this.isDragging,
    this.isSelected,
    this.lineProperties,
    this.cornerRadius,
    this.borderColor,
    this.cornerColor,
  );

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
      ..strokeWidth = 1.0;
    final cornerPaint = Paint()..color = cornerColor;

    // Draw the container's border
    final rect = Rect.fromLTRB(left, top, right, bottom);
    canvas.drawRect(rect, fillPaint);
    List<double> cornerRadii=[100,100,100,100];
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

    if (isDragging) {
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
            ..strokeWidth = 2.0,
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
            ..strokeWidth = 2.0,
        );
      }

      // Draw the right border
      if (lineProperties.isRight) {
        canvas.drawLine(
          Offset(lineRight, lineTop),
          Offset(lineRight, lineButton),
          Paint()
            ..color = Colors.red // Right border color
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2.0,
        );
      }
    }

    // Draw circles at each corner
    if (!isDragging) {
      // if (box.isHover) {
      //   canvas.drawRect(rect, borderPaint);
      // }
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
//
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
//       decoration: LineBoxDecoration(box: widget.box,borderDrag: BorderDrag.top),
//     ),
//   ),
// ),
//
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
//       height:  widget.box.height,
//       width: 10,
//       decoration: LineBoxDecoration(box: widget.box,borderDrag: BorderDrag.left),
//     ),
//   ),
// ),
//
// class LineBox extends StatefulWidget {
//   final BoxProperties box;
//   final Function(Offset) onDrag;
//
//   LineBox({required this.box, required this.onDrag});
//
//   @override
//   _LineBoxState createState() => _LineBoxState();
// }
//
// class _LineBoxState extends State<LineBox> {
//   bool isDragging = false;
//   Offset startDragOffset = Offset(0, 0);
//   BorderDrag? borderDrag; // To track which border is being dragged
//
//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     return Positioned(
//       left: widget.box.position.dx,
//       top: widget.box.position.dy,
//       child: Container(
//         width: widget.box.width,
//         height: widget.box.height,
//         decoration: LineBoxDecoration(box: widget.box),
//       ),
//     );
//   }
// }
class BoxCustomPainter extends CustomPainter {
  final BoxProperties box;

  BoxCustomPainter(this.box);

  @override
  void paint(Canvas canvas, Size size) {
    const left = 0.0;
    const top = 0.0;
    final right = size.width;
    final bottom = size.height;
    const cornerRadius = 5.0;
    final borderPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final cornerPaint = Paint()..color = Colors.red;

    // Draw the container's border
    final rect = Rect.fromLTRB(left, top, right, bottom);
    canvas.drawRect(rect, borderPaint);

    // Draw the left border
    canvas.drawLine(
      Offset(left, top),
      Offset(left, bottom),
      Paint()
        ..color = Colors.blue
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    );

    // Draw the right border
    canvas.drawLine(
      Offset(right, top),
      Offset(right, bottom),
      Paint()
        ..color = Colors.red
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    );

    // Draw the top border
    canvas.drawLine(
      Offset(left, top),
      Offset(right, top),
      Paint()
        ..color = Colors.yellow
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    );

    // Draw the bottom border
    canvas.drawLine(
      Offset(left, bottom),
      Offset(right, bottom),
      Paint()
        ..color = Colors.green
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    );

    // Draw circles at each corner
    canvas.drawCircle(Offset(left, top), cornerRadius, cornerPaint); // Top-left
    canvas.drawCircle(Offset(right, top), cornerRadius, cornerPaint); // Top-right
    canvas.drawCircle(Offset(left, bottom), cornerRadius, cornerPaint); // Bottom-left
    canvas.drawCircle(Offset(right, bottom), cornerRadius, cornerPaint); // Bottom-right
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
// class BoxCustomPainter extends CustomPainter {
//   final BoxProperties box;
//   final BorderDrag? borderDrag;
//
//   BoxCustomPainter(this.box, this.borderDrag);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final left = box.position.dx;
//     final top = box.position.dy;
//     final right = left + size.width;
//     final bottom = top + size.height;
//     final paint = Paint()
//       ..color = Colors.blue
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 2.0;
//     final rect = Rect.fromPoints(Offset(0, 0), Offset(size.width, size.height));
//     var cornerRadius = 4.0;
//
//     // top
//     canvas.drawLine(
//       Offset(0, 0),
//       Offset(size.width, 0),
//       Paint()
//         ..color = Colors.red // Right border color
//         ..style = PaintingStyle.stroke
//         ..strokeWidth = 2.0,
//     );
//
//     //left
//     canvas.drawLine(
//       Offset(0, 0),
//       Offset(0, size.height),
//       Paint()
//         ..color = Colors.yellow // Right border color
//         ..style = PaintingStyle.stroke
//         ..strokeWidth = 2.0,
//     );
//     // right
//     canvas.drawLine(
//       Offset(size.width, 0),
//       Offset(size.width, size.height),
//       Paint()
//         ..color = Colors.green // Right border color
//         ..style = PaintingStyle.stroke
//         ..strokeWidth = 2.0,
//     );
//     // button
//     canvas.drawLine(
//       Offset(0, size.height),
//       Offset(size.width, size.height),
//       Paint()
//         ..color = Colors.black // Right border color
//         ..style = PaintingStyle.stroke
//         ..strokeWidth = 2.0,
//     );
//
//
//
//     // Draw the box with custom border style
//     // canvas.drawRect(rect, paint);
//
//     // Draw circles at each corner
//     final cornerPaint = Paint()
//       ..color = Colors.red; // You can adjust the circle color
//     canvas.drawCircle(
//         Offset(0, 0), cornerRadius, cornerPaint); // Top-left corner
//     canvas.drawCircle(
//         Offset(size.width, 0), cornerRadius, cornerPaint); // Top-right corner
//     canvas.drawCircle(Offset(0, size.height), cornerRadius,
//         cornerPaint); // Bottom-left corner
//     canvas.drawCircle(Offset(size.width, size.height), cornerRadius,
//         cornerPaint); // Bottom-right corner
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }
class CircularBoxDecoration extends Decoration {
  final BoxProperties box;
  final double cornerRadius;
  final Color borderColor;
  final Color cornerColor;

  CircularBoxDecoration({
    required this.box,
    this.cornerRadius = 4.0,
    this.borderColor = Colors.black,
    this.cornerColor = Colors.red,
  });

  @override
  CircularBoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return CircularBoxPainter(box, cornerRadius, borderColor, cornerColor);
  }
}
class CircularBoxPainter extends BoxPainter {
  final BoxProperties box;
  final double cornerRadius;
  final Color borderColor;
  final Color cornerColor;

  CircularBoxPainter(
      this.box,
      this.cornerRadius,
      this.borderColor,
      this.cornerColor,
      );

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final size = configuration.size!;
    final left = offset.dx;
    final top = offset.dy;
    final right = left + size.width;
    final bottom = top + size.height;

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final cornerPaint = Paint()..color = cornerColor;

    final centerX = (left + right) / 2;
    final centerY = (top + bottom) / 2;
    final radius = (right - left) / 2;
    // Draw the circular container's border
    final circleRect =
    Rect.fromCircle(center: Offset(centerX, centerY), radius: radius);
    canvas.drawOval(circleRect, borderPaint);

    // Draw circles at each corner
    canvas.drawCircle(Offset(left, top), cornerRadius, cornerPaint); // Top-left
    canvas.drawCircle(
        Offset(right, top), cornerRadius, cornerPaint); // Top-right
    canvas.drawCircle(
        Offset(left, bottom), cornerRadius, cornerPaint); // Bottom-left
    canvas.drawCircle(
        Offset(right, bottom), cornerRadius, cornerPaint); // Bottom-right
  }
}
class StarBoxDecoration extends Decoration {
  final BoxProperties box;
  final double cornerRadius;
  final Color borderColor;
  final Color cornerColor;

  StarBoxDecoration({
    required this.box,
    this.cornerRadius = 4.0,
    this.borderColor = Colors.transparent,
    this.cornerColor = Colors.transparent,
  });

  @override
  StarBoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return StarBoxPainter(box, cornerRadius, borderColor, cornerColor);
  }
}
class StarBoxPainter extends BoxPainter {
  final BoxProperties box;
  final double cornerRadius;
  final Color borderColor;
  final Color cornerColor;

  StarBoxPainter(
    this.box,
    this.cornerRadius,
    this.borderColor,
    this.cornerColor,
  );

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final size = configuration.size!;
    final centerX = offset.dx + size.width / 2;
    final centerY = offset.dy + size.height / 2;

    final radius = size.width / 4; // Adjust this to control the star's size

    final outerPoints = <Offset>[];
    final innerPoints = <Offset>[];

    for (int i = 0; i < 5; i++) {
      double outerX = centerX + radius * cos(2 * pi * i / 5 - pi / 2);
      double outerY = centerY + radius * sin(2 * pi * i / 5 - pi / 2);
      double innerX =
          centerX + radius / 2 * cos(2 * pi * i / 5 - pi / 2 + pi / 5);
      double innerY =
          centerY + radius / 2 * sin(2 * pi * i / 5 - pi / 2 + pi / 5);
      outerPoints.add(Offset(outerX, outerY));
      innerPoints.add(Offset(innerX, innerY));
    }

    final paint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    for (int i = 0; i < 5; i++) {
      canvas.drawLine(outerPoints[i], outerPoints[(i + 2) % 5], paint);
      canvas.drawLine(innerPoints[i], innerPoints[(i + 2) % 5], paint);
      canvas.drawLine(outerPoints[i], innerPoints[i], paint);
    }
  }
}
// class LeftLinePainter extends CustomPainter {
//   final BoxProperties box;
//
//   LeftLinePainter({required this.box});
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.red
//       ..strokeWidth = 2.0;
//
//     final leftLineX = box.position.dx; // X-coordinate for the left line
//     final topLineY = box.position.dy;
//     final bottomLineY = box.position.dy + box.height;
//
//     // Draw the left line
//     canvas.drawLine(
//       Offset(leftLineX, topLineY),
//       Offset(leftLineX, bottomLineY),
//       paint,
//     );
//
//     // Draw circles at each corner
//     const cornerRadius = 2.0;
//     canvas.drawCircle(Offset(leftLineX, topLineY), cornerRadius, paint);
//     canvas.drawCircle(Offset(leftLineX, bottomLineY), cornerRadius, paint);
//     canvas.drawCircle(
//         Offset(leftLineX, (topLineY + bottomLineY) / 2), cornerRadius, paint);
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return false;
//   }
// }
class LinePainter extends CustomPainter {
  final BoxProperties box;

  LinePainter(this.box);

  @override
  void paint(Canvas canvas, Size size) {
    final startX = 0.0;
    final startY = size.height / 2;
    final endX = box.width;
    final endY = size.height / 2;

    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Draw the line
    canvas.drawLine(
      Offset(startX, startY),
      Offset(endX, endY),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
class CustomCursorDemo extends StatefulWidget {
  @override
  _CustomCursorDemoState createState() => _CustomCursorDemoState();
}
class _CustomCursorDemoState extends State<CustomCursorDemo> {
  Offset _cursorPosition = Offset(0, 0);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.blue,
          height: 700,

          width: 50,
          child: MouseRegion(
            cursor: SystemMouseCursors.none,
            onHover: (event) {
              setState(() {
                // Update the cursor position based on the mouse position
                _cursorPosition = event.localPosition;
              });
            },
            child: GestureDetector(
              onPanUpdate: (v) {
                setState(() {
                  _cursorPosition = v.localPosition;
                });
              },
              onPanStart: (v) {
                setState(() {
                  _cursorPosition = v.localPosition;
                });
              },
              onPanDown: (v) {
                setState(() {
                  _cursorPosition = v.localPosition;
                });
              },
              onPanEnd: (v) {
                setState(() {
                  // _cursorPosition = v.localPosition;
                });
              },
              child: Stack(
                children: [
                  Positioned(
                    left: _cursorPosition.dx - 26, // Adjust the cursor position
                    top: _cursorPosition.dy - 26,
                    child: CustomPaint(
                      painter: RPSCustomPainter(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(89.913, 46.968)
      ..quadraticBezierTo(87.106, 43.654, 81.493, 37.027)
      ..quadraticBezierTo(79.839, 36.536, 79.138, 37.331)
      ..quadraticBezierTo(78.944, 37.769, 78.549, 38.647)
      ..quadraticBezierTo(78.25, 39.314, 78.783, 40.465)
      ..quadraticBezierTo(80.264, 42.215, 83.229, 45.715)
      ..quadraticBezierTo(59.744, 45.715, 12.768, 45.715)
      ..quadraticBezierTo(14.25, 43.965, 17.215, 40.465)
      ..quadraticBezierTo(17.694, 39.9, 17.449, 38.647)
      ..quadraticBezierTo(17.254, 38.209, 16.862, 37.331)
      ..quadraticBezierTo(16.484, 36.482, 14.507, 37.027)
      ..quadraticBezierTo(11.7, 40.34, 6.087, 49.088)
      ..quadraticBezierTo(5.524, 48.424, 6.087, 47.631)
      ..quadraticBezierTo(8.894, 52.402, 14.507, 59.029)
      ..quadraticBezierTo(15.091, 59.718, 16.862, 58.724)
      ..quadraticBezierTo(17.254, 57.847, 17.449, 57.409)
      ..quadraticBezierTo(17.747, 56.742, 17.215, 55.592)
      ..quadraticBezierTo(15.734, 53.842, 14.507, 50.343)
      ..quadraticBezierTo(36.256, 50.343, 83.229, 50.343)
      ..quadraticBezierTo(81.748, 52.093, 78.783, 55.592)
      ..quadraticBezierTo(78.303, 56.156, 78.549, 57.409)
      ..quadraticBezierTo(78.745, 57.847, 78.549, 58.724)
      ..quadraticBezierTo(79.517, 59.573, 81.493, 59.029)
      ..quadraticBezierTo(84.3, 55.716, 89.913, 49.09)
      ..quadraticBezierTo(90.476, 47.632, 89.913, 46.968)
      ..close();

    // Define a scale factor (adjust to your desired size)
    final scaleFactor = 0.5; // Scale down by 50%

    // Apply a transformation matrix to the canvas to scale down the path
    final scaleMatrix = Matrix4.identity()..scale(scaleFactor);

    canvas.transform(scaleMatrix.storage);

    final paint = Paint()
      ..strokeWidth = 2
      ..color = Colors.black
      ..style = PaintingStyle.stroke;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
