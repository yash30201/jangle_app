import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:jangle_app/classes/message.dart';
import 'package:jangle_app/classes/room.dart';
import 'package:jangle_app/locator.dart';
import 'package:jangle_app/services/httpRequests.dart';
import 'package:jangle_app/services/socketio.dart';
import 'package:jangle_app/widgets/MessageTile.dart';
import 'package:jangle_app/widgets/messageTextField.dart';

class ChatScreen extends StatefulWidget {
  final Room room;
  const ChatScreen({
    Key? key,
    required this.room,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _controller = ScrollController();
  final TextEditingController _inputController = TextEditingController();
  List<Message> messageList = [];
  bool isLoading = true, firstTime = true;

  Widget _chatMessages() {
    return ListView.builder(
      itemCount: messageList.length,
      controller: _controller,
      // reverse: true,
      itemBuilder: (context, index) {
        return MessageTile(message: messageList[index]);
      },
    );
  }

  Future jumpToBottom() async {
    if (_controller.hasClients)
      while (
          _controller.position.pixels != _controller.position.maxScrollExtent) {
        _controller.jumpTo(_controller.position.maxScrollExtent);
        await SchedulerBinding.instance!.endOfFrame;
      }
  }

  _fetchMessages() async {
    var messages;
    await locator
        .get<HttpRequests>()
        .getMessagesByRoomId(widget.room.roomId)
        .then((value) {
      messages = value['recentMessages'];
      List<Message> _messageList = [];
      for (int i = 0; i < messages.length; i++) {
        Message message = Message.fromData(messages[i]);
        _messageList.add(message);
      }
      setState(() {
        this.messageList = _messageList;
      });
      setState(() {
        isLoading = false;
      });
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
        await jumpToBottom();
      });
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('[500] Internal server error\nPlease restart the app..'),
      ));
    });
  }

  _updateMessages(data) async {
    if (this.mounted) {
      Message newMessage = Message.fromData(data);
      setState(() {
        this.messageList.add(newMessage);
      });
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
        await jumpToBottom();
      });
    }
  }

  _sendMessage() async {
    if (_inputController.text.isNotEmpty) {
      var post;
      await locator
          .get<HttpRequests>()
          .postMessage(_inputController.text, widget.room.roomId)
          .then((value) {
        post = value['post'];
        _inputController.clear();
        Message message = Message.fromData(post);
        locator
            .get<SocketIo>()
            .socket
            .emit('send message', [message.roomId, post]);
        setState(() {
          this.messageList.add(message);
        });
        WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
          await jumpToBottom();
        });
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text('[500] Internal server error\nPlease restart the app..'),
        ));
      });
    }
  }

  @override
  void initState() {
    _fetchMessages();
    locator.get<SocketIo>().socket.connect();
    locator.get<SocketIo>().socket.on('new message', _updateMessages);
    super.initState();
  }

  @override
  void dispose() {
    locator.get<SocketIo>().socket.off('new message', _updateMessages);
    _controller.dispose();
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.room.roomName[0].toUpperCase() +
            widget.room.roomName.substring(1)),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 10.0),
        child: Column(
          children: [
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _chatMessages(),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 5.0),
              color: Colors.transparent,
              child: Row(
                children: [
                  Expanded(
                    child: MessageTextField(
                      controller: _inputController,
                    ),
                  ),
                  SizedBox(width: 5.0),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.lightBlue[300],
                    ),
                    child: GestureDetector(
                      onTap: () {
                        _sendMessage();
                      },
                      child: Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
