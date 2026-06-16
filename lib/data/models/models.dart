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
    this.isOnline = true,
    this.viewCount = 0,
  });

  factory Hostel.fromJson(Map<String, dynamic> json) {
    return Hostel(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      description: json['description'] as String? ?? '',
      amenities: List<String>.from(json['amenities'] ?? []),
      images: List<String>.from(json['images'] ?? []),
      ownerId: json['owner_id'] as String,
      isOnline: json['is_online'] as bool? ?? true,
      viewCount: (json['view_count'] as num?)?.toInt() ?? 0,
      rooms: (json['rooms'] as List<dynamic>?)
              ?.map((e) => Room.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
    );
  }

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
  final bool isOnline;
  final int viewCount;

  /// Whether this hostel is trending (viewed by many users).
  bool get isTrending => viewCount >= 10;

  /// Number of available rooms.
  int get availableRooms => rooms.fold(0, (sum, r) => sum + (r.isAvailable && !r.isUnderMaintenance ? (r.maxOccupancy - r.currentOccupancy) : 0));

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
    this.isUnderMaintenance = false,
    this.description = '',
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'] as String,
      roomType: json['room_type'] as String,
      maxOccupancy: json['max_occupancy'] as int,
      currentOccupancy: json['current_occupancy'] as int,
      pricePerSemester: (json['price_per_semester'] as num).toInt(),
      isAvailable: json['is_available'] as bool? ?? true,
      isUnderMaintenance: json['is_under_maintenance'] as bool? ?? false,
      hostelId: json['hostel_id'] as String,
      roomNumber: json['room_number'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }

  final String id;
  final String roomType;
  final int maxOccupancy;
  final int currentOccupancy;
  final int pricePerSemester;
  final bool isAvailable;
  final String hostelId;
  final String roomNumber;
  final bool isUnderMaintenance;
  final String description;
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
    this.studentNumber,
    this.university,
    this.campusId,
    this.avatarInitials,
    this.isPhoneConfirmed = false,
    this.createdAt,
  });

  final String id;
  final String fullName;
  final String phone;
  final String? email;
  final String? studentNumber;
  final String? university;
  final String? campusId;
  final String? avatarInitials;
  final bool isPhoneConfirmed;
  final DateTime? createdAt;
}

/// Weather data model.
class WeatherInfo {
  const WeatherInfo({
    required this.temperature,
    required this.feelsLike,
    required this.condition,
    required this.location,
    required this.humidity,
    required this.windSpeed,
  });

  factory WeatherInfo.fromJson(Map<String, dynamic> json) {
    final main = json['main'] as Map<String, dynamic>;
    final weather = (json['weather'] as List).first as Map<String, dynamic>;
    final wind = json['wind'] as Map<String, dynamic>;

    return WeatherInfo(
      temperature: (main['temp'] as num).toDouble(),
      feelsLike: (main['feels_like'] as num).toDouble(),
      condition: weather['main'] as String,
      location: json['name'] as String,
      humidity: main['humidity'] as int,
      windSpeed: (wind['speed'] as num).toDouble(),
    );
  }

  final double temperature;
  final double feelsLike;
  final String condition;
  final String location;
  final int humidity;
  final double windSpeed;
}
