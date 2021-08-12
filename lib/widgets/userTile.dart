import 'package:flutter/material.dart';
import 'package:jangle_app/classes/room.dart';
import 'package:jangle_app/classes/user.dart';
import 'package:jangle_app/locator.dart';
import 'package:jangle_app/screens/chatScreen.dart';
import 'package:jangle_app/services/httpRequests.dart';
import 'package:jangle_app/services/socketio.dart';
import 'package:jangle_app/store.dart';
import 'package:provider/provider.dart';
// import 'package:jangle_app/screens/chatScreen.dart';

class UserTile extends StatefulWidget {
  final User user;
  UserTile({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  _UserTileState createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {
  final selfUserId = locator.get<HttpRequests>().userId;
  _initiateChat() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Initiating chat...\nPlease wait'),
    ));
    locator
        .get<HttpRequests>()
        .initiateRoom([widget.user.userId]).then((value) {
      locator
          .get<HttpRequests>()
          .getRoomById(value['room']['roomId'])
          .then((result) {
        List<String> userIds = [];
        result['room']['userIds'].forEach((participant) {
          userIds.add(participant[0]['_id']);
        });
        locator.get<SocketIo>().socket.emit('join room',
            [result['room']['_id'], selfUserId, widget.user.userId]);
        // locator.get<SocketIo>().socket.emit('new conversation', [userIds]);

        String name = context.read<Store>().getRoomName(userIds);
        Room room = Room.fromData2(result['room'], name, userIds);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(room: room),
          ),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text('[500] Internal server error\nPlease restart the app..'),
        ));
      });
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('[500] Internal server error\nPlease restart the app..'),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        leading: Container(
          height: 40,
          width: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.lightBlue[100],
            border: Border.all(
              color: Colors.black,
              width: 1,
            ),
            shape: BoxShape.circle,
          ),
          child: Text(
            widget.user.firstName[0].toUpperCase(),
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
        title: Text(
          widget.user.firstName[0].toUpperCase() +
              widget.user.firstName.substring(1) +
              ' ' +
              widget.user.lastName[0].toUpperCase() +
              widget.user.lastName.substring(1),
        ),
        onTap: () {
          _initiateChat();
        },
      ),
    );
  }
}
