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
        name: jsonData['username'] ?? 'No Name');
  }
}
