class Room {
  final String roomId, roomName, lastActivity, roomInitiator;
  final List<String> participants;

  Room({
    required this.roomId,
    required this.roomName,
    required this.lastActivity,
    required this.roomInitiator,
    required this.participants,
  });

  factory Room.fromData(Map<String, dynamic> data, String name) {
    List<String> participants = data['userIds'].cast<String>();
    return Room(
      roomId: data['_id'],
      roomName: name,
      lastActivity: data['updatedAt'],
      roomInitiator: data['roomInitiator'],
      participants: participants,
    );
  }

  factory Room.fromData2(
      Map<String, dynamic> data, String name, List<String> participants) {
    return Room(
      roomId: data['_id'],
      roomName: name,
      lastActivity: data['updatedAt'],
      roomInitiator: data['roomInitiator']['_id'],
      participants: participants,
    );
  }
}
