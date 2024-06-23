import 'dart:developer';
import 'dart:math' hide log;

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:vector_math/vector_math.dart' hide Colors;

import '../main.dart' as A;
import 'box_resizer/src/enums.dart';
import 'box_resizer/src/result.dart';
import 'design_tool_main_screen.dart';
import 'flutter_box_resizer/flutter_box_transform.dart';
import 'resources/asset_icons.dart';
import 'resources/images.dart';
import 'test_recorder.dart';

bool showTestRecorder =
    const bool.fromEnvironment('test_recorder', defaultValue: false);
var textEditingController = TextEditingController(text: '#fffff');
var selectColor = Color(0xff2680d2);

class DesignTool extends StatelessWidget {
  const DesignTool({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // if (showTestRecorder)
        ChangeNotifierProvider(create: (_) => TestRecorder()),
      ],
      child: AdaptiveTheme(
        light: ThemeData(
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
        dark: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          colorSchemeSeed: Colors.blueAccent,
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
          home: ChangeNotifierProvider(
            create: (_) => PlaygroundModel(),
            child: const Playground(),
          ),
        ),
      ),
    );
  }
}

class PlaygroundModel with ChangeNotifier {
  Rect clampingRect = Rect.largest;
  bool clampingEnabled = true;
  Color cColor = Colors.white;

  Rect? playgroundArea;

  final List<BoxData> boxes = [];

  int selectedBoxIndex = -1;

  BoxData? get selectedBox =>
      selectedBoxIndex != -1 ? boxes[selectedBoxIndex] : null;

  void reset(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double width = size.width - kSidePanelWidth - kBoxesPanelWidth;
    final double height = size.height;

    clampingRect = Rect.fromLTWH(
      0,
      0,
      width,
      size.height,
    );

    boxes.clear();

    boxes.add(
      BoxData(
        name: 'Box 1',
        imageAsset: Images.image1,
        rect: Rect.fromLTWH(
          (width - kInitialWidth) / 2,
          (height - kInitialHeight) / 2,
          kInitialWidth,
          kInitialHeight,
        ),
        flip: Flip.none,
        constraintsEnabled: true,
        // constraints: const BoxConstraints(
        //   minWidth: 100,
        //   minHeight: 100,
        //   maxWidth: 500,
        //   maxHeight: 500,
        // ),
      ),
    );
    selectedBoxIndex = 0;

    notifyListeners();
  }

  void onRectChanged(UITransformResult result) {
    if (selectedBox == null) return;
    selectedBox!.rect = result.rect;
    if (result is UIResizeResult) {
      selectedBox!.flip = result.flip;
    }
    notifyListeners();
  }

  void onFlipChanged(Flip flip) {
    if (selectedBoxIndex == -1) return;
    selectedBox!.flip = flip;
    notifyListeners();
  }

  void changeColor(color) {
    boxes[selectedBoxIndex].color = color;
    notifyListeners();
  }

  void onFlipChildChanged(bool enabled) {
    if (selectedBoxIndex == -1) return;
    selectedBox!.flipChild = enabled;
    notifyListeners();
  }

  void onFlipWhileResizingChanged(bool enabled) {
    if (selectedBoxIndex == -1) return;
    selectedBox!.flipRectWhileResizing = enabled;
    notifyListeners();
  }

  void setClampingRect(
    Rect rect, {
    bool notify = true,
    bool insidePlayground = false,
  }) {
    clampingRect = rect;

    if (insidePlayground && playgroundArea != null) {
      clampingRect = Rect.fromLTWH(
        clampingRect.left.clamp(0.0, playgroundArea!.width),
        clampingRect.top.clamp(0.0, playgroundArea!.height),
        clampingRect.width.clamp(0.0, playgroundArea!.width),
        clampingRect.height.clamp(0.0, playgroundArea!.height),
      );
    }

    if (notify) notifyListeners();
  }

  void addNewBox() {
    boxes.add(
      BoxData(
        name: 'Box ${boxes.length + 1}',
        imageAsset: Images.values[boxes.length % Images.values.length],
        rect: Rect.fromLTWH(
          playgroundArea!.center.dx - kInitialWidth / 2,
          playgroundArea!.center.dy - kInitialHeight / 2,
          kInitialWidth,
          kInitialHeight,
        ),
        flip: Flip.none,
        constraintsEnabled: true,
      ),
    );

    notifyListeners();
  }

  void removeSelectedBox() {
    if (selectedBoxIndex == -1) return;
    boxes.removeAt(selectedBoxIndex);
    selectedBoxIndex = -1;
    notifyListeners();
  }

  void removeBox(int index) {
    if (index == -1) return;
    boxes.removeAt(index);
    if (index == selectedBoxIndex) {
      selectedBoxIndex = -1;
    }
    notifyListeners();
  }

  void setConstraints(BoxConstraints constraints, {bool notify = true}) {
    if (selectedBoxIndex == -1) return;
    selectedBox!.constraints = constraints;

    if (notify) notifyListeners();
  }

  void flipHorizontally() {
    if (selectedBoxIndex == -1) return;
    selectedBox!.flip = Flip.fromValue(
      selectedBox!.flip.horizontalValue * -1,
      selectedBox!.flip.verticalValue,
    );
    notifyListeners();
  }

  void flipVertically() {
    if (selectedBoxIndex == -1) return;
    selectedBox!.flip = Flip.fromValue(
      selectedBox!.flip.horizontalValue,
      selectedBox!.flip.verticalValue * -1,
    );
    notifyListeners();
  }

  void toggleClamping(bool enabled) {
    clampingEnabled = enabled;
    notifyListeners();
  }

  void toggleResizing(bool enabled) {
    if (selectedBoxIndex == -1) return;
    selectedBox!.resizable = enabled;
    notifyListeners();
  }

  void toggleMoving(bool enabled) {
    if (selectedBoxIndex == -1) return;
    selectedBox!.draggable = enabled;
    notifyListeners();
  }

  void toggleConstraints(bool enabled) {
    if (selectedBoxIndex == -1) return;
    selectedBox!.constraintsEnabled = enabled;
    notifyListeners();
  }

  void addVisibleHandle(HandlePosition handle) {
    if (selectedBoxIndex == -1) return;
    selectedBox!.visibleHandles.add(handle);
    notifyListeners();
  }

  void removeVisibleHandle(HandlePosition handle) {
    if (selectedBoxIndex == -1) return;
    selectedBox!.visibleHandles.remove(handle);
    notifyListeners();
  }

  void addAllEnabledHandles() {
    if (selectedBoxIndex == -1) return;
    selectedBox!.enabledHandles
      ..clear()
      ..addAll([...HandlePosition.values]..remove(HandlePosition.none));
    notifyListeners();
  }

  void removeAllEnabledHandles() {
    if (selectedBoxIndex == -1) return;
    selectedBox!.enabledHandles.clear();
    notifyListeners();
  }

  void addEnabledHandle(HandlePosition handle) {
    if (selectedBoxIndex == -1) return;
    selectedBox!.enabledHandles.add(handle);
    notifyListeners();
  }

  void removeEnabledHandle(HandlePosition handle) {
    if (selectedBoxIndex == -1) return;
    selectedBox!.enabledHandles.remove(handle);
    notifyListeners();
  }

  void addAllVisibleHandles() {
    if (selectedBoxIndex == -1) return;
    selectedBox!.visibleHandles
      ..clear()
      ..addAll([...HandlePosition.values]..remove(HandlePosition.none));
    notifyListeners();
  }

  void removeAllVisibleHandles() {
    if (selectedBoxIndex == -1) return;
    selectedBox!.visibleHandles.clear();
    notifyListeners();
  }

  void onClampingRectChanged({
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    if (selectedBox == null) return;
    clampingRect = Rect.fromLTRB(
      left ?? clampingRect.left,
      top ?? clampingRect.top,
      right ?? clampingRect.right,
      bottom ?? clampingRect.bottom,
    );
    notifyListeners();
  }

  void onConstraintsChanged({
    double? minWidth,
    double? minHeight,
    double? maxWidth,
    double? maxHeight,
    bool forceMinWidth = false,
    bool forceMinHeight = false,
    bool forceMaxWidth = false,
    bool forceMaxHeight = false,
  }) {
    if (selectedBox == null) return;
    selectedBox!.constraints = BoxConstraints(
      minWidth: forceMinWidth
          ? minWidth ?? 0
          : minWidth ?? selectedBox!.constraints.minWidth,
      minHeight: forceMinHeight
          ? minHeight ?? 0
          : minHeight ?? selectedBox!.constraints.minHeight,
      maxWidth: forceMaxWidth
          ? maxWidth ?? double.infinity
          : maxWidth ?? selectedBox!.constraints.maxWidth,
      maxHeight: forceMaxHeight
          ? maxHeight ?? double.infinity
          : maxHeight ?? selectedBox!.constraints.maxHeight,
    );
    notifyListeners();
  }

  void onBoxSelected(int index) {
    selectedBoxIndex = index;
    notifyListeners();
  }

  void clearSelection() {
    selectedBoxIndex = -1;
    notifyListeners();
  }

  void onReorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final selectedBox = this.selectedBox;
    final BoxData box = boxes.removeAt(oldIndex);
    boxes.insert(newIndex, box);
    if (selectedBox != null) {
      selectedBoxIndex =
          boxes.indexWhere((box) => box.name == selectedBox.name);
    }

    notifyListeners();
  }
}

class Playground extends StatefulWidget {
  const Playground({super.key});

  @override
  State<Playground> createState() => _PlaygroundState();
}

const double kSidePanelWidth = 280;
const double kBoxesPanelWidth = 250;
const double kInitialWidth = 300;
const double kInitialHeight = 300;
const double kStrokeWidth = 1.5;
const Color kGridColor = Color.fromARGB(126, 27, 181, 228);

class _PlaygroundState extends State<Playground> with WidgetsBindingObserver {
  Set<LogicalKeyboardKey> pressedKeys = {};

  late final FocusNode focusNode = FocusNode();

  late final PlaygroundModel model = context.read<PlaygroundModel>();

  @override
  void initState() {
    super.initState();

    // This is required to center the box based on screen size when the app
    // starts.
    SchedulerBinding.instance.addPostFrameCallback((_) {
      model.reset(context);
    });

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (model.playgroundArea == null) resetPlayground();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    resetPlayground(notify: true);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // This is done to automatically resize clamping rect to the new screen size
  // when the app is resized but only when the clampingRect is already
  // set to the full screen. This is done to avoid the clamping rect to be
  // resized when the user has already resized it.
  void resetPlayground({bool notify = false}) {
    final PlaygroundModel model = context.read<PlaygroundModel>();
    final Size size = MediaQuery.of(context).size;
    model.playgroundArea = Rect.fromLTWH(
      0,
      0,
      max(size.width - kSidePanelWidth - kBoxesPanelWidth, 100),
      max(size.height,
          100), // safe size for when window is resized extremely small.
    );

    final Rect playgroundArea = model.playgroundArea!;

    if (model.clampingRect.width > playgroundArea.width ||
        model.clampingRect.height > playgroundArea.height) {
      model.setClampingRect(
        model.clampingRect,
        notify: notify,
        insidePlayground: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final PlaygroundModel model = context.watch<PlaygroundModel>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          const Divider(
            height: 1,
          ),
          Card(
            margin: EdgeInsets.zero,
            shape: const RoundedRectangleBorder(),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: Row(
                children: [],
              ),
            ),
          ),
          const Divider(
            height: 1,
          ),
          Expanded(
            child: Row(
              children: [
                const VerticalDivider(
                  width: 1,
                ),
                Card(
                  margin: EdgeInsets.zero,
                  shape: const RoundedRectangleBorder(),
                  child: SizedBox(
                    width: 50,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        IconButton(
                          onPressed: () {},
                          tooltip: 'Hide Bar',
                          iconSize: 25,
                          splashRadius: 18,
                          color: Theme.of(context).colorScheme.primary,
                          icon: const Icon(Icons.keyboard_double_arrow_right),
                        ),
                      ],
                    ),
                  ),
                ),
                const VerticalDivider(
                  width: 1,
                ),
                const LeftPanel(),
                Expanded(
                  child: CallbackShortcuts(
                    bindings: <ShortcutActivator, VoidCallback>{
                      const SingleActivator(LogicalKeyboardKey.backspace):
                          model.removeSelectedBox,
                      const CharacterActivator('a'): () {
                        model.addNewBox();
                      }
                    },
                    child: MouseRegion(
                      child: RawKeyboardListener(
                        focusNode: focusNode,
                        autofocus: true,
                        onKey: (key) {
                          if (key is RawKeyDownEvent) {
                            pressedKeys.add(key.logicalKey);
                            setState(() {});
                          } else if (key is RawKeyUpEvent) {
                            pressedKeys.remove(key.logicalKey);
                            setState(() {});
                          }
                        },
                        child: GestureDetector(
                          onTap: () {
                            focusNode.requestFocus();
                            model.clearSelection();
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              if (model.clampingEnabled &&
                                  model.playgroundArea != null)
                                const ClampingRect(),
                              for (int index = 0;
                                  index < model.boxes.length;
                                  index++)
                                ImageBox(
                                  key: ValueKey(model.boxes[index].name),
                                  box: model.boxes[index],
                                  color: model.boxes[index].color,
                                  selected: index == model.selectedBoxIndex,
                                  onChanged: model.onRectChanged,
                                  onSelected: () => model.onBoxSelected(index),
                                ),
                              Positioned(
                                left: 16,
                                bottom: 16,
                                child: KeyboardListenerIndicator(
                                  pressedKeys: pressedKeys.toList(),
                                  onClear: () =>
                                      setState(() => pressedKeys = {}),
                                ),
                              ),
                              Positioned.fill(
                                child: GridPaper(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? kGridColor.withOpacity(0.03)
                                      : kGridColor.withOpacity(0.1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Expanded(
                //     child: SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //     children: [
                //       Container(
                //         height: 650,
                //         width: 325,
                //         color: Colors.white,
                //         margin: EdgeInsets.symmetric(horizontal: 5),
                //       ),
                //
                //     ],
                //   ),
                // )),
                const ControlPanel(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ImageBox extends StatefulWidget {
  const ImageBox({
    super.key,
    required this.box,
    required this.onChanged,
    this.color = Colors.white,
    required this.onSelected,
    required this.selected,
  });

  final BoxData box;
  final Color color;
  final bool selected;
  final VoidCallback onSelected;
  final Function(TransformResult<Rect, Offset, Size>)? onChanged;

  @override
  State<ImageBox> createState() => _ImageBoxState();
}

class _ImageBoxState extends State<ImageBox> {
  bool minWidthReached = false;
  bool minHeightReached = false;
  bool maxWidthReached = false;
  bool maxHeightReached = false;

  BoxData get box => widget.box;

  Rect largestClampingBox = Rect.zero;

  late final TestRecorder recorder = context.read<TestRecorder>();

  TestAction? currentAction;
  UITransformResult? lastResult;

  bool get isShiftPressed =>
      WidgetsBinding.instance.keyboard.logicalKeysPressed
          .contains(LogicalKeyboardKey.shiftLeft) ||
      WidgetsBinding.instance.keyboard.logicalKeysPressed
          .contains(LogicalKeyboardKey.shiftRight);

  bool get isAltPressed =>
      WidgetsBinding.instance.keyboard.logicalKeysPressed
          .contains(LogicalKeyboardKey.altLeft) ||
      WidgetsBinding.instance.keyboard.logicalKeysPressed
          .contains(LogicalKeyboardKey.altRight);

  ResizeMode get currentResizeMode {
    if (isShiftPressed && isAltPressed) {
      return ResizeMode.symmetricScale;
    } else if (isShiftPressed) {
      return ResizeMode.scale;
    } else if (isAltPressed) {
      return ResizeMode.symmetric;
    } else {
      return ResizeMode.freeform;
    }
  }

  @override
  Widget build(BuildContext context) {
    Color mainColor = Theme.of(context).colorScheme.primary;
    var size = MediaQuery.of(context).size;

    final PlaygroundModel model = context.read<PlaygroundModel>();
    final Color handleColor = Theme.of(context).colorScheme.primary;
    return
      TransformableBox(
      key: ValueKey('image-box-${box.name}'),
      rect: box.rect,
      flip: box.flip,
      clampingRect: model.clampingEnabled ? model.clampingRect : null,
      constraints: box.constraintsEnabled ? box.constraints : null,
      onChanged: (result, event) {
        print(result.position);
        print(result.rect);

        widget.onChanged?.call(result);
        largestClampingBox = result.largestRect;
        setState(() {});
        lastResult = result;
        model.onRectChanged(result);

      },
      resizable: widget.selected && box.resizable,
      visibleHandles:
          !widget.selected || !box.resizable ? {} : box.visibleHandles,
      enabledHandles:
          !widget.selected || !box.resizable ? {} : box.enabledHandles,
      draggable: widget.selected && box.draggable,
      allowContentFlipping: box.flipChild,
      allowFlippingWhileResizing: box.flipRectWhileResizing,
      cornerHandleBuilder: (context, handle) => AngularHandle(
        handle: handle,
        color: mainColor,
        hasShadow: false,
      ),
      sideHandleBuilder: (context, handle) => AngularHandle(
        handle: handle,
        color: mainColor,
        hasShadow: false,
      ),
      onResizeStart: (handle, event) {
        if (!showTestRecorder || !recorder.isRecording) return;

        log('Recording resize action');
        currentAction = recorder.onAction(
          resizeMode: currentResizeMode,
          flip: box.flip,
          rect: box.rect,
          handle: handle,
          cursorPosition: event.localPosition,
          clampingRect: model.clampingEnabled ? model.clampingRect : null,
          constraints: box.constraintsEnabled ? box.constraints : null,
          flipRect: box.flipRectWhileResizing,
        );
      },
      onResizeEnd: (handle, event) {
        if (!showTestRecorder ||
            currentAction == null ||
            !recorder.isRecording ||
            lastResult == null) {
          return;
        }
        log('Recording resize action result');
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
        if (minWidthReached == reachedMinWidth &&
            minHeightReached == reachedMinHeight &&
            maxWidthReached == reachedMaxWidth &&
            maxHeightReached == reachedMaxHeight) return;

        setState(() {
          minWidthReached = reachedMinWidth;
          minHeightReached = reachedMinHeight;
          maxWidthReached = reachedMaxWidth;
          maxHeightReached = reachedMaxHeight;
        });
      },
      contentBuilder: (context, rect, flip) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          setState(() {});
          if (widget.selected) return;
          widget.onSelected();
        },
        child:
        Container(
          key: ValueKey('image-box-${box.name}-content'),
          width: rect.width,
          height: rect.height,
          decoration: BoxDecoration(
            color: widget.color,
            // shape: BoxShape.circle,
            // border: Border.all(color: Colors.red)
            // borderRadius: BorderRadius.only(bottomLeft: Radius.circular(100),)
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
          // foregroundDecoration: BoxDecoration(
          //   border: widget.selected
          //       ? Border.symmetric(
          //           horizontal: BorderSide(
          //             color: minHeightReached
          //                 ? Colors.orange
          //                 : maxHeightReached
          //                     ? Colors.red
          //                     : handleColor,
          //             width: 2,
          //             // TODO: Due to flutter issue in 3.7.10, this doesn't work in debug mode.
          //             // strokeAlign: BorderSide.strokeAlignCenter,
          //           ),
          //           vertical: BorderSide(
          //             color: minWidthReached
          //                 ? Colors.orange
          //                 : maxWidthReached
          //                     ? Colors.red
          //                     : handleColor,
          //             width: 2,
          //             // TODO: Due to flutter issue in 3.7.10, this doesn't work in debug mode.
          //             // strokeAlign: BorderSide.strokeAlignCenter,
          //           ),
          //         )
          //       : null,
          // ),
        ),
      ),
    );
  }
}

class ClampingRect extends StatefulWidget {
  const ClampingRect({super.key});

  @override
  State<ClampingRect> createState() => _ClampingRectState();
}

class _ClampingRectState extends State<ClampingRect> {
  bool minWidthReached = false;
  bool minHeightReached = false;
  bool maxWidthReached = false;
  bool maxHeightReached = false;

  @override
  Widget build(BuildContext context) {
    final PlaygroundModel model = context.watch<PlaygroundModel>();
    const Color mainColor = Colors.transparent;
    final Color horizontalEdgeColor, verticalEdgeColor;
    final bool anyTerminalSize = minWidthReached ||
        minHeightReached ||
        maxWidthReached ||
        maxHeightReached;
    if (minHeightReached) {
      horizontalEdgeColor = Colors.orange;
    } else if (maxHeightReached) {
      horizontalEdgeColor = Colors.red;
    } else {
      horizontalEdgeColor = mainColor;
    }
    if (minWidthReached) {
      verticalEdgeColor = Colors.orange;
    } else if (maxWidthReached) {
      verticalEdgeColor = Colors.red;
    } else {
      verticalEdgeColor = mainColor;
    }

    final String label;
    if (minWidthReached && minHeightReached) {
      label = 'Min size reached';
    } else if (maxWidthReached && maxHeightReached) {
      label = 'Max size reached';
    } else if (minWidthReached) {
      label = 'Min width reached';
    } else if (minHeightReached) {
      label = 'Min height reached';
    } else if (maxWidthReached) {
      label = 'Max width reached';
    } else if (maxHeightReached) {
      label = 'Max height reached';
    } else {
      label = 'Clamping Box';
    }

    final minWidth = model.boxes.fold(0.0,
        (previousValue, element) => max(previousValue, element.rect.width));
    final minHeight = model.boxes.fold(0.0,
        (previousValue, element) => max(previousValue, element.rect.height));

    return TransformableBox(
      key: const ValueKey('clamping-box'),
      rect: model.clampingRect,
      flip: Flip.none,
      clampingRect: model.playgroundArea!,
      allowFlippingWhileResizing: false,
      // constraints: BoxConstraints(minWidth: minWidth, minHeight: minHeight),
      onChanged: (result, event) => model.setClampingRect(result.rect),
      onTerminalSizeReached: (
        bool reachedMinWidth,
        bool reachedMaxWidth,
        bool reachedMinHeight,
        bool reachedMaxHeight,
      ) {
        if (minWidthReached == reachedMinWidth &&
            minHeightReached == reachedMinHeight &&
            maxWidthReached == reachedMaxWidth &&
            maxHeightReached == reachedMaxHeight) return;

        setState(() {
          minWidthReached = reachedMinWidth;
          minHeightReached = reachedMinHeight;
          maxWidthReached = reachedMaxWidth;
          maxHeightReached = reachedMaxHeight;
        });
      },
      handleAlignment: HandleAlignment.inside,
      cornerHandleBuilder: (context, handle) => AngularHandle(
        handle: handle,
        color: mainColor,
        hasShadow: false,
      ),
      sideHandleBuilder: (context, handle) => AngularHandle(
        handle: handle,
        color: mainColor,
        hasShadow: false,
      ),
      contentBuilder: (context, _, flip) => Container(
        width: model.clampingRect.width,
        height: model.clampingRect.height,
        alignment: Alignment.bottomRight,
        decoration: BoxDecoration(
          border: Border.symmetric(
            horizontal: BorderSide(
              color: horizontalEdgeColor,
              width: 1.5,
            ),
            vertical: BorderSide(
              color: verticalEdgeColor,
              width: 1.5,
            ),
          ),
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color:
                (anyTerminalSize ? Colors.orange : mainColor).withOpacity(0.1),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(6),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              label,
              style: TextStyle(
                color: anyTerminalSize ? Colors.orange : mainColor,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ControlPanel extends StatefulWidget {
  const ControlPanel({super.key});

  @override
  State<ControlPanel> createState() => _ControlPanelState();
}

class _ControlPanelState extends State<ControlPanel> {
  @override
  Widget build(BuildContext context) {
    final PlaygroundModel model = context.watch<PlaygroundModel>();

    final BoxData? box = model.selectedBox;

    return Card(
      margin: const EdgeInsets.only(left: 0),
      shape: const RoundedRectangleBorder(),
      child: SizedBox(
        width: kSidePanelWidth,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
              child: Row(
                children: [
                  Expanded(
                    child: FilledButton.tonalIcon(
                      onPressed: () => model.reset(context),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reset'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    tooltip: 'Open on GitHub',
                    onPressed: () => launchUrlString(
                        'https://github.com/birjuvachhani/rect_resizer'),
                    icon: const Icon(Icons.open_in_new_rounded),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () =>
                        AdaptiveTheme.of(context).toggleThemeMode(),
                    tooltip: 'Toggle Theme',
                    icon: ValueListenableBuilder<AdaptiveThemeMode>(
                      valueListenable:
                          AdaptiveTheme.of(context).modeChangeNotifier,
                      builder: (context, mode, child) => Icon(
                        mode == AdaptiveThemeMode.system
                            ? Icons.brightness_auto_outlined
                            : mode == AdaptiveThemeMode.dark
                                ? Icons.brightness_2_outlined
                                : Icons.brightness_5_rounded,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            if (box != null) ...[
              const PositionControls(),
              const Divider(height: 1),
              Container(
                height: 44,
                padding: const EdgeInsets.fromLTRB(16, 0, 6, 0),
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Movable',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                      child: Transform.scale(
                        scale: 0.7,
                        child: Switch(
                          value: box.draggable,
                          onChanged: (value) => model.toggleMoving(value),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    color: Colors.white,
                    tooltip: 'Pick Color',
                    icon: const Icon(Icons.color_lens),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            scrollable: true,
                            titlePadding: const EdgeInsets.all(0),
                            contentPadding: const EdgeInsets.all(0),
                            content: Column(
                              children: [
                                // ColorPicker(
                                //   pickerColor:
                                //       model.boxes[model.selectedBoxIndex].color,
                                //   onColorChanged: (v) {
                                //     setState(() {
                                //       // model.boxes[model.selectedBoxIndex].color=v;
                                //       model.changeColor(v);
                                //       // model.cColor=v;
                                //       // selectColor = v;
                                //       // print( model.cColor);
                                //     });
                                //   },
                                //   colorPickerWidth: 300,
                                //   pickerAreaHeightPercent: 0.7,
                                //   enableAlpha: true,
                                //   // hexInputController will respect it too.
                                //   displayThumbColor: true,
                                //   paletteType: PaletteType.hsvWithHue,
                                //   labelTypes: const [],
                                //   pickerAreaBorderRadius:
                                //       const BorderRadius.only(
                                //     topLeft: Radius.circular(2),
                                //     topRight: Radius.circular(2),
                                //   ),
                                //   hexInputController: textEditingController,
                                //   // <- here
                                //   portraitOnly: true,
                                // ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                  child: CupertinoTextField(
                                    controller: textEditingController,
                                    style: TextStyle(color: Colors.white),
                                    // Everything below is purely optional.
                                    prefix: const Padding(
                                        padding: EdgeInsets.only(left: 8),
                                        child: Icon(Icons.tag)),
                                    suffix: IconButton(
                                      icon: const Icon(
                                          Icons.content_paste_rounded),
                                      onPressed: () {},
                                    ),
                                    autofocus: true,
                                    maxLength: 9,
                                    inputFormatters: [
                                      // UpperCaseTextFormatter(),
                                      // FilteringTextInputFormatter.allow(
                                      //     RegExp(kValidHexPattern)),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          model.boxes[model.selectedBoxIndex].color,
                      // shadowColor: Colors.black.withOpacity(1),
                      // elevation: 10,
                    ),
                  ),
                ],
              ),
              const Divider(height: 1),
              const HandleControls(),
              const Divider(height: 1),
              const FlipControls(),
              const Divider(height: 1),
              const ClampingControls(),
              const Divider(height: 1),
              const ConstraintsControls(),
              const Divider(height: 1),
            ] else ...[
              const SizedBox(height: 44),
              Text(
                'Select a box to see controls',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class LeftPanel extends StatelessWidget {
  const LeftPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(),
      child: SizedBox(
        width: kBoxesPanelWidth,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            const Expanded(child: BoxesPanel()),
            const Divider(height: 1),
            if (showTestRecorder) const Expanded(child: TestRecorderUI()),
          ],
        ),
      ),
    );
  }
}

class BoxesPanel extends StatelessWidget {
  const BoxesPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final PlaygroundModel model = context.watch<PlaygroundModel>();

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 4, 0),
            child: Row(
              children: [
                const SectionHeader(
                  'Boxes',
                  padding: EdgeInsets.zero,
                ),
                Text(
                  ' • ${model.boxes.length}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    letterSpacing: 1,
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: model.selectedBox != null
                      ? model.removeSelectedBox
                      : null,
                  tooltip: 'Delete selected box',
                  iconSize: 18,
                  splashRadius: 18,
                  color: Theme.of(context).colorScheme.error,
                  icon: const Icon(Icons.delete_outline_outlined),
                ),
                MenuAnchor(
                  builder: (BuildContext context, MenuController controller,
                      Widget? child) {
                    return IconButton(
                      onPressed: () {
                        if (controller.isOpen) {
                          controller.close();
                        } else {
                          controller.open();
                        }
                      },
                      icon: const Icon(
                        Icons.tag,
                      ),
                      tooltip: 'Show menu',
                    );
                  },
                  menuChildren: List<MenuItemButton>.generate(
                    3,
                    (int index) => MenuItemButton(
                      onPressed: () {},
                      child: Text('Item ${index + 1}'),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    model.addNewBox();
                  },
                  tooltip: 'Add new box',
                  iconSize: 18,
                  splashRadius: 18,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          if (model.boxes.isEmpty) ...[
            const SizedBox(height: 44),
            Text(
              'Add a box to see controls',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
            ),
          ],
          if (model.boxes.isNotEmpty)
            ReorderableListView.builder(
              itemCount: model.boxes.length,
              onReorder: model.onReorder,
              reverse: true,
              shrinkWrap: true,
              buildDefaultDragHandles: false,
              primary: false,
              itemBuilder: (context, index) {
                final box = model.boxes[index];
                return ReorderableDragStartListener(
                  index: index,
                  key: ValueKey(box.name),
                  child: Container(
                    color: box.name == model.selectedBox?.name
                        ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                        : null,
                    child: ListTile(
                      title: Text(box.name),
                      selected: box.name == model.selectedBox?.name,
                      onTap: () => model.onBoxSelected(index),
                      leading: const Icon(
                        Icons.border_style_outlined,
                        size: 18,
                      ),
                      minLeadingWidth: 20,
                      dense: true,
                      // selectedTileColor:
                      //     Theme.of(context).colorScheme.primary.withOpacity(0.2),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class PositionControls extends StatelessWidget {
  const PositionControls({super.key});

  @override
  Widget build(BuildContext context) {
    final PlaygroundModel model = context.watch<PlaygroundModel>();

    final BoxData box = model.selectedBox!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SectionHeader('POSITION'),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Row(
                children: [
                  Expanded(child: Label('LEFT')),
                  SizedBox(width: 16),
                  Expanded(child: Label('TOP')),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ValueText(box.rect.left.floor().toString()),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ValueText(box.rect.top.floor().toString()),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Row(
                children: [
                  Expanded(child: Label('RIGHT')),
                  SizedBox(width: 16),
                  Expanded(child: Label('BOTTOM')),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ValueText(box.rect.right.floor().toString()),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ValueText(box.rect.bottom.floor().toString()),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Row(
                children: [
                  Expanded(child: Label('WIDTH')),
                  SizedBox(width: 16),
                  Expanded(child: Label('HEIGHT')),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ValueText(box.rect.width.toStringAsFixed(0)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ValueText(box.rect.height.toStringAsFixed(0)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Row(
                children: [
                  Expanded(child: Label('ASPECT RATIO')),
                  Expanded(child: Label('CENTER')),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ValueText(
                      (box.rect.width / box.rect.height).toStringAsFixed(2),
                    ),
                  ),
                  Expanded(
                    child: ValueText(
                      '${box.rect.center.dx.toInt()} x ${box.rect.center.dy.toStringAsFixed(0)}',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class HandleControls extends StatefulWidget {
  const HandleControls({super.key});

  @override
  State<HandleControls> createState() => _HandleControlsState();
}

class _HandleControlsState extends State<HandleControls> {
  bool advancedEnabledHandles = false;
  bool advancedVisibleHandles = false;

  @override
  Widget build(BuildContext context) {
    final PlaygroundModel model = context.watch<PlaygroundModel>();

    final BoxData box = model.selectedBox!;

    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutQuart,
      alignment: Alignment.topCenter,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 44,
            padding: const EdgeInsets.fromLTRB(16, 0, 6, 0),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Resizable',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                  ),
                ),
                SizedBox(
                  height: 20,
                  child: Transform.scale(
                    scale: 0.7,
                    child: Switch(
                      value: box.resizable,
                      onChanged: (value) => model.toggleResizing(value),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, indent: 24),
          ClipRect(
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutQuart,
              alignment: Alignment.topCenter,
              heightFactor: box.resizable ? 1 : 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(24, 8, 6, 8),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Enabled Handles',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                          child: Transform.scale(
                            scale: 0.6,
                            child: Switch(
                              value: box.enabledHandles.isNotEmpty,
                              onChanged: (value) {
                                if (value) {
                                  model.addAllEnabledHandles();
                                } else {
                                  model.removeAllEnabledHandles();
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.only(left: 24, right: 16),
                    title: Text(
                      'Advanced',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                    ),
                    trailing: Icon(
                      advancedEnabledHandles
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 18,
                    ),
                    onTap: () => setState(() {
                      advancedEnabledHandles = !advancedEnabledHandles;
                    }),
                  ),
                  ClipRect(
                    child: AnimatedAlign(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOutQuart,
                      alignment: Alignment.topCenter,
                      heightFactor: advancedEnabledHandles ? 1 : 0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (final handle in {
                            ...HandlePosition.values
                          }..remove(HandlePosition.none))
                            InkWell(
                              onTap: () {
                                if (box.enabledHandles.contains(handle)) {
                                  model.removeEnabledHandle(handle);
                                } else {
                                  model.addEnabledHandle(handle);
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 36, top: 4, bottom: 4),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        handle.prettify,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium
                                            ?.copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                            ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                      child: Transform.scale(
                                        scale: 0.5,
                                        child: Switch(
                                          value: box.enabledHandles
                                              .contains(handle),
                                          onChanged: (bool? value) {
                                            if (value == null) return;
                                            if (value) {
                                              model.addEnabledHandle(handle);
                                            } else {
                                              model.removeEnabledHandle(handle);
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                  const Divider(height: 1, indent: 24),
                  Container(
                    padding: const EdgeInsets.fromLTRB(24, 12, 6, 8),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Visible Handles',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                          child: Transform.scale(
                            scale: 0.7,
                            child: Switch(
                              value: box.visibleHandles.isNotEmpty,
                              onChanged: (value) {
                                if (value) {
                                  model.addAllVisibleHandles();
                                } else {
                                  model.removeAllVisibleHandles();
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.only(left: 24, right: 16),
                    title: Text(
                      'Advanced',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                    ),
                    trailing: Icon(
                      advancedVisibleHandles
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 18,
                    ),
                    onTap: () => setState(() {
                      advancedVisibleHandles = !advancedVisibleHandles;
                    }),
                  ),
                  ClipRect(
                    child: AnimatedAlign(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOutQuart,
                      alignment: Alignment.topCenter,
                      heightFactor: advancedVisibleHandles ? 1 : 0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (final handle in {
                            ...HandlePosition.values
                          }..remove(HandlePosition.none))
                            InkWell(
                              onTap: () {
                                if (box.visibleHandles.contains(handle)) {
                                  model.removeVisibleHandle(handle);
                                } else {
                                  model.addVisibleHandle(handle);
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 36, top: 4, bottom: 4),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        handle.prettify,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium
                                            ?.copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                            ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                      child: Transform.scale(
                                        scale: 0.5,
                                        child: Switch(
                                          value: box.visibleHandles
                                              .contains(handle),
                                          onChanged: (bool? value) {
                                            if (value == null) return;
                                            if (value) {
                                              model.addVisibleHandle(handle);
                                            } else {
                                              model.removeVisibleHandle(handle);
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          const SizedBox(height: 8),
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
    );
  }
}

class FlipControls extends StatelessWidget {
  const FlipControls({super.key});

  @override
  Widget build(BuildContext context) {
    final PlaygroundModel model = context.watch<PlaygroundModel>();

    final BoxData box = model.selectedBox!;
    final textController = TextEditingController(text: '#2F19DB');

    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            // color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
            // height: 44,
            padding: const EdgeInsets.fromLTRB(16, 16, 6, 16),
            alignment: Alignment.centerLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Flip rect while resizing',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      FractionallySizedBox(
                        widthFactor: 0.9,
                        child: Text(
                          'Allows to flip the rect while resizing. The actual contents of the rect won\'t be flipped.',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                  child: Transform.scale(
                    scale: 0.7,
                    child: Switch(
                      value: box.flipRectWhileResizing,
                      onChanged: (value) =>
                          model.onFlipWhileResizingChanged(value),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Container(
            // color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
            // height: 44,
            padding: const EdgeInsets.fromLTRB(16, 16, 6, 16),
            alignment: Alignment.centerLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Flip Content',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                      ),
                      const SizedBox(height: 4),
                      FractionallySizedBox(
                        widthFactor: 0.9,
                        child: Text(
                          'Flip the contents of the rect when it is flipped.',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                  child: Transform.scale(
                    scale: 0.7,
                    child: Switch(
                      value: box.flipChild,
                      onChanged: (value) => model.onFlipChildChanged(value),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (box.flipChild)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                children: [
                  ToggleButtons(
                    onPressed: (index) {
                      if (index == 0) {
                        model.flipHorizontally();
                      } else {
                        model.flipVertically();
                      }
                    },
                    isSelected: [
                      box.flip.isHorizontal,
                      box.flip.isVertical,
                    ],
                    selectedColor: Theme.of(context).colorScheme.primary,
                    constraints: const BoxConstraints.tightFor(height: 32),
                    children: [
                      Tooltip(
                        message: 'Flip Horizontally',
                        waitDuration: Duration(milliseconds: 500),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            children: [
                              // ImageIcon(
                              //   AssetImage(AssetIcons.icFlip),
                              //   size: 20,
                              // ),
                              SizedBox(width: 8),
                              Text('Horizontal'),
                            ],
                          ),
                        ),
                      ),
                      Tooltip(
                        message: 'Flip Vertically',
                        waitDuration: Duration(milliseconds: 500),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            children: [
                              // RotatedBox(
                              //   quarterTurns: 1,
                              //   child: ImageIcon(
                              //     AssetImage(AssetIcons.icFlip),
                              //     size: 20,
                              //   ),
                              // ),
                              SizedBox(width: 8),
                              Text('Vertical'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class ClampingControls extends StatefulWidget {
  const ClampingControls({super.key});

  @override
  State<ClampingControls> createState() => _ClampingControlsState();
}

class _ClampingControlsState extends State<ClampingControls> {
  late final PlaygroundModel model = context.read<PlaygroundModel>();

  late final TextEditingController leftController;
  late final TextEditingController topController;
  late final TextEditingController bottomController;
  late final TextEditingController rightController;

  double get left => double.tryParse(leftController.text) ?? 0;

  double get top => double.tryParse(topController.text) ?? 0;

  double get bottom => double.tryParse(bottomController.text) ?? 0;

  double get right => double.tryParse(rightController.text) ?? 0;

  BoxData get box => model.selectedBox!;

  @override
  void initState() {
    super.initState();
    leftController =
        TextEditingController(text: model.clampingRect.left.toStringAsFixed(0));
    topController =
        TextEditingController(text: model.clampingRect.top.toStringAsFixed(0));
    bottomController = TextEditingController(
        text: model.clampingRect.bottom.toStringAsFixed(0));
    rightController = TextEditingController(
        text: model.clampingRect.right.toStringAsFixed(0));

    model.addListener(onModelChanged);
  }

  void onModelChanged() {
    if (model.clampingRect.left != left) {
      leftController.text = model.clampingRect.left.toStringAsFixed(0);
    }
    if (model.clampingRect.top != top) {
      topController.text = model.clampingRect.top.toStringAsFixed(0);
    }
    if (model.clampingRect.bottom != bottom) {
      bottomController.text = model.clampingRect.bottom.toStringAsFixed(0);
    }
    if (model.clampingRect.right != right) {
      rightController.text = model.clampingRect.right.toStringAsFixed(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final PlaygroundModel model = context.watch<PlaygroundModel>();

    return FocusScope(
      child: Builder(
        builder: (context) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              model.onClampingRectChanged(
                left: left,
                top: top,
                bottom: bottom,
                right: right,
              );
            },
            child: AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 44,
                    padding: const EdgeInsets.fromLTRB(16, 0, 6, 0),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'CLAMPING',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                          child: Transform.scale(
                            scale: 0.7,
                            child: Switch(
                              value: model.clampingEnabled,
                              onChanged: (value) => model.toggleClamping(value),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (model.clampingEnabled)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Row(
                            children: [
                              Expanded(child: Label('LEFT')),
                              SizedBox(width: 16),
                              Expanded(child: Label('TOP')),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  enabled: model.clampingEnabled,
                                  controller: leftController,
                                  onSubmitted: (value) {
                                    model.onClampingRectChanged(left: left);
                                  },
                                  decoration: const InputDecoration(
                                    suffixText: 'px',
                                  ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]*'),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextField(
                                  enabled: model.clampingEnabled,
                                  controller: topController,
                                  onSubmitted: (value) {
                                    model.onClampingRectChanged(top: top);
                                  },
                                  decoration: const InputDecoration(
                                    suffixText: 'px',
                                  ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]*'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Row(
                            children: [
                              Expanded(child: Label('RIGHT')),
                              SizedBox(width: 16),
                              Expanded(child: Label('BOTTOM')),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  enabled: model.clampingEnabled,
                                  controller: rightController,
                                  onFieldSubmitted: (value) {
                                    model.onClampingRectChanged(right: right);
                                  },
                                  decoration: const InputDecoration(
                                    suffixText: 'px',
                                  ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]*'),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextField(
                                  enabled: model.clampingEnabled,
                                  controller: bottomController,
                                  onSubmitted: (value) {
                                    model.onClampingRectChanged(bottom: bottom);
                                  },
                                  decoration: const InputDecoration(
                                    suffixText: 'px',
                                  ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]*'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          FilledButton.tonalIcon(
                            onPressed: () {
                              model.setClampingRect(model.playgroundArea!);
                            },
                            icon: const Icon(Icons.fullscreen_rounded),
                            label: const Text('Full screen'),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    model.removeListener(onModelChanged);
    super.dispose();
  }
}

class ConstraintsControls extends StatefulWidget {
  const ConstraintsControls({super.key});

  @override
  State<ConstraintsControls> createState() => _ConstraintsControlsState();
}

class _ConstraintsControlsState extends State<ConstraintsControls> {
  late final PlaygroundModel model = context.read<PlaygroundModel>();

  late final TextEditingController minWidthController;
  late final TextEditingController minHeightController;
  late final TextEditingController maxWidthController;
  late final TextEditingController maxHeightController;

  double? get minWidth => double.tryParse(minWidthController.text) ?? 0;

  double? get minHeight => double.tryParse(minHeightController.text) ?? 0;

  double? get maxWidth => double.tryParse(maxWidthController.text);

  double? get maxHeight => double.tryParse(maxHeightController.text);

  BoxData get box => model.selectedBox!;

  @override
  void initState() {
    super.initState();
    minWidthController =
        TextEditingController(text: formatted(box.constraints.minWidth));
    minHeightController =
        TextEditingController(text: formatted(box.constraints.minHeight));
    maxHeightController =
        TextEditingController(text: formatted(box.constraints.maxHeight));
    maxWidthController =
        TextEditingController(text: formatted(box.constraints.maxWidth));

    model.addListener(onModelChanged);
  }

  void onModelChanged() {
    if (model.selectedBox == null) return;
    if (box.constraints.minWidth != minWidth) {
      minWidthController.text = formatted(box.constraints.minWidth);
    }
    if (box.constraints.minHeight != minHeight) {
      minHeightController.text = formatted(box.constraints.minHeight);
    }
    if (box.constraints.maxHeight != maxHeight) {
      maxHeightController.text = formatted(box.constraints.maxHeight);
    }
    if (box.constraints.maxWidth != maxWidth) {
      maxWidthController.text = formatted(box.constraints.maxWidth);
    }
  }

  String formatted(double? value) {
    if (value == null || value == 0) return '';
    if (value.isInfinite) return '';
    return value.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    final PlaygroundModel model = context.watch<PlaygroundModel>();
    return FocusScope(
      child: Builder(
        builder: (context) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              model.onConstraintsChanged(
                minWidth: minWidth,
                minHeight: minHeight,
                maxHeight: maxHeight,
                maxWidth: maxWidth,
                forceMinWidth: true,
                forceMinHeight: true,
                forceMaxWidth: true,
                forceMaxHeight: true,
              );
            },
            child: AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 44,
                    padding: const EdgeInsets.fromLTRB(16, 0, 6, 0),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'CONSTRAINTS',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                          child: Transform.scale(
                            scale: 0.7,
                            child: Switch(
                              value: box.constraintsEnabled,
                              onChanged: (value) =>
                                  model.toggleConstraints(value),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (box.constraintsEnabled)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Row(
                            children: [
                              Expanded(child: Label('Min W')),
                              SizedBox(width: 16),
                              Expanded(child: Label('Min H')),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  enabled: box.constraintsEnabled,
                                  controller: minWidthController,
                                  onSubmitted: (value) {
                                    model.onConstraintsChanged(
                                      minWidth: minWidth,
                                      forceMinWidth: true,
                                    );
                                  },
                                  decoration: const InputDecoration(
                                    suffixText: 'px',
                                    hintText: '0',
                                  ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]*'),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextField(
                                  enabled: box.constraintsEnabled,
                                  controller: minHeightController,
                                  onSubmitted: (value) {
                                    model.onConstraintsChanged(
                                      minHeight: minHeight,
                                      forceMinHeight: true,
                                    );
                                  },
                                  decoration: const InputDecoration(
                                    suffixText: 'px',
                                    hintText: '0',
                                  ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]*'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Row(
                            children: [
                              Expanded(child: Label('Max W')),
                              SizedBox(width: 16),
                              Expanded(child: Label('Max H')),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  enabled: box.constraintsEnabled,
                                  controller: maxWidthController,
                                  onFieldSubmitted: (value) {
                                    model.onConstraintsChanged(
                                      maxWidth: maxWidth,
                                      forceMaxWidth: true,
                                    );
                                  },
                                  decoration: const InputDecoration(
                                    suffixText: 'px',
                                    hintText: '∞',
                                  ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]*'),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextField(
                                  enabled: box.constraintsEnabled,
                                  controller: maxHeightController,
                                  onSubmitted: (value) {
                                    model.onConstraintsChanged(
                                      maxHeight: maxHeight,
                                      forceMaxHeight: true,
                                    );
                                  },
                                  decoration: const InputDecoration(
                                    suffixText: 'px',
                                    hintText: '∞',
                                  ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]*'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          FilledButton.tonalIcon(
                            onPressed: () {
                              model.setConstraints(const BoxConstraints(
                                minWidth: double.infinity,
                                minHeight: double.infinity,
                              ));
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('Reset'),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    model.removeListener(onModelChanged);
    super.dispose();
  }
}

class KeyboardListenerIndicator extends StatelessWidget {
  final List<LogicalKeyboardKey> pressedKeys;
  final VoidCallback onClear;

  const KeyboardListenerIndicator({
    super.key,
    required this.pressedKeys,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final key in pressedKeys)
          Container(
            margin: EdgeInsets.only(right: pressedKeys.last != key ? 12 : 0),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color:
                      Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
                  blurRadius: 1,
                  offset: const Offset(1, 3),
                ),
              ],
            ),
            child: Text(
              prettifyKey(key),
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        if (pressedKeys.isNotEmpty)
          IconButton(
            onPressed: onClear,
            splashRadius: 16,
            iconSize: 18,
            icon: Icon(
              Icons.clear,
              color: Colors.grey.shade400,
            ),
          ),
      ],
    );
  }

  String prettifyKey(LogicalKeyboardKey key) {
    final keyLabel = key.keyLabel;
    if (key == LogicalKeyboardKey.arrowLeft) return '←';
    if (key == LogicalKeyboardKey.arrowRight) return '→';
    if (key == LogicalKeyboardKey.arrowUp) return '↑';
    if (key == LogicalKeyboardKey.arrowDown) return '↓';
    if (key == LogicalKeyboardKey.escape) return 'ESC';
    if (key == LogicalKeyboardKey.shiftLeft) return 'SHIFT';
    if (key == LogicalKeyboardKey.altLeft) return 'ALT';
    if (key == LogicalKeyboardKey.controlLeft) return 'CTRL';
    if (key == LogicalKeyboardKey.metaLeft) return 'CMD';
    return keyLabel;
  }
}

class Label extends StatelessWidget {
  final String label;

  const Label(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.labelMedium!.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
    );
  }
}

class ValueText extends StatelessWidget {
  final String value;

  const ValueText(this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: Theme.of(context).textTheme.titleMedium,
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final EdgeInsets? padding;
  final double? height;

  const SectionHeader(
    this.title, {
    super.key,
    this.padding,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 44,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: Theme.of(context).colorScheme.secondary,
            ),
      ),
    );
  }
}

class BoxData {
  final String name;
  Rect rect = Rect.zero;
  Flip flip = Flip.none;
  Rect rect2 = Rect.zero;
  Flip flip2 = Flip.none;
  BoxConstraints constraints;

  bool flipRectWhileResizing = true;
  bool flipChild = true;
  bool constraintsEnabled = false;
  bool resizable = true;
  bool draggable = true;
  double rotateValue = 0.0;
  Color color = Colors.white;
  Set<HandlePosition> enabledHandles;
  Set<HandlePosition> visibleHandles;

  final String imageAsset;

  BoxData({
    required this.name,
    required this.rect,
    required this.imageAsset,
    this.flip = Flip.none,
    this.rect2 = Rect.zero,
    this.flip2 = Flip.none,
    this.color = Colors.white,
    this.constraints = const BoxConstraints(minWidth: 0, minHeight: 0),
    this.flipRectWhileResizing = true,
    this.flipChild = true,
    this.constraintsEnabled = false,
    this.draggable = true,
    this.rotateValue = 0.0,
    this.resizable = true,
    Set<HandlePosition>? enabledHandles,
    Set<HandlePosition>? visibleHandles,
  })  : enabledHandles = enabledHandles ?? {...HandlePosition.values}
          ..remove(HandlePosition.none),
        visibleHandles = visibleHandles ?? {...HandlePosition.values}
          ..remove(HandlePosition.none);

}

List<Vector2>? extendLineToRect(Rect rect, Vector2 p1, Vector2 p2) {
  final result = extendLinePointsToRectPoints(
      rect.left, rect.top, rect.right, rect.bottom, p1.x, p1.y, p2.x, p2.y);

  if (result == null) return null;

  return [Vector2(result[0], result[1]), Vector2(result[2], result[3])];
}

List<double>? extendLinePointsToRectPoints(
  double left,
  double top,
  double right,
  double bottom,
  double x1,
  double y1,
  double x2,
  double y2,
) {
  if (y1 == y2) {
    return [left, y1, right, y1];
  }
  if (x1 == x2) {
    return [x1, top, x1, bottom];
  }

  double yForLeft = y1 + (y2 - y1) * (left - x1) / (x2 - x1);
  double yForRight = y1 + (y2 - y1) * (right - x1) / (x2 - x1);

  double xForTop = x1 + (x2 - x1) * (top - y1) / (y2 - y1);
  double xForBottom = x1 + (x2 - x1) * (bottom - y1) / (y2 - y1);

  if (top <= yForLeft &&
      yForLeft <= bottom &&
      top <= yForRight &&
      yForRight <= bottom) {
    return [left, yForLeft, right, yForRight];
  } else if (top <= yForLeft && yForLeft <= bottom) {
    if (left <= xForBottom && xForBottom <= right) {
      return [left, yForLeft, xForBottom, bottom];
    } else if (left <= xForTop && xForTop <= right) {
      return [left, yForLeft, xForTop, top];
    }
  } else if (top <= yForRight && yForRight <= bottom) {
    if (left <= xForTop && xForTop <= right) {
      return [xForTop, top, right, yForRight];
    }
    if (left <= xForBottom && xForBottom <= right) {
      return [xForBottom, bottom, right, yForRight];
    }
  } else if (left <= xForTop &&
      xForTop <= right &&
      left <= xForBottom &&
      xForBottom <= right) {
    return [xForTop, top, xForBottom, bottom];
  }
  return null;
}

class PinkRectanglePainter extends CustomPainter {
  final BoxProperties box;
  final Size screenSize;
  final double handleSize = 5.0; // Size of the handles

  PinkRectanglePainter({required this.box, required this.screenSize});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(box.left, box.top, box.width, box.height);

    final fillPaint = Paint()
      ..color = Colors.white24
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Draw the resizable box
    canvas.drawRect(rect, fillPaint);
    canvas.drawRect(rect, strokePaint);

    // Draw a circle in the center of the box
    final centerX = box.left + box.width / 2;
    final centerY = box.top + box.height / 2;
    final radius = 2.0; // Size of the circle
    // final circlePaint = Paint()
    //   ..color = Colors.red
    //   ..style = PaintingStyle.fill;
    // canvas.drawCircle(Offset(centerX, centerY), radius, circlePaint);

    // Draw lines from the circle to the edges of the screen
    final linePaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    //  Bottom line
    canvas.drawLine(Offset(centerX, centerY + radius),
        Offset(centerX, box.top + box.height), linePaint);

    //  Right line
    canvas.drawLine(Offset(centerX + radius, centerY),
        Offset(box.left + box.width, centerY), linePaint);

    // Top line
    canvas.drawLine(Offset(centerX, centerY),
        Offset(centerX, screenSize.height), linePaint);
    canvas.drawLine(Offset(centerX, centerY), Offset(centerX, 0), linePaint);

    // Left line
    canvas.drawLine(Offset(centerX, centerY), Offset(0, centerY), linePaint);
    canvas.drawLine(
        Offset(centerX, centerY), Offset(screenSize.width, centerY), linePaint);

    // Draw handles at each corner
    drawHandles(canvas, box.left, box.top, size.width, size.height); // Top-left
    drawHandles(canvas, box.left + box.width, box.top, size.width,
        size.height); // Top-right
    drawHandles(canvas, box.left, box.top + box.height, size.width,
        size.height); // Bottom-left
    drawHandles(canvas, box.left + box.width, box.top + box.height, size.width,
        size.height); // Bottom-right
  }

  void drawHandles(Canvas canvas, double x, double y, double screenWidth,
      double screenHeight) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw a circular handle at the specified position

    // Lines for all four sides of the box
    // canvas.drawLine(Offset(x, y - handleSize), Offset(x, y + handleSize), linePaint); // Vertical line (top to bottom)
    // canvas.drawLine(Offset(x - handleSize, y), Offset(x + handleSize, y), linePaint); // Horizontal line (left to right)

    // Lines from the circle to the edges of the screen

    canvas.drawLine(Offset(x, y - handleSize), Offset(x, screenSize.height),
        linePaint); // Top line
    canvas.drawLine(Offset(x, y + handleSize), Offset(x, screenHeight),
        linePaint); // Bottom line
    canvas.drawLine(Offset(x - handleSize, y), Offset(screenSize.width, y),
        linePaint); // Left line
    canvas.drawLine(Offset(x + handleSize, y), Offset(screenWidth, y),
        linePaint); // Right line
    // canvas.drawCircle(Offset(x, y), handleSize, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
