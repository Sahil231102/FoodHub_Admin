class UserModel {
  final String uid;
  final String name;
  final String email;
  final String mobileNumber;
  final String gender;
  final String countryName;
  final String countryCode;
  final String state;
  final DateTime lastLoginTime;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.mobileNumber,
    required this.gender,
    required this.countryName,
    required this.countryCode,
    required this.state,
    required this.lastLoginTime,
  });

  // Factory method to convert Firestore document to UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      name: json['name'].trim(),
      email: json['email'],
      mobileNumber: json['mobile_number'],
      gender: json['gender'],
      countryName: json['country_name'],
      countryCode: json['country_code'],
      state: json['state'],
      lastLoginTime: DateTime.parse(json['last_login_time']),
    );
  }

  // Convert UserModel to JSON (for Firestore)
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'mobile_number': mobileNumber,
      'gender': gender,
      'country_name': countryName,
      'country_code': countryCode,
      'state': state,
      'last_login_time': lastLoginTime.toIso8601String(),
    };
  }
}
