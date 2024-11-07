import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:open_file/open_file.dart';

class NotificationsService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static final NotificationsService _instance =
      NotificationsService._internal();
  factory NotificationsService() => _instance;
  NotificationsService._internal();

  AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'ID1', 'Download pdf and excel files',
      description: 'This notification comes from pharmacy App',
      importance: Importance.max);

  Future<void> initialize() async {
    AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      //iOS: IOSInitia
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: _onTapNotification);
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> showNotification(String title, String body,
      {String? playload}) async {
    const AndroidNotificationDetails androidNotificationSpecifics =
        AndroidNotificationDetails(
      'ID1',
      'Download pdf and excel files',
      channelDescription:
          'This notification comes when you download a given file',
      importance: Importance.max,
      priority: Priority.max,
      showWhen: false,
      icon: '@mipmap/ic_launcher',
      styleInformation: BigTextStyleInformation(''),
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidNotificationSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: playload,
    );
  }

  Future<void> _onTapNotification(
      NotificationResponse notificationResponse) async {
    String? playload = notificationResponse.payload;
    if (playload != null && playload.isNotEmpty) {
      await OpenFile.open(playload);
      print(playload);
    } else {
      //Fluttertoast.showToast(msg: 'Aucun fichier trouvé');
    }
  }
}
