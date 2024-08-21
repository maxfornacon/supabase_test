import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:supabase_test/services/service_locator.dart';
import 'package:supabase_test/services/supabase_api.dart';

class NotificationsService {
  final _notifications = BehaviorSubject<List<Map<String, dynamic>>>();

  Stream<List<Map<String, dynamic>>> get notifications => _notifications.stream;

  final supabaseApi = locator.get<SupabaseApi>();

  Future<void> initStream() async {
    supabaseApi.getNotificationsStream(userId: '9418ce33-6349-45aa-895e-78e4423155dc').listen((documents) async {
      _notifications.add(documents);
    });
  }
}
