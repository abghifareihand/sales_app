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
          scaffoldBackgroundColor: AppColors.white,
          bottomSheetTheme: BottomSheetThemeData(backgroundColor: AppColors.white),
          dialogTheme: const DialogTheme(elevation: 0),
          useMaterial3: true,
          appBarTheme: AppBarTheme(
            elevation: 0,
            backgroundColor: AppColors.white,
            surfaceTintColor: AppColors.white,
            foregroundColor: AppColors.primary,
            titleTextStyle: AppFonts.medium.copyWith(color: AppColors.primary, fontSize: 16),
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
