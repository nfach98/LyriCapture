import 'dart:ui';

extension ColorExt on Color {
  double get luminance {
    return (0.299 * red + 0.587 * green + 0.114 * blue) / 255;
  }
}
