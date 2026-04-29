import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hostelhop_mobile/services/notifications_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'providers/theme_provider.dart';
import 'core/routing/app_router.dart';

/// Root application widget.
class HostelHopApp extends ConsumerStatefulWidget {
  const HostelHopApp({super.key});

  @override
  ConsumerState<HostelHopApp> createState() => _HostelHopAppState();
}

class _HostelHopAppState extends ConsumerState<HostelHopApp> {
  @override
  void initState() {
    super.initState();
    _setupFirebaseMessaging();
  }

  void _setupFirebaseMessaging() {
    // Request notification permissions
    FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // Listen to Firebase messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        showNotification(
          message.notification!.title ?? 'Notification',
          message.notification!.body ?? 'You have a new notification',
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final goRouter = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'HostelHop',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: goRouter,
    );
  }
}
