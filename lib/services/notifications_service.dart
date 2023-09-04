import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:supabase_test/services/service_locator.dart';
import 'package:supabase_test/services/supabase_api.dart';

class NotificationsService {
  final _notifications = BehaviorSubject<List<Map<String, dynamic>>>();

  Stream<List<Map<String, dynamic>>> get notifications => _notifications.stream;

  final supabaseApi = locator.get<SupabaseApi>();

  Future<void> initStream() async {
    supabaseApi.getNotificationsStream(userId: '0a6ce416-af8d-4881-bfdc-7ecee3da2bd8').listen((documents) async {
      _notifications.add(documents);
    });
  }
}
