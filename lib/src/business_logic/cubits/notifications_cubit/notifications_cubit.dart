import 'package:driver/src/repositories/firestore_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

part 'notifications_cubit_state.dart';

class NotificationsCubit extends Cubit<NotificationState> {
  final FirestoreRepository _firestoreRepository;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationsCubit({required FirestoreRepository firestoreRepository})
      : _firestoreRepository = firestoreRepository,
        super(NotificationInitial()) {
    _initializeLocalNotifications();
  }

  Future<void> initialize(String driverId) async {
    emit(NotificationLoading());

    await FirebaseMessaging.instance.requestPermission();
    await initializeFCM(driverId);

    await FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        _handleMessage(message);
      }
    });

    FirebaseMessaging.onMessage.listen(_handleMessage);

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    emit(NotificationnReady());
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message,) async {
    // Ensure Firebase and plugin are initialized in the background
    await Firebase.initializeApp();

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    await _showLocalNotification(flutterLocalNotificationsPlugin, message);
  }

  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse:
          onDidReceiveBackgroundNotificationResponse,
    );
  }

  static void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse,) {
    debugPrint(
        'onDidReceivedNotificationResponse: $notificationResponse',);
  }

  static void onDidReceiveBackgroundNotificationResponse(
      NotificationResponse notificationResponse,) {
    debugPrint(
        'onDidReceiveBackgroundNotificationResponse: $notificationResponse',);
  }

  void _handleMessage(RemoteMessage message) {
    debugPrint('_handleMessage ${message.notification} ${message.data}');
    _showLocalNotification(_flutterLocalNotificationsPlugin, message);
  }

  static Future<void> _showLocalNotification(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    RemoteMessage message,
  ) async {
    debugPrint(
        '_showLocalNotification ${message.notification} ${message.data}',);
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      message.notification.hashCode,
      message.data['title'] as String?,
      message.data['body'] as String?,
      platformChannelSpecifics,
    );
  }

  Future<void> initializeFCM(String driverId) async {
    try {
      final String? fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken != null) {
        await _firestoreRepository.refreshFCMToken(driverId, fcmToken);
      }
      FirebaseMessaging.instance.onTokenRefresh.listen((String event) {
        _firestoreRepository.refreshFCMToken(driverId, event);
      });
    } catch (error) {
      debugPrint('Error initializing FCM: $error');
    }
  }
}
