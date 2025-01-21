import 'package:flutter/material.dart';
import 'my_colors.dart';

class MyTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: softBlue,
    scaffoldBackgroundColor: vanilla,
    appBarTheme: const AppBarTheme(
      backgroundColor: softBlue,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    colorScheme: const ColorScheme.light(
      primary: softBlue,
      secondary: accentOrange,
      surface: vanilla,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.black,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: vanillaShade,
      labelStyle: const TextStyle(fontStyle: FontStyle.italic),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: softBlue),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: lightBlueAccent),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: softBlue, width: 2),
      ),
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: darkBlue,
      contentTextStyle: TextStyle(color: vanilla, fontSize: 16),
      actionTextColor: accentOrange,
      behavior: SnackBarBehavior.floating,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: vanilla,
      selectedItemColor: accentOrange, // Accent color for selected items
      unselectedItemColor: Colors.black54,
      selectedIconTheme: const IconThemeData(size: 24),
      unselectedIconTheme: const IconThemeData(size: 20),
    ),
    iconTheme: const IconThemeData(
      color: softBlue,
      size: 24,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(accentOrange), // Use accent color
        foregroundColor: WidgetStateProperty.all(Colors.white),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        elevation: WidgetStateProperty.all(2),
      ),
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      menuStyle: MenuStyle(
        backgroundColor: WidgetStateProperty.all(vanilla),
        elevation: WidgetStateProperty.all(4),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      textStyle: const TextStyle(color: Colors.black, fontSize: 16),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: vanillaShade,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: softBlue),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: softBlue),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: darkBlue),
        ),
      ),
    ),
    listTileTheme: ListTileThemeData(
      iconColor: softBlue,
      textColor: Colors.black,
      selectedColor: accentOrange,
      style: ListTileStyle.list,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );
}
