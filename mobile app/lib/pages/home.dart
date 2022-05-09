import 'dart:io';

import 'package:carapp/pages/sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:url_launcher/url_launcher.dart';

Color yellow = const Color(0xfffbc31b);
Color orange = const Color(0xfffb6900);

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  File? _imageFile;
  bool show = false;

  final picker = ImagePicker();

  Future pickImage() async {
    if (!await launch(liveId ?? 'https://www.youtube.com/watch?v=BwJR1l_SC-U')) throw 'Could not launch $liveId';
    // final pickedFile = await picker.pickImage(source: ImageSource.camera);
    //
    // setState(() {
    //   _imageFile = File(pickedFile!.path);
    //   show = true;
    // });
  }

  getId() async {
    final firestoreInstance = FirebaseFirestore.instance;

    await firestoreInstance.collection('id').get().then((value) {
      var result = value.docs.first;

      if(mounted) {
        setState(() {
          liveId = result.data()['id'];
          print(liveId);
        });
      }
    }).catchError((onError) {
      print(onError);
    });
  }

  String? liveId;

  Future uploadImageToFirebase(BuildContext context) async {
    if (!await launch(liveId ?? 'https://www.youtube.com/watch?v=BwJR1l_SC-U')) throw 'Could not launch $liveId';
    // String fileName = basename(_imageFile!.path);
    // Reference firebaseStorageRef =
    // FirebaseStorage.instance.ref().child('uploads/$fileName');
    // UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile!);
    // uploadTask.then((res) {
    //   res.ref.getDownloadURL();
    //   debugPrint("Done: $res");
    // });
    // setState(() {
    //   _imageFile = null;
    //   show = false;
    // });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: 360,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(50.0),
                    bottomRight: Radius.circular(50.0)),
                gradient: LinearGradient(
                    colors: [orange, yellow],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight)),
          ),
          Container(
            margin: const EdgeInsets.only(top: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        height: double.infinity,
                        margin: const EdgeInsets.only(
                            left: 30.0, right: 30.0, top: 10.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30.0),
                          child: InkWell(
                            child: const Text(
                              'Start',
                              style: TextStyle(
                                  fontSize: 25
                              ),
                            ),
                            onTap: pickImage,
                          ),
                          // _imageFile != null
                          //     ? InkWell(
                          //   onTap: pickImage,
                          //   child: Image.file(_imageFile!),
                          // )
                          //     : InkWell(
                          //   child: const Text(
                          //     'Start',
                          //     style: TextStyle(
                          //       fontSize: 25
                          //     ),
                          //   ),
                          //   onTap: pickImage,
                          // ),
                        ),
                      ),
                      Positioned(
                        right: 20,
                        top: 0,
                        child: InkWell(
                            onTap: () async {
                              await FirebaseAuth.instance.signOut();
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignIn(),
                                  ),
                                      (route) => false
                              );
                            },
                            child: const Text(
                              'Logout',
                              style: TextStyle(
                                  fontSize: 25
                              ),
                            ),
                          ),
                      ),
                    ],
                  ),
                ),
                !show ? Container() : uploadImageButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget uploadImageButton(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding:
          const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
          margin: const EdgeInsets.only(
              top: 30, left: 20.0, right: 20.0, bottom: 20.0),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [yellow, orange],
              ),
              borderRadius: BorderRadius.circular(30.0)),
          child: TextButton(
            onPressed: () => uploadImageToFirebase(context),
            child: const Text(
              "Upload Image",
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
      ],
    );
  }
}
