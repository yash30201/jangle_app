import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class HttpRequests {
  String baseURL = 'https://jangle-api.herokuapp.com/';
  // String baseURL = 'http://10.0.2.2:5000/';
  String authToken = '';
  String userId = '';

  void setAuthToken(String token) {
    this.authToken = token;
  }

  void setUserId(String id) {
    this.userId = id;
  }

  Future login(String phoneNumber, String password) async {
    try {
      var url = Uri.parse(this.baseURL + 'login');
      var response = await http
          .post(url, body: {'phoneNumber': phoneNumber, 'password': password});
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Error code :' + response.statusCode.toString());
        throw jsonDecode(response.body);
      }
    } catch (e) {
      throw e;
    }
  }

  Future signup(String firstName, String lastName, String phoneNumber,
      String password) async {
    try {
      var url = Uri.parse(this.baseURL + 'signup');
      var body = jsonEncode({
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
        'password': password,
      });
      var response = await http.post(url, body: body, headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      });
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Error code :' + response.statusCode.toString());
        throw jsonDecode(response.body);
      }
    } catch (e) {
      throw e;
    }
  }

  Future getUserById(String userId) async {
    try {
      var url = Uri.parse(this.baseURL + 'user/' + userId);
      final response = await http.get(url, headers: {
        HttpHeaders.authorizationHeader: 'Bearer ' + this.authToken
      });
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Error code :' + response.statusCode.toString());
        throw jsonDecode(response.body);
      }
    } catch (e) {
      throw e;
    }
  }

  Future getAllUsers() async {
    try {
      var url = Uri.parse(this.baseURL + 'user');
      final response = await http.get(url, headers: {
        HttpHeaders.authorizationHeader: 'Bearer ' + this.authToken
      });
      if (response.statusCode == 200)
        return jsonDecode(response.body);
      else {
        print('Error code :' + response.statusCode.toString());
        throw jsonDecode(response.body);
      }
    } catch (e) {
      throw e;
    }
  }

  Future getAllMyRooms() async {
    try {
      var url = Uri.parse(this.baseURL + 'room');
      final response = await http.get(url, headers: {
        HttpHeaders.authorizationHeader: 'Bearer ' + this.authToken
      });
      if (response.statusCode == 200)
        return jsonDecode(response.body);
      else {
        print('Error code :' + response.statusCode.toString());
        throw jsonDecode(response.body);
      }
    } catch (e) {
      throw e;
    }
  }

  Future getMessagesByRoomId(String roomId) async {
    try {
      var url = Uri.parse(
          this.baseURL + 'room/' + roomId + '?page=0&limit=1000000000');
      final response = await http.get(
        url,
        headers: {HttpHeaders.authorizationHeader: 'Bearer ' + this.authToken},
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Error code :' + response.statusCode.toString());
        throw jsonDecode(response.body);
      }
    } catch (e) {
      throw e;
    }
  }

  Future getRoomById(String roomId) async {
    try {
      var url = Uri.parse(this.baseURL + 'room/' + roomId + '?page=0&limit=0');
      final response = await http.get(
        url,
        headers: {HttpHeaders.authorizationHeader: 'Bearer ' + this.authToken},
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Error code :' + response.statusCode.toString());
        throw jsonDecode(response.body);
      }
    } catch (e) {
      throw e;
    }
  }

  Future initiateRoom(List<String> userIds) async {
    try {
      var url = Uri.parse(this.baseURL + 'room/initiate');
      var body = jsonEncode({'userIds': userIds});
      var response = await http.post(
        url,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ' + this.authToken,
          HttpHeaders.contentTypeHeader: "application/json"
        },
        body: body,
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Error code :' + response.statusCode.toString());
        throw jsonDecode(response.body);
      }
    } catch (e) {
      throw e;
    }
  }

  Future postMessage(String text, String roomId) async {
    try {
      var url = Uri.parse(this.baseURL + 'room/' + roomId + '/message');
      var response = await http.post(
        url,
        headers: {HttpHeaders.authorizationHeader: 'Bearer ' + this.authToken},
        body: {'message': text},
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Error code :' + response.statusCode.toString());
        throw jsonDecode(response.body);
      }
    } catch (e) {
      throw e;
    }
  }
}
