import 'package:get_it/get_it.dart';
import 'package:supabase_test/services/supabase_api.dart';
import 'notifications_service.dart';

final locator = GetIt.instance;

void setupGetIt() {
  locator.registerSingleton<SupabaseApi>(SupabaseApi());
  locator.registerSingleton<NotificationsService>(NotificationsService());
}
