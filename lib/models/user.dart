class UserModel {
  int stars;
  int streak;
  DateTime? lastOpenDate;

  UserModel({
    this.stars = 0,
    this.streak = 0,
    this.lastOpenDate,
  });
}
