import 'package:jangle_app/classes/user.dart';
import 'package:jangle_app/locator.dart';
import 'package:jangle_app/services/httpRequests.dart';

class BlueTick {
  final String userId;
  final String readAt;
  BlueTick({
    required this.userId,
    required this.readAt,
  });

  factory BlueTick.fromData(Map<String, dynamic> data) {
    return BlueTick(
      userId: data['userId'],
      readAt: data['readAt'],
    );
  }
}

class Message {
  final String messageId;
  final String roomId;
  final String content;
  final User postedByUser;
  final List<BlueTick> readBy;
  final String postedAt;
  final bool isMine;

  Message({
    required this.messageId,
    required this.roomId,
    required this.content,
    required this.postedByUser,
    required this.readBy,
    required this.postedAt,
    required this.isMine,
  });

  factory Message.fromData(Map<String, dynamic> data) {
    String myUserId = locator.get<HttpRequests>().userId;
    User postedByUser = User.fromData(data['postedByUser']);
    List<BlueTick> readBy = [];
    data['blueTicks']?.forEach((user) {
      readBy.add(BlueTick.fromData(user));
    });
    data['readByRecipients']?.forEach((user) {
      readBy.add(BlueTick.fromData(user));
    });
    bool isMine = (myUserId == postedByUser.userId);
    return Message(
      content: data['message'],
      isMine: isMine,
      messageId: data['_id'],
      postedAt: data['createdAt'],
      postedByUser: postedByUser,
      readBy: readBy,
      roomId: data['roomId'],
    );
  }
}
