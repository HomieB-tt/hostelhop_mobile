import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/models.dart';

class ProfileRepository {
  final SupabaseClient _supabase;

  ProfileRepository(this._supabase);

  Future<StudentProfile?> getProfile(String userId) async {
    try {
      final data = await _supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (data == null) return null;

      return StudentProfile(
        id: data['id'] as String,
        fullName: data['full_name'] as String? ?? '',
        phone: data['phone_number'] as String? ?? '',
        email: data['email'] as String?,
        studentNumber: data['student_number'] as String?,
        university: data['university'] as String?,
        campusId: data['campus_id'] as String?,
        avatarInitials: data['avatar_initials'] as String?,
        isPhoneConfirmed: data['is_phone_confirmed'] as bool? ?? false,
        createdAt: data['created_at'] != null
            ? DateTime.parse(data['created_at'] as String)
            : null,
      );
    } catch (e) {
      return null;
    }
  }

  Future<void> confirmPhone(String userId) async {
    await _supabase.from('profiles').update({
      'is_phone_confirmed': true,
    }).eq('id', userId);
  }

  Future<void> updateProfile({
    required String userId,
    required String fullName,
    required String phone,
    String? email,
    String? studentNumber,
    String? university,
    String? campusId,
  }) async {
    await _supabase.from('profiles').upsert({
      'id': userId,
      'full_name': fullName,
      'phone_number': phone,
      'email': email,
      'student_number': studentNumber,
      'university': university,
      'campus_id': campusId,
      'avatar_initials': fullName.isNotEmpty
          ? fullName
              .trim()
              .split(' ')
              .where((w) => w.isNotEmpty)
              .take(2)
              .map((w) => w[0].toUpperCase())
              .join()
          : null,
    });
  }
}
