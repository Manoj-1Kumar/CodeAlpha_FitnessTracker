class WaterLog {
  final int? id;
  final int amount; // in ml
  final String date; // 'yyyy-MM-dd'
  final String timestamp; // 'hh:mm a' or ISO

  WaterLog({
    this.id,
    required this.amount,
    required this.date,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'date': date,
      'timestamp': timestamp,
    };
  }

  factory WaterLog.fromMap(Map<String, dynamic> map) {
    return WaterLog(
      id: map['id'],
      amount: map['amount'],
      date: map['date'],
      timestamp: map['timestamp'] ?? '',
    );
  }
}
