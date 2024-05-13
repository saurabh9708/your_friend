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
  List<ChatUser> list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        title: Text(
          'TalkLink',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ProfileScreen(
                            user: list[0],
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
          stream: APIs.firestore.collection('users').snapshots(),
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
                list = data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                    [];

                if (list.isNotEmpty) {
                  return ListView.builder(
                      itemCount: list.length,
                      padding: EdgeInsets.only(top: 15),
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ChatUserCard(user: list[index]);
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
    );
  }
}
