import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/features/auth/splash/splash_view.dart';
import 'package:sales_app/provider_setup.dart';
import 'package:sales_app/ui/theme/app_colors.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sales_app/ui/theme/app_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: appProviders,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sales App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            primary: AppColors.primary,
            secondary: AppColors.primary,
          ),
          scaffoldBackgroundColor: AppColors.surface,
          bottomSheetTheme: const BottomSheetThemeData(
            backgroundColor: AppColors.white,
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
          ),
          cardTheme: CardTheme(
            color: AppColors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: AppColors.border, width: 0.8),
            ),
          ),
          dialogTheme: DialogTheme(
            backgroundColor: AppColors.white,
            surfaceTintColor: Colors.transparent,
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          ),
          useMaterial3: true,
          appBarTheme: AppBarTheme(
            elevation: 0,
            backgroundColor: AppColors.surface,
            surfaceTintColor: Colors.transparent,
            foregroundColor: AppColors.dark,
            titleTextStyle: AppFonts.semiBold.copyWith(color: AppColors.dark, fontSize: 16),
            centerTitle: true,
          ),
          snackBarTheme: SnackBarThemeData(
            contentTextStyle: const TextStyle(color: AppColors.white),
            behavior: SnackBarBehavior.floating,
          ),
        ),
        supportedLocales: const <Locale>[Locale('id')],
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: SplashView(),
      ),
    );
  }
}
