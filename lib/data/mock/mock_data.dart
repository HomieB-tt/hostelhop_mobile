import '../models/models.dart';

/// Mock data ported from hostelhop_admin for consistent development.
class MockData {
  MockData._();

  // ── Current student ──
  static const studentProfile = StudentProfile(
    id: 's-02',
    fullName: 'Brian Sserwadda',
    phone: '+256 772 345 012',
    email: 'brian.s@students.mak.ac.ug',
    studentNumber: '2100704321',
    university: 'Makerere University',
    avatarInitials: 'BS',
  );

  // ── Hostels ──
  static final List<Hostel> hostels = [
    Hostel(
      id: 'hostel-01',
      name: 'Olympia Hostel',
      address: 'Wandegeya',
      description:
          'Modern 3-storey hostel with 24-hr security, backup generator, and rooftop study lounge. Popular with Arts and Business students.',
      amenities: [
        'Fast WiFi',
        '24/7 Security',
        'Study Room',
        'Generator',
        'Cleaning Service',
      ],
      images: [
        'https://images.unsplash.com/photo-1555854817-5b2260d50c47?q=80&w=800&auto=format&fit=crop',
      ],
      ownerId: 'owner-001',
      rating: 4.3,
      reviewCount: 186,
      distanceFromCampus: '0.4km from Makerere',
      rooms: _makeRooms('hostel-01', 12, 280000),
    ),
    Hostel(
      id: 'hostel-02',
      name: 'Aryan Hostel',
      address: 'Kikoni Road, Wandegeya',
      description:
          'Spacious rooms with air conditioning and en-suite bathrooms. 700m from Makerere Main Gate.',
      amenities: [
        'Fast WiFi',
        'Air Con',
        '24/7 Security',
        'Hot Shower',
        'Study Room',
        'Kitchen',
      ],
      images: [
        'https://images.unsplash.com/photo-1595526114035-0d45ed16cfbf?q=80&w=800&auto=format&fit=crop',
      ],
      ownerId: 'owner-001',
      rating: 4.2,
      reviewCount: 148,
      distanceFromCampus: '0.7km from Makerere',
      rooms: _makeRooms('hostel-02', 5, 520000),
    ),
    Hostel(
      id: 'hostel-03',
      name: 'Kiwamirembe Hostel',
      address: 'Nakulabye, off Bombo Road',
      description:
          'Budget-friendly hostel with spacious quad rooms. Ideal for students who want value for money.',
      amenities: ['WiFi', 'Security', 'Water Tank', 'Parking'],
      images: [
        'https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af?q=80&w=800&auto=format&fit=crop',
      ],
      ownerId: 'owner-001',
      rating: 3.8,
      reviewCount: 92,
      distanceFromCampus: '1.2km from Makerere',
      rooms: _makeRooms('hostel-03', 18, 180000),
    ),
    Hostel(
      id: 'hostel-04',
      name: 'Kampala Heights',
      address: 'Makerere Hill Road',
      description:
          'Premium singles and doubles with en-suite bathrooms, fiber internet, and a ground-floor cafeteria.',
      amenities: [
        'Fast WiFi',
        '24/7 Security',
        'En-suite',
        'Cafeteria',
        'Generator',
        'CCTV',
      ],
      images: [
        'https://images.unsplash.com/photo-1555854817-5b2260d50c47?q=80&w=800&auto=format&fit=crop',
      ],
      ownerId: 'owner-001',
      rating: 4.6,
      reviewCount: 214,
      distanceFromCampus: '0.3km from Makerere',
      rooms: _makeRooms('hostel-04', 8, 650000),
    ),
    Hostel(
      id: 'hostel-05',
      name: 'Nsibirwa Annex',
      address: 'Wandegeya, near MUK',
      description:
          'Renovated annex with quad rooms ideal for budget-conscious students. 5 minutes from campus.',
      amenities: ['WiFi', 'Security', 'Water Tank', 'Parking', 'Study Room'],
      images: [
        'https://images.unsplash.com/photo-1595526114035-0d45ed16cfbf?q=80&w=800&auto=format&fit=crop',
      ],
      ownerId: 'owner-001',
      rating: 3.9,
      reviewCount: 78,
      distanceFromCampus: '0.5km from Makerere',
      rooms: _makeRooms('hostel-05', 22, 220000),
    ),
  ];

  static List<Room> _makeRooms(String hostelId, int available, int price) {
    final total = available + 8; // some rooms occupied
    return List.generate(total, (i) {
      return Room(
        id: '$hostelId-room-$i',
        roomType: i % 3 == 0 ? 'Single' : (i % 3 == 1 ? 'Double' : 'Triple'),
        maxOccupancy: i % 3 == 0 ? 1 : (i % 3 == 1 ? 2 : 3),
        currentOccupancy: i < available
            ? 0
            : (i % 3 == 0 ? 1 : (i % 3 == 1 ? 2 : 3)),
        pricePerSemester: price,
        isAvailable: i < available,
        hostelId: hostelId,
        roomNumber: 'R${(i + 1).toString().padLeft(2, '0')}',
        isUnderMaintenance: i == 5, // simulate one room under maintenance
      );
    });
  }

  // ── Student bookings ──
  static final List<Booking> bookings = [
    Booking(
      id: 'bk-001',
      studentName: 'Brian Sserwadda',
      hostelName: 'Olympia Hostel',
      roomNumber: 'R03',
      roomType: 'Double',
      checkInDate: DateTime(2026, 2, 1),
      checkOutDate: DateTime(2026, 6, 30),
      status: 'paid',
      amount: 280000,
      createdAt: DateTime(2026, 1, 12),
    ),
    Booking(
      id: 'bk-002',
      studentName: 'Brian Sserwadda',
      hostelName: 'Aryan Hostel',
      roomNumber: 'R07',
      roomType: 'Single',
      checkInDate: DateTime(2026, 8, 1),
      checkOutDate: DateTime(2026, 12, 15),
      status: 'pending',
      amount: 520000,
      createdAt: DateTime(2026, 4, 20),
    ),
  ];

  // ── Payments ──
  static final List<Payment> payments = [
    Payment(
      id: 'pay-001',
      transactionId: 'TXN-20260112-001',
      hostelName: 'Olympia Hostel',
      roomNumber: 'R03',
      amount: 280000,
      method: 'MTN Mobile Money',
      status: 'completed',
      pesapalTrackingId: 'PSP-AX7K9M2',
      createdAt: DateTime(2026, 1, 12),
    ),
  ];

  // ── Universities & Campuses ──
  static const List<Map<String, dynamic>> universities = [
    {'id': 'u-01', 'name': 'Makerere University (MUK)'},
    {'id': 'u-02', 'name': 'Kyambogo University (KYU)'},
    {'id': 'u-03', 'name': 'MUBS'},
    {'id': 'u-04', 'name': 'Uganda Christian University (UCU)'},
    {'id': 'u-05', 'name': 'Kampala International University (KIU)'},
    {'id': 'u-06', 'name': 'Cavendish University'},
    {'id': 'u-07', 'name': 'Ndejje University'},
  ];

  static const List<Map<String, dynamic>> campuses = [
    {'id': 'c-01', 'univId': 'u-01', 'name': 'Main Campus (Wandegeya)'},
    {'id': 'c-02', 'univId': 'u-01', 'name': 'Kikoni'},
    {'id': 'c-03', 'univId': 'u-01', 'name': 'Kiwatule'},
    {'id': 'c-04', 'univId': 'u-02', 'name': 'Main Campus (Banda)'},
    {'id': 'c-05', 'univId': 'u-03', 'name': 'Nakawa'},
    {'id': 'c-06', 'univId': 'u-04', 'name': 'Mukono Main'},
    {'id': 'c-07', 'univId': 'u-05', 'name': 'Kansanga'},
    {'id': 'c-08', 'univId': 'u-06', 'name': 'Nsambya'},
    {'id': 'c-09', 'univId': 'u-07', 'name': 'Kampala Campus'},
  ];

  // ── Weather (hardcoded for Kampala) ──
  static const weatherTemp = 34;
  static const weatherFeelsLike = 38;
  static const weatherLocation = 'Kampala';
}

