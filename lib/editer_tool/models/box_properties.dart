import 'package:flutter/material.dart';

import 'line_properties.dart';

class BoxProperties {
  double width;
  double height;
  bool isSelected;
  bool isHover;
  Offset position;
  LineProperties lineProperties;

  BoxProperties(this.width, this.height, this.isSelected, this.position,
      this.lineProperties, this.isHover);
}