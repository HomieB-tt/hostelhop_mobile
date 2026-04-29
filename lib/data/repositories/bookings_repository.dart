import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/models.dart';

class BookingsRepository {
  final SupabaseClient _supabase;

  BookingsRepository(this._supabase);

  Future<List<Booking>> getMyBookings(String studentId) async {
    try {
      final response = await _supabase
          .from('bookings')
          .select('''
            *,
            rooms (
              room_type,
              room_number,
              hostels (
                name
              )
            ),
            profiles:student_id (
              full_name
            )
          ''')
          .eq('student_id', studentId)
          .order('created_at', ascending: false);

      return (response as List<dynamic>).map((json) {
        final room = json['rooms'];
        final hostel = room?['hostels'];
        final profile = json['profiles'];
        
        return Booking(
          id: json['id'] as String,
          studentName: profile?['full_name'] as String? ?? 'Student',
          hostelName: hostel?['name'] as String? ?? 'Hostel',
          roomNumber: room?['room_number'] as String? ?? '',
          roomType: room?['room_type'] as String? ?? '',
          checkInDate: json['check_in_date'] != null ? DateTime.parse(json['check_in_date']) : DateTime.now(),
          checkOutDate: json['check_out_date'] != null ? DateTime.parse(json['check_out_date']) : DateTime.now().add(const Duration(days: 120)),
          status: json['status'] as String,
          amount: 0, // Amount needs to be fetched from payments or calculated
          createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
        );
      }).toList();
    } catch (e) {
      rethrow;
    }
  }
}
