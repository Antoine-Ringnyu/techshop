import 'package:techrx/features/ticket/domain/entities/comment.dart';

class Ticket {
  int? id;
  String? userId;
  String userName;
  String location;
  String contact;
  String issueDescription;
  bool emergency;
  String? status;
  String? imageUrl;
  //list of comments
  final List<Comment> comments;

  Ticket({
    this.id,
    this.userId,
    required this.userName,
    required this.location,
    required this.contact,
    required this.issueDescription,
    required this.emergency,
    this.status,
    this.imageUrl,
    required this.comments,
  });

  Ticket copywith({String? imageUrl}) {
    return Ticket(
      userId: userId,
      userName: userName,
      location: location,
      contact: contact,
      issueDescription: issueDescription,
      emergency: emergency,
      status: status,
      imageUrl: imageUrl ?? this.imageUrl,
      comments: comments
    );
  }

  //map -> ticket
  factory Ticket.fromMap(Map<String, dynamic> map) {
    return Ticket(
      id: map['id'] as int?,
      userId: map['userId'] as String?,
      userName: map['userName'] as String,
      location: map['location'] as String,
      contact: map['contact'] as String,
      issueDescription: map['issueDescription'] as String,
      emergency: map['emergency'] as bool,
      status: map['status'] as String?,
      imageUrl: map['imageUrl'] as String?,
      comments: map['comments'] as List<Comment>
    );
  }

  //tickets -> map
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'location': location,
      'contact': contact,
      'issueDescription': issueDescription,
      'emergency': emergency,
      'status': status,
      'imageUrl': imageUrl,
      'comments': comments.map((comment) => comment.toMap()).toList(),
    };
  }
}
