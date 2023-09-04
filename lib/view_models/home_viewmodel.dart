import 'dart:async';

import 'package:stacked/stacked.dart';
import '../services/notifications_service.dart';
import '../services/service_locator.dart';

class HomeViewModel extends BaseViewModel {
  final notificationsService = locator.get<NotificationsService>();

  List<Map<String, dynamic>> notifications = [];
  late StreamSubscription subscription;

  void initialise() async {
    await notificationsService.initStream();
    getNotifications();
    setInitialised(true);
  }

  void getNotifications() {
    subscription = notificationsService.notifications.listen((List<Map<String, dynamic>> event) {
      notifications = event;
      notifyListeners();
    },
    onError: (error) {
      print(error);
    });
  }
}