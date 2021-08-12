class User {
  final String firstName, lastName, userId, phoneNumber;

  User({
    required this.firstName,
    required this.lastName,
    required this.userId,
    required this.phoneNumber,
  });

  factory User.fromData(Map<String, dynamic> data) {
    return User(
        firstName: data['firstName'],
        lastName: data['lastName'],
        userId: data['_id'],
        phoneNumber: data['phoneNumber']);
  }
}
