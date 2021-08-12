import 'package:flutter/material.dart';
import 'package:jangle_app/classes/room.dart';
import 'package:jangle_app/screens/chatScreen.dart';
// import 'package:jangle_app/screens/chatScreen.dart';

class RoomTile extends StatelessWidget {
  final Room room;
  RoomTile({
    Key? key,
    required this.room,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.lightBlue[100],
      child: ListTile(
        contentPadding: EdgeInsets.all(10),
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
            room.roomName.substring(0, 1).toUpperCase(),
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
        title:
            Text(room.roomName[0].toUpperCase() + room.roomName.substring(1)),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                room: room,
              ),
            ),
          );
        },
      ),
    );
  }
}
