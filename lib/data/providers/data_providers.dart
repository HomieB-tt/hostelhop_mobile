import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/models.dart';
import '../repositories/hostels_repository.dart';
import '../repositories/bookings_repository.dart';
import '../../features/auth/providers/auth_provider.dart';

final hostelsRepositoryProvider = Provider<HostelsRepository>((ref) {
  return HostelsRepository(Supabase.instance.client);
});

final hostelsProvider = FutureProvider<List<Hostel>>((ref) async {
  final repository = ref.watch(hostelsRepositoryProvider);
  return repository.getHostels();
});

final bookingsRepositoryProvider = Provider<BookingsRepository>((ref) {
  return BookingsRepository(Supabase.instance.client);
});

final myBookingsProvider = FutureProvider<List<Booking>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];
  
  final repository = ref.watch(bookingsRepositoryProvider);
  return repository.getMyBookings(user.id);
});
