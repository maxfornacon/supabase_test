import 'dart:async';


import 'package:supabase_flutter/supabase_flutter.dart' as s;

class SupabaseApi {

  final supabase = s.Supabase.instance.client;

  /// Get notifications stream for currentUser
  Stream<List<Map<String, dynamic>>> getNotificationsStream({
    required String userId
  }) {
    return supabase
      .from('notifications')
      .stream(primaryKey: ['id'])
      .eq('employee_id', userId);
  }
}