class UserHabit {
  int? id;
  int? habitId;
  String? startDate;
  String? endDate;

  UserHabit({
    this.id,
    required this.habitId,
    required this.startDate,
    required this.endDate,
  });

  // Convert a UserHabit into a Map.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataUh = <String, dynamic>{};
    dataUh['id']= id;
    dataUh['habitId']= habitId;
    dataUh['startDate']= startDate;
    dataUh['endDate']= endDate;

    return dataUh;
  }

  // Extract a UserHabit from a Map.
  UserHabit.fromJson(Map<String, dynamic> json) {
    id= json['id'];
    habitId= json['habitId'];
    startDate= json['startDate'];
    endDate= json['endDate'];
  }
}
