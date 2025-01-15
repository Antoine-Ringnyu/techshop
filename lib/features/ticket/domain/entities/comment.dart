class Comment {
  final int id;
  final String ticketId;
  final String userId;
  final String technicianName;
  final String text;
  final DateTime timestamp;

  Comment({
    required this.id,
    required this.ticketId,
    required this.userId,
    required this.technicianName,
    required this.text,
    required this.timestamp,
  });

  //map -> comment
  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'] as int,
      ticketId: map['ticketId'] as String,
      userId: map['userId'] as String,
      technicianName: map['technicianName'] as String,
      text: map['text'] as String,
      timestamp: map['timestamp'] as DateTime,
    );
  }

  //comment -> map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ticketId': ticketId,
      'userId': userId,
      'technicianName': technicianName,
      'text': text,
      'timestamp': timestamp,
    };
  }
}
