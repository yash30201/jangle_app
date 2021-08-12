import 'package:flutter/material.dart';
import 'package:jangle_app/classes/user.dart';

class Store extends ChangeNotifier {
  User? currentUser;
  Map<String, User> users = {};
  List<User> userList = [];

  void setCurrentUser(Map<String, dynamic> data) {
    this.currentUser = User.fromData(data);
    notifyListeners();
  }

  void setUsers(List<Map<String, dynamic>> data) {
    data.forEach((user) {
      if (user['_id'] != this.currentUser?.userId) {
        User tempUser = User.fromData(user);
        this.users[user['_id']] = tempUser;
        this.userList.add(tempUser);
      }
    });
    notifyListeners();
  }

  String getRoomName(List<String> roomUsers) {
    String result = '';
    for (int i = 0; i < roomUsers.length; i++) {
      if (roomUsers[i] != this.currentUser?.userId) {
        if (result.isNotEmpty) result += ", ";
        if (this.users.containsKey(roomUsers[i])) {
          User user = this.users[roomUsers[i]]!;
          result += user.firstName + " " + user.lastName;
        } else {
          print(
              'While creating mini room, user wasn\'t found for id ${roomUsers[i]}');
        }
      }
    }
    return result.isEmpty ? 'John Doe' : result;
  }
}
