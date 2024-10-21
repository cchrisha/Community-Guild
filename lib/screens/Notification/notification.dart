
import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationController {

  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
    ReceivedNotification receivedNotification ) async {}

  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
    ReceivedNotification receivedNotification ) async {}

  @pragma("vm:entry-point")
  static Future<void> onDismissActionRecievedMethod(
    ReceivedAction  receivedAction  ) async {}
  }
