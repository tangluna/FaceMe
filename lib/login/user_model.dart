class UserModel {
  String? firstName;
  String? lastName;
  String? email;

  UserModel({this.firstName, this.lastName, this.email});

  factory UserModel.fromFirestore(map) {
    return UserModel(
      firstName: map['First Name'] ?? "",
      lastName: map['Last Name'] ?? "",
      email: map['Email'] ?? "",
    );
  }
}
