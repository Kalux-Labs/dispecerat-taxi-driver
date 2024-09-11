import 'package:driver/src/business_logic/cubits/app_session_cubit.dart';
import 'package:driver/src/models/driver.dart';
import 'package:driver/src/repositories/firestore_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
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

  void initialize(String driverId) async {
    emit(NotificationLoading());

    // await _flutterLocalNotificationsPlugin
    //     .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
    //     ?.requestPermission();
    await FirebaseMessaging.instance.requestPermission();
    initializeFCM(driverId);

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        _handleMessage(message);
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleMessage(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleMessage(message);
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    emit(NotificationnReady());
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // Ensure Firebase and plugin are initialized in the background
    await Firebase.initializeApp();

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    await _showLocalNotification(flutterLocalNotificationsPlugin, message);
  }

  void _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    InitializationSettings initializationSettings =
        const InitializationSettings(
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
      NotificationResponse notificationResponse) {
    debugPrint(
        "onDidReceivedNotificationResponse: ${notificationResponse.toString()}");
  }

  static void onDidReceiveBackgroundNotificationResponse(
      NotificationResponse notificationResponse) {
    debugPrint(
        "onDidReceiveBackgroundNotificationResponse: ${notificationResponse.toString()}");
  }

  void _handleMessage(RemoteMessage message) {
    debugPrint("_handleMessage ${message.notification} ${message.data}");
    _showLocalNotification(_flutterLocalNotificationsPlugin, message);
  }

  static Future<void> _showLocalNotification(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    RemoteMessage message,
  ) async {
    debugPrint(
        "_showLocalNotification ${message.notification} ${message.data}");
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
      message.data['title'],
      message.data['body'],
      platformChannelSpecifics,
    );
  }

  Future<void> initializeFCM(String driverId) async {
    try {
      final String? fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken != null) {
        _firestoreRepository.refreshFCMToken(driverId, fcmToken);
      }
      FirebaseMessaging.instance.onTokenRefresh.listen((event) {
        _firestoreRepository.refreshFCMToken(driverId, event);
      });
    } catch (error) {
      debugPrint("Error initializing FCM: $error");
    }
  }
}
