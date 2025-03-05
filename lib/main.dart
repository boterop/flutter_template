import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_template/l10n/l10n.dart';
import 'package:flutter_template/screens/sign_in.dart';
import 'package:flutter_template/services/api_service.dart';
import 'package:flutter_template/services/storage_service.dart';
import 'package:flutter_template/services/user_service.dart';
import 'package:flutter_template/themes/dark.dart';
import 'package:flutter_template/themes/light.dart';
import 'package:flutter_template/screens/home.dart';
import 'package:flutter_template/widgets/habit.dart';
import 'package:flutter_template/widgets/toggle_theme.dart';
import 'package:flutter_template/widgets/user_button.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  await dotenv.load();
  final String id = await StorageService().load("id") ?? "";
  final String token = await StorageService().load("token") ?? "";
  UserService.instance.updateUser(id, token);
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  MainState createState() => MainState();
}

class MainState extends State<MainApp> {
  var themeMode = ThemeMode.system;
  List<Widget> habitsList = [];

  @override
  void initState() {
    super.initState();
    loadHabits();
  }

  setThemeMode(ThemeMode themeMode) {
    setState(() {
      this.themeMode = themeMode;
    });
  }

  void loadHabits() {
    setState(() {
      habitsList.clear();
    });
    APIService().getUserHabits().then((response) {
      switch (response) {
        case {"data": List habits}:
          List<Widget> widgetList = [];
          for (var habit in habits) {
            widgetList.add(Habit(habit: habit, updateHabits: loadHabits));
          }
          setState(() {
            habitsList.addAll(widgetList);
          });
          break;
        default:
          debugPrint(response.toString());
          break;
      }
    }).catchError((error) {
      Timer(const Duration(seconds: 10), loadHabits);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: themeMode,
      theme: Light.theme,
      darkTheme: Dark.theme,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: L10n.locales,
      home: Scaffold(
          appBar: AppBar(
            leading: UserButton(route: const SignIn(), callback: loadHabits),
            actions: <Widget>[ToggleTheme(setThemeMode: setThemeMode)],
          ),
          body: Home(habitsList: habitsList, updateHabits: loadHabits)),
    );
  }
}
