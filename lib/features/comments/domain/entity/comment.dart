class Comment {
  final int? id;
  final int ticketId;
  final String userId;
  final String note;

  Comment({
    required this.id,
    required this.userId,
    required this.ticketId,
    required this.note,
  });

  //map -> comment
  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'] as int?,
      userId: map['userId'] as String,
      ticketId: map['ticketId'] as int,
      note: map['note'] as String,
    );
  }

  //comment -> map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'ticketId': ticketId,
      'note': note,
    };
  }
}
