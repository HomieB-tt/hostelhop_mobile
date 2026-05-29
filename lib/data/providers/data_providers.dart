import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/models.dart';
import '../repositories/hostels_repository.dart';
import '../repositories/bookings_repository.dart';
import '../../features/auth/providers/auth_provider.dart';

import '../mock/mock_data.dart';

final hostelsRepositoryProvider = Provider<HostelsRepository>((ref) {
  return HostelsRepository(Supabase.instance.client);
});

final hostelsProvider = FutureProvider<List<Hostel>>((ref) async {
  final repository = ref.watch(hostelsRepositoryProvider);
  try {
    final hostels = await repository.getHostels();
    if (hostels.isEmpty) {
      return MockData.hostels;
    }
    return hostels;
  } catch (e) {
    // Fallback to mock data if there's an error (e.g. no RLS policies set up yet)
    return MockData.hostels;
  }
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

class SavedHostelsNotifier extends Notifier<List<String>> {
  @override
  List<String> build() => [];
  
  void toggle(String id) {
    if (state.contains(id)) {
      state = state.where((item) => item != id).toList();
    } else {
      state = [...state, id];
    }
  }
}

final savedHostelsProvider = NotifierProvider<SavedHostelsNotifier, List<String>>(SavedHostelsNotifier.new);

class SavedRoomsNotifier extends Notifier<List<String>> {
  @override
  List<String> build() => [];
  
  void toggle(String id) {
    if (state.contains(id)) {
      state = state.where((item) => item != id).toList();
    } else {
      state = [...state, id];
    }
  }
}

final savedRoomsProvider = NotifierProvider<SavedRoomsNotifier, List<String>>(SavedRoomsNotifier.new);
