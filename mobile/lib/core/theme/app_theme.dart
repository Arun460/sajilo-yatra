import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// =============================================
// APP COLORS
// =============================================

class AppColors {
  // Base
  static const Color base = Color(0xFFF8F9FF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceContainer = Color(0xFFE6EEFF);
  static const Color surfaceContainerHigh = Color(0xFFDCE9FF);
  static const electricTeal = Color(0xFF00BCD4);
  // Primary
  static const Color primary = Color(0xFF006495);
  static const Color primaryBright = Color(0xFFCBE6FF);
  static const Color primaryDark = Color(0xFF004A70);
  static const Color onPrimary = Color(0xFFFFFFFF);
  
  // Secondary
  static const Color secondary = Color(0xFF34A853);
  static const Color secondaryBright = Color(0xFFE8F5E9);
  static const Color onSecondary = Color(0xFFFFFFFF);
  
  // Text
  static const Color onSurface = Color(0xFF0F1C2C);
  static const Color onSurfaceMedium = Color(0xFF4A5568);
  static const Color onSurfaceLight = Color(0xFF8A94A6);
  
  // Utils
  static const Color outline = Color(0xFF707880);
  static const Color inputBackground = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFBA1A1A);
  static const Color errorBright = Color(0xFFFFE5E5);
  static const Color success = Color(0xFF34A853);
  static const Color warning = Color(0xFFFBBC04);
  
  // Status
  static const Color info = Color(0xFF1A73E8);
  static const Color infoBright = Color(0xFFE8F0FE);
}

// =============================================
// APP RADIUS
// =============================================

class AppRadius {
  static const double small = 8.0;
  static const double medium = 12.0;
  static const double card = 16.0;
  static const double large = 20.0;
  static const double xlarge = 24.0;
  static const double pill = 9999.0;
}

// =============================================
// APP SPACING
// =============================================

class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

// =============================================
// APP THEME
// =============================================

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      // Brightness
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.base,
      
      // Colors
      primaryColor: AppColors.primary,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        error: AppColors.error,
        onError: Colors.white,
        outline: AppColors.outline,
        surfaceContainer: AppColors.surfaceContainer,
        surfaceContainerHigh: AppColors.surfaceContainerHigh,
      ),
      
      // Font Family
      fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
      
      // =============================================
      // TEXT THEME
      // =============================================
      textTheme: TextTheme(
        // Display - Large Headers
        displayLarge: GoogleFonts.spaceGrotesk(
          fontSize: 48,
          fontWeight: FontWeight.w700,
          color: AppColors.onSurface,
          letterSpacing: -0.5,
        ),
        displayMedium: GoogleFonts.spaceGrotesk(
          fontSize: 36,
          fontWeight: FontWeight.w700,
          color: AppColors.onSurface,
          letterSpacing: -0.5,
        ),
        displaySmall: GoogleFonts.spaceGrotesk(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: AppColors.onSurface,
        ),
        
        // Headline
        headlineLarge: GoogleFonts.spaceGrotesk(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
          letterSpacing: -0.3,
        ),
        headlineMedium: GoogleFonts.spaceGrotesk(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
        ),
        headlineSmall: GoogleFonts.spaceGrotesk(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
        ),
        
        // Title
        titleLarge: GoogleFonts.spaceGrotesk(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
        ),
        titleMedium: GoogleFonts.spaceGrotesk(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
        ),
        titleSmall: GoogleFonts.spaceGrotesk(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
        ),
        
        // Body
        bodyLarge: GoogleFonts.spaceGrotesk(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.onSurface,
        ),
        bodyMedium: GoogleFonts.spaceGrotesk(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.onSurface,
        ),
        bodySmall: GoogleFonts.spaceGrotesk(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.onSurfaceLight,
        ),
        
        // Label
        labelLarge: GoogleFonts.jetBrainsMono(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.onSurfaceMedium,
        ),
        labelMedium: GoogleFonts.jetBrainsMono(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: AppColors.onSurfaceLight,
        ),
        labelSmall: GoogleFonts.jetBrainsMono(
          fontSize: 8,
          fontWeight: FontWeight.w500,
          color: AppColors.onSurfaceLight,
        ),
      ),
      
      // =============================================
      // APP BAR THEME
      // =============================================
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.onSurface,
        titleTextStyle: GoogleFonts.spaceGrotesk(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
        ),
        iconTheme: const IconThemeData(color: AppColors.onSurface),
        surfaceTintColor: Colors.transparent,
      ),
      
      // =============================================
      // INPUT DECORATION THEME
      // =============================================
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.inputBackground,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          borderSide: BorderSide(color: AppColors.outline.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        labelStyle: GoogleFonts.spaceGrotesk(
          fontSize: 14,
          color: AppColors.onSurfaceMedium,
        ),
        hintStyle: GoogleFonts.spaceGrotesk(
          fontSize: 14,
          color: AppColors.onSurfaceLight,
        ),
        errorStyle: GoogleFonts.spaceGrotesk(
          fontSize: 12,
          color: AppColors.error,
        ),
      ),
      
      // =============================================
      // BUTTON THEMES
      // =============================================
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          minimumSize: const Size(double.infinity, 52),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.medium),
          ),
          textStyle: GoogleFonts.spaceGrotesk(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          elevation: 0,
        ),
      ),
      
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          minimumSize: const Size(double.infinity, 52),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.medium),
          ),
          textStyle: GoogleFonts.spaceGrotesk(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: GoogleFonts.spaceGrotesk(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.medium),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize: const Size(double.infinity, 52),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          side: const BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.medium),
          ),
          textStyle: GoogleFonts.spaceGrotesk(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // =============================================
      // CARD THEME
      // =============================================
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        color: AppColors.surface,
        margin: const EdgeInsets.all(AppSpacing.sm),
        clipBehavior: Clip.antiAlias,
      ),
      
      // =============================================
      // CHIP THEME
      // =============================================
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceContainer,
        labelStyle: GoogleFonts.spaceGrotesk(
          fontSize: 12,
          color: AppColors.onSurface,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        side: BorderSide.none,
        elevation: 0,
        deleteIconColor: AppColors.onSurfaceMedium,
        selectedColor: AppColors.primary,
        selectedShadowColor: Colors.transparent,
      ),
      
      // =============================================
      // DIVIDER THEME
      // =============================================
      dividerTheme: DividerThemeData(
        color: AppColors.outline.withOpacity(0.2),
        thickness: 1,
        space: 0,
      ),
      
      // =============================================
      // BOTTOM SHEET THEME
      // =============================================
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.large)),
        ),
        clipBehavior: Clip.antiAlias,
        showDragHandle: true,
        dragHandleSize: Size(40, 4),
      ),
      
      // =============================================
      // SNACK BAR THEME
      // =============================================
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
        ),
        backgroundColor: AppColors.onSurface,
        contentTextStyle: GoogleFonts.spaceGrotesk(
          fontSize: 14,
          color: Colors.white,
        ),
        elevation: 0,
      ),
      
      // =============================================
      // DIALOG THEME
      // =============================================
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.large),
        ),
        elevation: 0,
        titleTextStyle: GoogleFonts.spaceGrotesk(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
        ),
        contentTextStyle: GoogleFonts.spaceGrotesk(
          fontSize: 14,
          color: AppColors.onSurfaceMedium,
        ),
      ),
      
      // =============================================
      // POPUP MENU THEME
      // =============================================
      popupMenuTheme: PopupMenuThemeData(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
        ),
        elevation: 2,
        textStyle: GoogleFonts.spaceGrotesk(
          fontSize: 14,
          color: AppColors.onSurface,
        ),
      ),
      
      // =============================================
      // TAB BAR THEME
      // =============================================
      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.onSurfaceMedium,
        labelStyle: GoogleFonts.spaceGrotesk(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.spaceGrotesk(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: AppColors.primary, width: 3),
          insets: const EdgeInsets.symmetric(horizontal: 16),
        ),
        dividerColor: Colors.transparent,
      ),
      
      // =============================================
      // NAVIGATION BAR THEME
      // =============================================
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        elevation: 0,
        indicatorColor: AppColors.primaryBright,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          return GoogleFonts.spaceGrotesk(
            fontSize: 12,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w600
                : FontWeight.w400,
          );
        }),
      ),
    );
  }
}