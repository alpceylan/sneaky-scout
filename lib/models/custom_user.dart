class CustomUser {
  final String email;
  final String name;
  final String userId;
  final String photoUrl;
  final int teamNumber;
  final String createdDate;

  CustomUser({
    this.email,
    this.name,
    this.userId,
    this.photoUrl,
    this.teamNumber,
    this.createdDate,
  });

  factory CustomUser.fromFirebase(Map<String, dynamic> userMap) {
    return CustomUser(
      email: userMap["email"],
      name: userMap["name"],
      userId: userMap["userId"],
      photoUrl: userMap["photoUrl"],
      teamNumber: userMap["teamNumber"],
      createdDate: userMap["createdDate"],
    );
  }
}
