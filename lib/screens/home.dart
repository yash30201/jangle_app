import 'package:flutter/material.dart';
import 'package:jangle_app/classes/room.dart';
import 'package:jangle_app/locator.dart';
import 'package:jangle_app/services/httpRequests.dart';
import 'package:jangle_app/services/socketio.dart';
import 'package:jangle_app/store.dart';
import 'package:jangle_app/widgets/roomTile.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading = true;
  List<Room> rooms = [];
  String userId = locator.get<HttpRequests>().userId;
  Widget usersList() {
    return ListView.builder(
      itemCount: rooms.length,
      itemBuilder: (context, index) {
        return RoomTile(
          room: rooms[index],
        );
      },
    );
  }

  loader() async {
    locator.get<SocketIo>().socket.emit('add user to list', [userId]);
    locator.get<HttpRequests>().getAllMyRooms().then((value) {
      final rooms = value['rooms'].cast<Map<String, dynamic>>();
      List<Room> current = [];
      rooms.forEach((room) {
        String name =
            context.read<Store>().getRoomName(room['userIds'].cast<String>());
        Room varRoom = Room.fromData(room, name);
        current.add(varRoom);
      });
      setState(() {
        this.rooms = current;
      });
      setState(() {
        this.isLoading = false;
      });
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('[500] Internal server error\nPlease restart the app..'),
      ));
    });
  }

  _refreshRoom(data1) async {
    if (this.mounted) {
      locator.get<HttpRequests>().getAllMyRooms().then((value) {
        final rooms = value['rooms'].cast<Map<String, dynamic>>();
        List<Room> current = [];
        rooms.forEach((room) {
          String name =
              context.read<Store>().getRoomName(room['userIds'].cast<String>());
          Room varRoom = Room.fromData(room, name);
          current.add(varRoom);
        });
        setState(() {
          this.rooms = current;
        });
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text('[500] Internal server error\nPlease restart the app..'),
        ));
      });
    }
  }

  _signOut() async {
    final pref = await SharedPreferences.getInstance();
    pref.clear();
    Navigator.pushNamedAndRemoveUntil(context, '/loading', (route) => false);
  }

  @override
  void initState() {
    super.initState();
    locator.get<SocketIo>().socket.connect();
    locator.get<SocketIo>().socket.on('new conversation', _refreshRoom);
    locator.get<SocketIo>().socket.on('new message', _refreshRoom);
    loader();
  }

  @override
  void dispose() {
    locator.get<SocketIo>().socket.off('new conversation', _refreshRoom);
    locator.get<SocketIo>().socket.off('new message', _refreshRoom);
    locator.get<SocketIo>().socket.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text("Jangle"),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              _signOut();
            },
            child: Container(
              padding: EdgeInsets.only(left: 5, right: 10),
              child: Icon(
                Icons.exit_to_app,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/search');
        },
        child: Icon(Icons.add),
      ),
      body:
          isLoading ? Center(child: CircularProgressIndicator()) : usersList(),
    );
  }
}
