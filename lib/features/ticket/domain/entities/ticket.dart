class Ticket {
  int? id;
  String userName;
  String location;
  String contact;
  String issueDescription;
  bool emergency;

  Ticket({
    this.id,
    required this.userName,
    required this.location,
    required this.contact,
    required this.issueDescription,
    required this.emergency
  });

  //map -> note
  factory Ticket.fromMap(Map<String, dynamic> map) {
    return Ticket(
      id: map['id'] as int,
      userName: map['userName'] as String,
      location: map['location'] as String,
      contact: map['contact'] as String,
      issueDescription: map['issueDescription'] as String, 
      emergency: map['emergency'] as bool,
    );
  }

  //note -> map
  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'location': location,
      'contact': contact,
      'issueDescription': issueDescription,
      'emergency': emergency
    };
  }
}
