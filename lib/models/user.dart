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
