class UserStats {
   int? trainingTime;
   int? steps;
   double? calories;
    Duration? sleep;
   double? water;
   int? heartRate;

  UserStats({
    this.trainingTime = 0,
    this.steps = 0,
    this.calories = 0.0,
    this.sleep = const Duration(hours: 0, minutes: 0),
    this.water = 0.0,
    this.heartRate = 0,
  });

  Map<String, dynamic> toMap() {
  return {
    'calories': calories,
    'heartRate': heartRate,
    'sleep': sleep?.inMinutes, // conversion en minutes
    'steps': steps,
    'trainingTime': trainingTime,
    'water': water, 
  };
}


  factory UserStats.fromMap(Map<String, dynamic> map) {
  return UserStats(
    calories: (map['calories'] ?? 0).toDouble(),
    heartRate: map['heartRate'] ?? 0,
    sleep: map['sleep'] != null
        ? Duration(minutes: map['sleep'])
        : const Duration(hours: 0, minutes: 0),
    steps: map['steps'] ?? 0,
    trainingTime: map['trainingTime'] ?? 0,
    water: (map['water'] ?? 0).toDouble(),
  );
}

}
