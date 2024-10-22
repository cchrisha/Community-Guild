import 'dart:async';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationController {
  static Timer? _timer;
  static String? userEmail; // Store the user's email

  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(ReceivedNotification receivedNotification) async {
    // Handle notification creation
  }

  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(ReceivedNotification receivedNotification) async {
    // Handle notification display
  }

  @pragma("vm:entry-point")
  static Future<void> onDismissActionRecievedMethod(ReceivedAction receivedAction) async {
    // Handle notification dismissal
  }

  // Start polling for notifications
  static void startPolling(String email) {
    userEmail = email; // Store the email for fetching notifications
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      fetchNotifications();
    });
  }

  // Stop polling
  static void stopPolling() {
    _timer?.cancel();
  }

  // Fetch notifications from the server
  static Future<void> fetchNotifications() async {
    if (userEmail == null) return;

    final response = await http.get(Uri.parse('https://yourapiurl.com/api/notifications/user/$userEmail'));

    if (response.statusCode == 200) {
      List notifications = json.decode(response.body);
      for (var notification in notifications) {
        print('Notification: ${notification['body']}');
        // You can also trigger Awesome Notifications here if needed
      }
    } else {
      print('Error fetching notifications: ${response.body}');
    }
  }
}
