import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:your_friend/Api/apis.dart';
import 'package:your_friend/utils/my_date_util.dart';

import '../main.dart';
import '../models/chat_users.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/message.dart';
import '../presentations/chat_screens.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  // last message info( if null --> no message)
  Message? _message;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ChatScreen(user: widget.user)));
          },
          child: StreamBuilder(
              stream: APIs.getLastMessages(widget.user),
              builder: (context, snapshot) {
                final data = snapshot.data?.docs;
                final list =
                    data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
                if (list.isNotEmpty) _message = list[0];
                // if (data != null && data.first.exists) {
                //   _message = Message.fromJson(data.first.data());
                // }
                return ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(mq.height * .3),
                      child: CachedNetworkImage(
                        width: mq.height * .055,
                        height: mq.height * .055,
                        imageUrl: widget.user.image,
                        errorWidget: (context, url, error) =>
                            const CircleAvatar(
                          child: Icon(CupertinoIcons.person),
                        ),
                      ),
                    ),
                    title: Text(widget.user.name),
                    subtitle: Text(
                        _message != null
                            ? _message!.type == Type.image
                                ? 'image'
                                : _message!.msg
                            : widget.user.about,
                        maxLines: 1),
                    // last message timing
                    trailing: _message == null
                        ? null
                        // show nothing when no message is sent
                        : _message!.read.isEmpty &&
                                _message!.fromId != APIs.user.uid
                            ? // Text('12:00 PM', style: const TextStyle(color: Colors.black54)),
                            // show for unread message
                            Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                    color: Colors.greenAccent,
                                    borderRadius: BorderRadius.circular(10)),
                              )
                            : Text(
                                MyDateUtil.getLastMessageTime(
                                    context: context, time: _message!.sent),
                                style: const TextStyle(color: Colors.black54),
                              ));
              })),
    );
  }
}
