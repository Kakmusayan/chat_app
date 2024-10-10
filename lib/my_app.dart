import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late FirebaseMessaging messaging;

  @override
  void initState() {
    super.initState();
    messaging = FirebaseMessaging.instance;

    // Получение токена
    messaging.getToken().then((value) {
      print("FCM Token: $value");
    });

    // Обработка фона и завершения приложения
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Получено сообщение: ${message.notification?.title}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("FCM Push Notifications")),
        body: Center(
          child: Text("Flutter Firebase App"),
        ),
      ),
    );
  }
}
