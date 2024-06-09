class HabitProgress {
  int? id;
  int? userHabitId;
  String? date_progress;
  int isDone = 0;

  HabitProgress({
    this.id,
    required this.userHabitId,
    required this.date_progress,
    required this.isDone,
  });

  // Convert a HabitProgress into a Map.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataHp = <String, dynamic>{};
    dataHp['id']= id;
    dataHp['userHabitId']= userHabitId;
    dataHp['date_progress']= date_progress;
    dataHp['isDone']= isDone;

    return dataHp;
  }

  // Extract a HabitProgress from a Map.
  HabitProgress.fromJson(Map<String, dynamic> json) {
    id= json['id'];
    userHabitId= json['userHabitId'];
    date_progress= json['date_progress'];
    isDone= json['isDone'];
  }
}
