# Jangle

Front end mobile client for Jangle cross-platform chat application built with Flutter and socket.io

To view, visit the application bundle and install at your device 

[![Codemagic build status](https://api.codemagic.io/apps/6114cfef2ca707a421efbc7f/6114cfef2ca707a421efbc7e/status_badge.svg)](https://codemagic.io/apps/6114cfef2ca707a421efbc7f/6114cfef2ca707a421efbc7e/latest_build)


## Table of contents

+ [Built with](#build-with)
+ [Installation](#installation)
+ [App preview](#App-preview)
+ [To do's](#Todos)

## Built with

[![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)](https://flutter.dev/)
[![Flutter](https://img.shields.io/badge/Provider-%23EEEEEE.svg?style=for-the-badge)](https://pub.dev/packages/provider)

## Installation

Follow these simple steps to run project locally:

+ Change the backend server's endpoint url in file `lib/services/socketio.dart` and `lib/services/httpRequests.dart` to your backend server's url.
    + In socketio.dart
    ```dart
    ...
    import 'package:socket_io_client/socket_io_client.dart' as IO;

    final String baseSocketServerUrl = ''; // <======= Here, put your backend server url

    class SocketIo {
    ...
    ```

    
    + In httpRequests.dart

    ```dart
    ...
    class HttpRequests {
    String baseURL = ''; // <======= Here, put your backend server url

    ...
    ```


+ Install all the dependencies by running
    ```
    flutter pub get
    ```
<br>

## App preview

<img src="https://user-images.githubusercontent.com/54198301/130488541-b913e7a0-f112-4edc-b5b9-b6d124003ca5.gif" alt="Jangle-app" height="540" width="270" />

## Todos

+ When creating/selecting chat from new conversation page, the home screen doesn't gets updated, either for addition or for selection.
+ Upgrading UI and animations
+ Adding personal info part and ability to edit firstName and lastName.
+ Implementing search functionality.
+ Implementing paging of chat messages
+ Implementing chat user's details page.
+ Implementing read-messages
+ Implementing last seen / online
+ Implementing message sending time.
+ Implementing message deletion if the message is sent my current user.




