import 'package:flutter/material.dart';
import 'package:jangle_app/store.dart';
import 'package:jangle_app/widgets/userTile.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add new conversation'),
      ),
      body: Consumer<Store>(
        builder: (context, store, child) {
          return Container(
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return Divider();
              },
              itemCount: store.userList.length,
              itemBuilder: (context, index) {
                return UserTile(user: store.userList[index]);
              },
            ),
          );
        },
      ),
    );
  }
}
