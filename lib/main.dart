import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:community_guild/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';


void main() async{
 await AwesomeNotifications().initialize(null,
    [
      NotificationChannel(
        channelGroupKey: 'basic_channel_group',
        channelKey: 'basic_channel',
        channelName: 'Basic Notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: Color(0xFF9D50E8),
        ledColor: Colors.white,
        importance: NotificationImportance.Max,
        channelShowBadge: true,
        onlyAlertOnce: true,
        playSound: true,
      ),
    ], channelGroups: [
      NotificationChannelGroup(
        channelGroupKey: 'basic_channel_group'
      , channelGroupName: 'Basic Group'),
    ],
    debug: true,
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Community Guild',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 255, 255, 255)),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
