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
