class HabitItem {
  int? id;
  String? userId; //coba
  String? title;
  String? note;
  String? date;
  String? startTime;
  String? endTime;
  int? duration;

  HabitItem({
    this.id,
    this.userId, //coba
    required this.title,
    required this.note,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.duration,
  });

  // Convert a HabitItem into a Map.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataHi = <String, dynamic>{};
    dataHi['id']= id;
    dataHi['userId']= userId; //coba
    dataHi['title']= title;
    dataHi['note']= note;
    dataHi['date']= date;
    dataHi['startTime']= startTime;
    dataHi['endTime']= endTime;
    dataHi['duration']= duration;

    return dataHi;
  }

  // Extract a HabitItem from a Map.
  HabitItem.fromJson(Map<String, dynamic> json) {
      id = json['id'];
      userId = json['userId']; //coba
      title = json['title'].toString();
      note = json['note'];
      date = json['date'];
      startTime = json['startTime'];
      endTime = json['endTime'];
      duration = json['duration'];
  }
}
