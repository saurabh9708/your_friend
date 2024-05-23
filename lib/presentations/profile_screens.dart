import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:your_friend/models/chat_users.dart';
import 'package:your_friend/presentations/Auth/login_screen.dart';

import '../Api/apis.dart';
import '../main.dart';
import '../utils/dialogs.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;

  const ProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _image;

  @override
  Widget build(BuildContext context) {
    // Retrieve the media query once
    final mq = MediaQuery.of(context);

    return GestureDetector(
      // for hiding keyboard if anywhere we tap on screen
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => LoginScreen()),
                  );
                });
              });
            },
            label: const Text('LogOut'),
            icon: const Icon(Icons.logout_outlined),
          ),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: mq.size.width * .05,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    width: mq.size.width,
                    height: mq.size.height * .03,
                  ),
                  Stack(
                    children: [
                      // Profile Picture is null or not
                      _image != null
                          ?
                          // local Image
                          ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(mq.size.height * .1),
                              child: Image.file(
                                File(_image!),
                                width: mq.size.height * .2,
                                height: mq.size.height * .2,
                                fit: BoxFit.cover,
                              ),
                            )
                          :
                          // Image from Server
                          ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(mq.size.height * .1),
                              child: CachedNetworkImage(
                                width: mq.size.height * .2,
                                height: mq.size.height * .2,
                                fit: BoxFit.cover,
                                imageUrl: widget.user.image,
                                errorWidget: (context, url, error) =>
                                    const CircleAvatar(
                                  child: Icon(CupertinoIcons.person),
                                ),
                              ),
                            ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: MaterialButton(
                          elevation: 1,
                          onPressed: () {
                            _showBottomSheet();
                          },
                          shape: const CircleBorder(),
                          color: Colors.white,
                          child: Icon(
                            Icons.edit,
                            color: Colors.blue,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: mq.size.height * .03,
                  ),
                  Text(
                    widget.user.email,
                    style: TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                  SizedBox(
                    height: mq.size.height * .05,
                  ),
                  TextFormField(
                    initialValue: widget.user.name,
                    onSaved: (val) => APIs.me.name = val ?? '',
                    validator: (val) =>
                        val != null && val.isNotEmpty ? null : 'Required Field',
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person, color: Colors.blue),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Apna Name likh re Baba',
                      labelText: 'Name',
                    ),
                  ),
                  SizedBox(
                    height: mq.size.height * .02,
                  ),
                  TextFormField(
                    initialValue: widget.user.about,
                    onSaved: (val) => APIs.me.about = val ?? '',
                    validator: (val) =>
                        val != null && val.isNotEmpty ? null : 'Required Field',
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.info_outline, color: Colors.blue),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Apna Name likh re Baba',
                      labelText: 'About',
                    ),
                  ),
                  SizedBox(
                    height: mq.size.height * .02,
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      minimumSize:
                          Size(mq.size.width * 0.5, mq.size.height * 0.06),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        APIs.updateUserInfo().then((value) {
                          Dialogs.showSnackbar(
                              context, 'Profile Update Successfully!');
                        });
                      }
                    },
                    icon: Icon(
                      Icons.edit,
                      size: 28,
                    ),
                    label: Text(
                      'Update',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(
                  top: mq.height * .03, bottom: mq.height * .05),
              children: [
                const Text('Pick Profile Picture',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                SizedBox(
                  height: mq.height * .02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            // backgroundColor: Colors.white,
                            shape: const CircleBorder(),
                            fixedSize: Size(mq.width * .3, mq.height * .15)),
                        onPressed: () async {
                          final ImagePicker picker = ImagePicker();
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.gallery,
                              // to Reduce image quality and maintain space
                              imageQuality: 80);
                          if (image != null) {
                            log('Image Path: ${image.path} --MimeType: ${image.mimeType}');
                            setState(() {
                              _image = image.path;
                            });

                            APIs.updateProfilePicture(File(_image!));
                            // for Hiding Bottom Sheet
                            Navigator.pop(context);
                          }
                        },
                        child: Image.asset('images/gallery.jpeg')),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            // backgroundColor: Colors.white,
                            shape: const CircleBorder(),
                            fixedSize: Size(mq.width * .3, mq.height * .15)),
                        onPressed: () async {
                          final ImagePicker picker = ImagePicker();
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera, imageQuality: 80);
                          if (image != null) {
                            log('Image Path: ${image.path}');
                            setState(() {
                              _image = image.path;
                            });

                            APIs.updateProfilePicture(File(_image!));
                            // for Hiding Bottom Sheet
                            Navigator.pop(context);
                          }
                        },
                        child: Image.asset('images/Camera2.jpg'))
                  ],
                )
              ]);
        });
  }
}
