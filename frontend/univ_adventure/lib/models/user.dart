class User {
  var username;
  var badges;
  var createdAt;
  var email;
  var gender;
  var points;
  var questsCompleted;
  var userID;

  User({
    required this.badges,
    required this.createdAt,
    required this.email,
    required this.gender,
    required this.points,
    required this.questsCompleted,
    required this.userID,
    required this.username,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      badges: List<String>.from(map['badges']),
      createdAt: map['createdAt'].toDate(),
      email: map['email'],
      gender: map['gender'],
      points: map['points'],
      questsCompleted: List<String>.from(map['questsCompleted']),
      userID: map['userID'],
      username: map['username'],
    );
  }
}