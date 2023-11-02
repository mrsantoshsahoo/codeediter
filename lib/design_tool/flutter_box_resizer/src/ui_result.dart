import 'dart:ui';


import '../../box_resizer/src/result.dart';

/// A convenient type alias for a [ResizeResult] with Flutter's [Rect], [Offset]
/// and [Size] types.
typedef UIMoveResult = MoveResult<Rect, Offset, Size>;

/// A convenient type alias for a [MoveResult] with Flutter's [Rect], [Offset]
/// and [Size] types.
typedef UIResizeResult = ResizeResult<Rect, Offset, Size>;

/// A convenient type alias for a [TransformResult] with Flutter's [Rect],
/// [Offset] and [Size] types.
typedef UITransformResult = TransformResult<Rect, Offset, Size>;
