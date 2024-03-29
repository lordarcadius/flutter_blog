import 'package:envied/envied.dart';

part 'supabase_env.g.dart';

@Envied(path: '.env.supabase')
abstract class SupabaseEnv {
  @EnviedField(varName: 'SUPABASE_URL')
  static const String supabaseUrl = _SupabaseEnv.supabaseUrl;
  @EnviedField(varName: 'SUPABASE_KEY')
  static const String supabaseKey = _SupabaseEnv.supabaseKey;
}
