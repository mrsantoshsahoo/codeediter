part of 'resizer.dart';

/// Handles resizing for [ResizeMode.freeform].
final class FreeformResizer extends Resizer {
  /// A default constructor for [FreeformResizer].
  const FreeformResizer();

  @override
  ({Box rect, Box largest, bool hasValidFlip}) resize({
    required Box initialRect,
    required Box explodedRect,
    required Box clampingRect,
    required HandlePosition handle,
    required Constraints constraints,
    required Flip flip,
  }) {
    final flippedHandle = handle.flip(flip);
    Box effectiveInitialRect = flipRect(initialRect, flip, handle);

    Box newRect = Box.fromLTRB(
      max(explodedRect.left, clampingRect.left),
      max(explodedRect.top, clampingRect.top),
      min(explodedRect.right, clampingRect.right),
      min(explodedRect.bottom, clampingRect.bottom),
    );

    bool isValid = true;
    if (!constraints.isUnconstrained) {
      final constrainedWidth =
          newRect.width.clamp(constraints.minWidth, constraints.maxWidth);
      final constrainedHeight =
          newRect.height.clamp(constraints.minHeight, constraints.maxHeight);

      newRect = Box.fromHandle(
        flippedHandle.anchor(effectiveInitialRect),
        flippedHandle,
        constrainedWidth,
        constrainedHeight,
      );

      isValid = isValidRect(newRect, constraints, clampingRect);
      if (!isValid) {
        newRect = Box.fromHandle(
          handle.anchor(initialRect),
          handle,
          !handle.isSide || handle.isHorizontal
              ? constraints.minWidth
              : constrainedWidth,
          !handle.isSide || handle.isVertical
              ? constraints.minHeight
              : constrainedHeight,
        );
      }
    }

    // Not used but calculating it for returning correct largest box.
    final Box area = getAvailableAreaForHandle(
      rect: isValid ? effectiveInitialRect : initialRect,
      handle: isValid ? flippedHandle : handle,
      clampingRect: clampingRect,
    );

    return (rect: newRect, largest: area, hasValidFlip: isValid);
  }
}
