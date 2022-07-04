import 'dart:convert';

import 'package:fcm/messaging_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:locally/locally.dart';
import 'package:workmanager/workmanager.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    notif();
    MessagingService.initialize(onSelectNotification).then(
      (value) => firebaseCloudMessagingListeners(),
    );
    super.initState();
  }

  void firebaseCloudMessagingListeners() async {
    MessagingService.onMessage.listen(MessagingService.invokeLocalNotification);
    MessagingService.onMessageOpenedApp.listen(_pageOpenForOnLaunch);
  }

  _pageOpenForOnLaunch(RemoteMessage remoteMessage) {
    final Map<String, dynamic> message = remoteMessage.data;
    onSelectNotification(jsonEncode(message));
  }

  Future onSelectNotification(String? payload) async {
    print(payload);
  }

  notif() {
    Locally locally = Locally(
      context: context,
      payload: 'test',
      pageRoute: MaterialPageRoute(builder: (context) => const MyHomePage()),
      appIcon: 'mipmap/ic_launcher',
    );
    locally.showPeriodically(
        title: 'Title',
        message: 'Body',
        repeatInterval: RepeatInterval.everyMinute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextButton(
          onPressed: () {},
          child: const Text(
            'FCM',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.0,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  notif();
                },
                child: const Text('Press')),
            ElevatedButton(
                onPressed: () {
                  Workmanager().cancelAll();
                },
                child: const Text('Cancel'))
          ],
        ),
      ),
    );
  }
}
