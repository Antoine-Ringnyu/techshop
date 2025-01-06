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

  Ticket(
      {this.id,
      this.userId,
      required this.userName,
      required this.location,
      required this.contact,
      required this.issueDescription,
      required this.emergency,
      this.status,
      this.imageUrl});

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
    };
  }
}
