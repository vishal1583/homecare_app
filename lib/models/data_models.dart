class User {
  final int? id;
  final String? userName;
  final String? userEmail;
  final String? userPassword;
  final String? userPhoneno;
  final String? userAddress;

  User({
    this.id,
    this.userName,
    this.userEmail,
    this.userPassword,
    this.userPhoneno,
    this.userAddress,
  });

  factory User.fromJson(Map<String, dynamic> jsonData) {
    return User(
      id: jsonData['id'],
      userName: jsonData['username'],
      userEmail: jsonData['email'],
      userPassword: jsonData['password'],
      userPhoneno: jsonData['phone_no'],
      userAddress: jsonData['address'],
    );
  }
}

class ServiceProvider {
  final String id;
  final String providerName;
  final String providerEmail;
  final String providerPassword;
  final String providerPhoneno;
  final String providerLocation;
  final String providerSkills;

  ServiceProvider({
    required this.id,
    required this.providerName,
    required this.providerEmail,
    required this.providerPassword,
    required this.providerPhoneno,
    required this.providerLocation,
    required this.providerSkills,
  });

  factory ServiceProvider.fromJson(Map<String, dynamic> jsonData) {
    return ServiceProvider(
      id: jsonData['id'],
      providerName: jsonData['username'],
      providerEmail: jsonData['email'],
      providerPassword: jsonData['password'],
      providerPhoneno: jsonData['phone_no'],
      providerLocation: jsonData['location'],
      providerSkills: jsonData['skills'],
    );
  }
}

class Bookings {
  final String id;
  final String userId;
  final String providerId;
  final String dateOfBooking;
  final String timeOfBooking;
  final String status;
  String? name;

  Bookings({
    required this.id,
    required this.userId,
    required this.providerId,
    required this.dateOfBooking,
    required this.timeOfBooking,
    required this.status,
    this.name,
  });

  factory Bookings.fromJson(Map<String, dynamic> jsonData) {
    return Bookings(
      id: jsonData['id'],
      userId: jsonData['user_id'],
      providerId: jsonData['provider_id'],
      dateOfBooking: jsonData['date_of_booking'],
      timeOfBooking: jsonData['time_of_booking'],
      status: jsonData['status'],
      name: jsonData['username'] ?? 'No Name'
    );
  }
}
