import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:your_friend/models/chat_users.dart';
import 'package:your_friend/presentations/Auth/login_screen.dart';

import '../Api/apis.dart';
import '../main.dart';
import '../utils/dialogs.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Pehchan Patra',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert),
            ),
          ],
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: FloatingActionButton.extended(
            backgroundColor: Colors.redAccent,
            onPressed: () async {
              Dialogs.showProgressBar(context);
              // Google signOut from the app
              await APIs.auth.signOut().then((value) async {
                await GoogleSignIn().signOut().then((value) {
                  // for hiding progress dialog
                  Navigator.pop(context);

                  // for moving to HomeScreen
                  Navigator.pop(context);

                  // for replacing HomeScreen() with Login Screen()
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => LoginScreen()));
                });
              });
            },
            label: const Text('LogOut'),
            icon: const Icon(Icons.logout_outlined),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: mq.width * .05,
            ),
            child: Column(
              children: [
                SizedBox(
                  width: mq.width,
                  height: mq.height * .03,
                ),
                Stack(children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(mq.height * .1),
                    child: CachedNetworkImage(
                      width: mq.height * .2,
                      height: mq.height * .2,
                      fit: BoxFit.fill,
                      imageUrl: widget.user.image,
                      errorWidget: (context, url, error) => const CircleAvatar(
                        child: Icon(CupertinoIcons.person),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: MaterialButton(
                      elevation: 1,
                      onPressed: () {},
                      shape: const CircleBorder(),
                      color: Colors.white,
                      child: Icon(
                        Icons.edit,
                        color: Colors.blue,
                      ),
                    ),
                  )
                ]),
                SizedBox(
                  height: mq.height * .03,
                ),
                Text(
                  widget.user.email,
                  style: TextStyle(color: Colors.black54, fontSize: 16),
                ),
                SizedBox(
                  height: mq.height * .05,
                ),
                TextFormField(
                  initialValue: widget.user.name,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person, color: Colors.blue),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Apna Name likh re Baba',
                      label: Text('Name')),
                ),
                SizedBox(
                  height: mq.height * .02,
                ),
                TextFormField(
                  initialValue: widget.user.name,
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.info_outline,
                        color: Colors.blue,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Apna Name likh re Baba',
                      label: Text('About')),
                ),
                SizedBox(
                  height: mq.height * .02,
                ),
                ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      minimumSize: Size(mq.width * 0.5, mq.height * 0.06),
                    ),
                    onPressed: () {},
                    icon: Icon(
                      Icons.edit,
                      size: 28,
                    ),
                    label: Text(
                      'Update',
                      style: TextStyle(fontSize: 16),
                    )),
              ],
            ),
          ),
        ));
  }
}
