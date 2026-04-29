import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'services/notifications_service.dart';

/// Must be a top-level function for Firebase background messaging.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log('Handling a background message: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: String.fromEnvironment('FIREBASE_API_KEY', defaultValue: ''),
      appId: String.fromEnvironment('FIREBASE_APP_ID', defaultValue: ''),
      messagingSenderId: String.fromEnvironment(
        'FIREBASE_MESSAGING_SENDER_ID',
        defaultValue: '',
      ),
      projectId: String.fromEnvironment(
        'FIREBASE_PROJECT_ID',
        defaultValue: '',
      ),
      storageBucket: String.fromEnvironment(
        'FIREBASE_STORAGE_BUCKET',
        defaultValue: '',
      ),
    ),
  );

  // Initialize Firebase Messaging
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // Initialize Supabase
  await Supabase.initialize(
    url: String.fromEnvironment('SUPABASE_URL', defaultValue: ''),
    anonKey: String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: ''),
  );

  // Lock to portrait orientation.
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize notifications
  await initializeNotifications();

  runApp(const ProviderScope(child: HostelHopApp()));
}
