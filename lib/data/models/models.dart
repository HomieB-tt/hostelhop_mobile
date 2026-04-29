/// Hostel model — mirrors the Supabase `hostels` + `rooms` tables.
class Hostel {
  const Hostel({
    required this.id,
    required this.name,
    required this.address,
    this.description = '',
    this.amenities = const [],
    this.images = const [],
    required this.ownerId,
    this.rating,
    this.reviewCount,
    this.rooms = const [],
    this.distanceFromCampus,
    this.createdAt,
  });

  final String id;
  final String name;
  final String address;
  final String description;
  final List<String> amenities;
  final List<String> images;
  final String ownerId;
  final double? rating;
  final int? reviewCount;
  final List<Room> rooms;
  final String? distanceFromCampus;
  final DateTime? createdAt;

  /// Number of available rooms.
  int get availableRooms => rooms.where((r) => r.isAvailable).length;

  /// Total rooms.
  int get totalRooms => rooms.length;

  /// Lowest price per semester.
  int get startingPrice {
    if (rooms.isEmpty) return 0;
    return rooms.map((r) => r.pricePerSemester).reduce((a, b) => a < b ? a : b);
  }

  /// Tags for display (e.g. "Selling Fast", "AC").
  List<String> get tags {
    final t = <String>[];
    if (availableRooms <= 5 && availableRooms > 0) t.add('Selling Fast');
    if (amenities.any(
      (a) => a.toLowerCase().contains('ac') || a.toLowerCase().contains('air'),
    )) {
      t.add('AC');
    }
    return t;
  }
}

/// Room model — mirrors the Supabase `rooms` table.
class Room {
  const Room({
    required this.id,
    required this.roomType,
    required this.maxOccupancy,
    required this.currentOccupancy,
    required this.pricePerSemester,
    required this.isAvailable,
    required this.hostelId,
    this.roomNumber = '',
  });

  final String id;
  final String roomType;
  final int maxOccupancy;
  final int currentOccupancy;
  final int pricePerSemester;
  final bool isAvailable;
  final String hostelId;
  final String roomNumber;
}

/// Booking model.
class Booking {
  const Booking({
    required this.id,
    required this.studentName,
    required this.hostelName,
    required this.roomNumber,
    required this.roomType,
    required this.checkInDate,
    required this.checkOutDate,
    required this.status,
    required this.amount,
    this.createdAt,
  });

  final String id;
  final String studentName;
  final String hostelName;
  final String roomNumber;
  final String roomType;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final String status; // pending, approved, paid, rejected, cancelled
  final int amount;
  final DateTime? createdAt;
}

/// Payment model.
class Payment {
  const Payment({
    required this.id,
    required this.transactionId,
    required this.hostelName,
    required this.roomNumber,
    required this.amount,
    required this.method,
    required this.status,
    this.pesapalTrackingId,
    this.createdAt,
  });

  final String id;
  final String transactionId;
  final String hostelName;
  final String roomNumber;
  final int amount;
  final String method; // 'MTN Mobile Money' | 'Airtel Money'
  final String status; // pending, completed, failed
  final String? pesapalTrackingId;
  final DateTime? createdAt;
}

/// Student profile.
class StudentProfile {
  const StudentProfile({
    required this.id,
    required this.fullName,
    required this.phone,
    this.email,
    this.university,
    this.avatarInitials,
    this.createdAt,
  });

  final String id;
  final String fullName;
  final String phone;
  final String? email;
  final String? university;
  final String? avatarInitials;
  final DateTime? createdAt;
}
