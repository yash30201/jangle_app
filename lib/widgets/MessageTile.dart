import 'package:flutter/material.dart';
import 'package:jangle_app/classes/message.dart';
import 'package:jangle_app/styles.dart';

class MessageTile extends StatelessWidget {
  final Message message;
  const MessageTile({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: message.isMine
          ? EdgeInsets.only(
              bottom: messageTileMargin,
              top: messageTileMargin,
              right: 15.0,
            )
          : EdgeInsets.only(
              bottom: messageTileMargin,
              top: messageTileMargin,
              left: 15.0,
            ),
      width: MediaQuery.of(context).size.width * 0.85,
      alignment: message.isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: message.isMine ? messageColor1 : messageColor2,
          borderRadius: message.isMine
              ? BorderRadius.only(
                  topLeft: Radius.circular(messageTileBorderRadius),
                  bottomLeft: Radius.circular(messageTileBorderRadius),
                  bottomRight: Radius.circular(messageTileBorderRadius),
                )
              : BorderRadius.only(
                  topRight: Radius.circular(messageTileBorderRadius),
                  bottomLeft: Radius.circular(messageTileBorderRadius),
                  bottomRight: Radius.circular(messageTileBorderRadius),
                ),
        ),
        child: Text(
          message.content,
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
    );
  }
}
