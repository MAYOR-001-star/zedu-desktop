import 'package:zedu/core/core.dart';

extension AppPaletteX on BuildContext {
  // Only a light theme exists, so always return the light palette.
  AppPalette get colors => AppPalette.light;
}

extension ThemeX on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
}
