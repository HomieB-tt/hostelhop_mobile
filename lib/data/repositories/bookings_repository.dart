import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/models.dart';

class BookingsRepository {
  final SupabaseClient _supabase;

  BookingsRepository(this._supabase);

  Future<String> createBooking({
    required String studentId,
    required String roomId,
    required int amount,
  }) async {
    final response = await _supabase.from('bookings').insert({
      'student_id': studentId,
      'room_id': roomId,
      'status': 'pending',
      'amount': amount,
      'check_in_date': DateTime.now().toIso8601String(),
      'check_out_date': DateTime.now().add(const Duration(days: 120)).toIso8601String(),
    }).select('id').single();
    
    return response['id'] as String;
  }

  Future<List<Booking>> getMyBookings(String studentId) async {
    try {
      final response = await _supabase
          .from('bookings')
          .select('''
            *,
            rooms (
              room_type,
              room_number,
              price_per_semester,
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
        final price = room?['price_per_semester'];
        
        return Booking(
          id: json['id'] as String,
          studentName: profile?['full_name'] as String? ?? 'Student',
          hostelName: hostel?['name'] as String? ?? 'Hostel',
          roomNumber: room?['room_number'] as String? ?? '',
          roomType: room?['room_type'] as String? ?? '',
          checkInDate: json['check_in_date'] != null ? DateTime.parse(json['check_in_date']) : DateTime.now(),
          checkOutDate: json['check_out_date'] != null ? DateTime.parse(json['check_out_date']) : DateTime.now().add(const Duration(days: 120)),
          status: json['status'] as String,
          amount: price != null ? (price as num).toInt() : 0,
          createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
        );
      }).toList();
    } catch (e) {
      // If room_number column still doesn't exist (migration not applied yet),
      // retry without it
      if (e.toString().contains('room_number')) {
        return _getBookingsFallback(studentId);
      }
      rethrow;
    }
  }

  /// Fallback query without room_number for backwards compatibility.
  Future<List<Booking>> _getBookingsFallback(String studentId) async {
    final response = await _supabase
        .from('bookings')
        .select('''
          *,
          rooms (
            room_type,
            price_per_semester,
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
      final price = room?['price_per_semester'];
      
      return Booking(
        id: json['id'] as String,
        studentName: profile?['full_name'] as String? ?? 'Student',
        hostelName: hostel?['name'] as String? ?? 'Hostel',
        roomNumber: '',
        roomType: room?['room_type'] as String? ?? '',
        checkInDate: json['check_in_date'] != null ? DateTime.parse(json['check_in_date']) : DateTime.now(),
        checkOutDate: json['check_out_date'] != null ? DateTime.parse(json['check_out_date']) : DateTime.now().add(const Duration(days: 120)),
        status: json['status'] as String,
        amount: price != null ? (price as num).toInt() : 0,
        createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      );
    }).toList();
  }
}
