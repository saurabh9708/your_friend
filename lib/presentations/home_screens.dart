// ignore_for_file: unused_field, deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:your_friend/presentations/profile_screens.dart';

import '../Api/apis.dart';
import '../models/chat_users.dart';
import '../widgets/chat_user_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // for storing all users
  List<ChatUser> _list = [];

  // for storing searched item
  final List<ChatUser> _searchlist = [];

  // for storing search status
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // For hiding keyboard when a tap is detected on screen
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        //  If search is on & back Button is pressed then close search
        // or else simple close current screen on back button click
        onWillPop: () {
          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          drawer: Drawer(),
          appBar: AppBar(
            title: _isSearching
                ? TextField(
                    decoration: const InputDecoration(
                        border: InputBorder.none, hintText: 'Name,Email,...'),
                    autofocus: true,
                    style: TextStyle(fontSize: 17, letterSpacing: 0.5),
                    // when search text changes then updated search list
                    onChanged: (val) {
                      // search logic
                      _searchlist.clear();

                      for (var i in _list) {
                        if (i.name.toLowerCase().contains(val.toLowerCase()) ||
                            i.email.toLowerCase().contains(val.toLowerCase())) {
                          _searchlist.add(i);
                        }
                        setState(() {
                          _searchlist;
                        });
                      }
                    },
                  )
                : Text(
                    'TalkLink',
                    style: TextStyle(color: Colors.black),
                  ),
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _isSearching = !_isSearching;
                  });
                },
                icon: Icon(_isSearching
                    ? CupertinoIcons.clear_circled_solid
                    : Icons.search),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ProfileScreen(
                                user: APIs.me,
                              )));
                },
                icon: Icon(Icons.person),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.more_vert),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              // Google signOut from the app
              await APIs.auth.signOut();
              await GoogleSignIn().signOut();
            },
            child: Icon(Icons.add_circle_sharp),
          ),
          body: StreamBuilder(
              stream: APIs.getAllUsers(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  case ConnectionState.active:
                  case ConnectionState.done:
                    final data = snapshot.data?.docs;
                    _list = data
                            ?.map((e) => ChatUser.fromJson(e.data()))
                            .toList() ??
                        [];

                    if (_list.isNotEmpty) {
                      return ListView.builder(
                          itemCount:
                              _isSearching ? _searchlist.length : _list.length,
                          padding: EdgeInsets.only(top: 15),
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return ChatUserCard(
                                user: _isSearching
                                    ? _searchlist[index]
                                    : _list[index]);
                          });
                    } else {
                      return const Center(
                        child: Text(
                          'No Connection Found!',
                          style: TextStyle(fontSize: 20),
                        ),
                      );
                    }
                }
              }),
        ),
      ),
    );
  }
}
