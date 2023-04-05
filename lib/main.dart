// ignore_for_file: library_private_types_in_public_api, strict_raw_type

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() => runApp(const MyApp());

///
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

///
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

///
class _MyHomePageState extends State<MyHomePage> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  ///
  @override
  void initState() {
    super.initState();

    const initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    final initializationSettingsIOS = DarwinInitializationSettings(
      requestSoundPermission: false,
      onDidReceiveLocalNotification: (id, title, body, payload) async {},
    );

    final initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse res) {
      debugPrint('payload:${res.payload}');
    });
  }

  ///
  Future _showNotification() async {
    const androidChannelSpecifics = AndroidNotificationDetails(
      'CHANNEL_ID',
      'CHANNEL_NAME',
      channelDescription: 'CHANNEL_DESCRIPTION',
      importance: Importance.max,
      priority: Priority.high,
      playSound: false,
      timeoutAfter: 5000,
      styleInformation: DefaultStyleInformation(true, true),
    );

    const iosChannelSpecifics = DarwinNotificationDetails();

    const platformChannelSpecifics = NotificationDetails(
      android: androidChannelSpecifics,
      iOS: iosChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.periodicallyShow(
      0,
      'repeating title',
      DateTime.now().toString(),
      RepeatInterval.everyMinute,
      platformChannelSpecifics,
    );
  }

  ///
  void _setSchedular() {
    _showNotification();
  }

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text('Hello World'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _setSchedular,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
