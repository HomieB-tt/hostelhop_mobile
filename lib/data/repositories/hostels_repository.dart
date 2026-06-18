import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/models.dart';

class HostelsRepository {
  final SupabaseClient _supabase;

  HostelsRepository(this._supabase);

  Future<List<Hostel>> getHostels() async {
    try {
      final response = await _supabase
          .from('hostels')
          .select('*, rooms(*)');
          
      return (response as List<dynamic>)
          .map((json) => Hostel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Hostel> getHostel(String id) async {
    try {
      final response = await _supabase
          .from('hostels')
          .select('*, rooms(*)')
          .eq('id', id)
          .single();
          
      return Hostel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<Hostel>> getHostelsStream() {
    return _supabase
        .from('hostels')
        .stream(primaryKey: ['id'])
        .map((maps) => maps.map((json) => Hostel.fromJson(json)).toList());
  }
}
