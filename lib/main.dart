import 'package:expensenoted/constant.dart';
import 'package:expensenoted/screen/profile_screen.dart';
import 'package:expensenoted/screen/report_screen.dart';
import 'package:expensenoted/screen/user_guideline_screen.dart';
import 'package:flutter/material.dart';
import 'package:expensenoted/providers/auth_provider.dart';
import 'package:expensenoted/providers/entry_provider.dart';
import 'package:expensenoted/screen/auth_screen.dart';
import 'package:expensenoted/screen/loading_screen.dart';
import 'package:expensenoted/screen/overview_screen.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future main() async {
  Provider.debugCheckInvalidValueType = null;
  await dotenv.load(
    fileName: "assets/.env",
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => User(displayName: '', email: '', photoUrl: ''),
        ),
        ChangeNotifierProvider(
          create: (_) => Entries(),
        ),
      ],
      child: const NoteBuddyMain(),
    ),
  );
}

class NoteBuddyMain extends StatelessWidget {
  const NoteBuddyMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Noted',
      theme: ThemeData(
        fontFamily: 'Open Sans',
        colorScheme: const ColorScheme(
          error: Colors.redAccent,
          onError: themeColor4,
          brightness: Brightness.light,
          background: themeColor3,
          onBackground: colorBar5,
          surface: themeColor3,
          onSurface: themeColor3,
          primary: themeColor3,
          onPrimary: themeColor4,
          secondary: themeColor2,
          onSecondary: themeColor4,
          tertiary: themeColor1,
          onTertiary: themeColor4,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const LoadingScreen(),
      routes: {
        LoadingScreen.routeName: (ctx) => const LoadingScreen(),
        OverviewScreen.routeName: (ctx) => const OverviewScreen(),
        AuthScreen.routeName: (ctx) => const AuthScreen(),
        ReportScreen.routeName: (ctx) => const ReportScreen(),
        ProfileScreen.routeName: (ctx) => const ProfileScreen(),
        UserGuidelineScreen.routeName: (ctx) => const UserGuidelineScreen(),
      },
      localizationsDelegates: const [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        MonthYearPickerLocalizations.delegate,
      ],
    );
  }
}
