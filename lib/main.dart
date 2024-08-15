
import 'package:calendar_app/auth_page.dart';
import 'package:calendar_app/global_data_holder.dart';
import 'package:calendar_app/screen_channels.dart';
import 'package:calendar_app/screen_home.dart';
import 'package:calendar_app/server/server.dart';
import 'package:calendar_app/theme.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Server.initialize();

  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      builder: (BuildContext context, ThemeMode value, Widget? child)=> MaterialApp(
        title: "Hello",
        theme: ThemeData(colorScheme: MaterialTheme.lightScheme(), useMaterial3: true),
        darkTheme: ThemeData(colorScheme: MaterialTheme.darkScheme(), useMaterial3: true),
        themeMode: value,
        //home: const ScreenHome(),
        home: Server.instance!.currentUser == null? const AuthPage(): const ScreenHome(),
        //home: const authencheck(),
        //home: const ScreenChannels()
      ), valueListenable: GlobalDataHolder.instance.themeMode,
    );
  }
}

String getFormattedTime(DateTime dateTime) {
  var halfNotation = dateTime.hour < 12 ? "AM" : "PM";
  var hour = dateTime.hour % 12;
  var minute = dateTime.minute;
  var formattedTime =
      "${hour < 10 && hour != 0 ? "0" : ""}${hour == 0 ? 12 : hour}:${minute < 10? "0":""}$minute $halfNotation";
  return formattedTime;
}
