import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/constants/app_constants.dart';
import 'services/notifications_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/shared_preferences_provider.dart';

/// Must be a top-level function for Firebase background messaging.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log('Handling a background message: ${message.messageId}');
}

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    final missing = AppConstants.missingRequired;
    if (missing.isNotEmpty) {
      throw StateError(
        'Missing build configuration: ${missing.join(', ')}.\n'
        'Run with --dart-define-from-file=.env (see README).',
      );
    }

    // Initialize Firebase
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: AppConstants.firebaseApiKey,
        appId: AppConstants.firebaseAppId,
        messagingSenderId: AppConstants.firebaseMessagingSenderId,
        projectId: AppConstants.firebaseProjectId,
        storageBucket: AppConstants.firebaseStorageBucket.isEmpty
            ? null
            : AppConstants.firebaseStorageBucket,
      ),
    );

    // Initialize Firebase Messaging
    await FirebaseMessaging.instance.setAutoInitEnabled(true);
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Initialize Supabase
    await Supabase.initialize(
      url: AppConstants.supabaseUrl,
      anonKey: AppConstants.supabaseAnonKey,
    );

    // Lock to portrait orientation.
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Initialize notifications
    await initializeNotifications();
    
    // Initialize Shared Preferences
    final prefs = await SharedPreferences.getInstance();

    runApp(ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const HostelHopApp(),
    ));
  } catch (e, stackTrace) {
    log('Initialization error: $e');
    log('Stack trace: $stackTrace');
    // Run a minimal error app to avoid white screen
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: SelectableText('App failed to start:\n$e'),
        ),
      ),
    ));
  }
}
