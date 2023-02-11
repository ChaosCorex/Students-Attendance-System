import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:flutter_face_api_beta/face_api.dart' as Regula;
import 'package:ssas/entities/app_user.dart';
import 'package:ssas/services/face_service.dart';
import 'package:ssas/services/user_service.dart';

import '../../ui/snakbar.dart';


class TakeImage extends StatefulWidget {
  final AppUser currentUser;

  const TakeImage({required this.currentUser, Key? key}) : super(key: key);

  @override
  State<TakeImage> createState() => _TakeImageState();
}
var image1 = new Regula.MatchFacesImage();
var img1 = Image.asset("assets/img/download.png");
var image2 = new Regula.MatchFacesImage();
var img2 = Image.asset("assets/img/download.png");
class _TakeImageState extends State<TakeImage> {
  final _faceServices = FaceServices();
  final _userService = UserService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image registration"),
        centerTitle: true,
      ),
      body: builbody(),
    );
  }

  Widget builbody() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DefaultTextStyle(
              style: const TextStyle(
                fontSize: 25.0,
                color: Colors.indigo,
                fontWeight: FontWeight.w600,
                fontFamily: 'Agne',
              ),
              child: AnimatedTextKit(
                isRepeatingAnimation: false,
                animatedTexts: [
                  TypewriterAnimatedText('Click on the picture to register your image ...',speed: Duration(milliseconds: 80)),
                ],

            ),
        ),
          ),
          SizedBox(
            height: 40,
          ),
          createImage(img1.image, () => showAlertDialog(context)),
        ],
      ),
    );
  }

  Widget createImage(image, VoidCallback onPress) => Material(
          child: InkWell(
        onTap: onPress,
        child: Container(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child:
                Image(height: 200, width: 200, image: image, fit: BoxFit.cover),
          ),
        ),
      ));

  showAlertDialog(BuildContext context) => showDialog(
      context: context,
      builder: (BuildContext context) =>
          AlertDialog(title: Text("Take Picture"), actions: [
            // ignore: deprecated_member_use

            FlatButton(
                child: Text("Start"),
                onPressed: () {
                  Regula.FaceSDK.presentFaceCaptureActivity()
                      .then((result) async {
                    final String sourses = Regula.FaceCaptureResponse.fromJson(
                            json.decode(result))!
                        .image!
                        .bitmap!
                        .replaceAll("\n", "");
                    await _faceServices.writeInFile(sourses);
                    await _userService.updateUserInfo(widget.currentUser.id,AppUser.canTakeImageKey,false);
                    setImage(
                        true, base64Decode(sourses), Regula.ImageType.LIVE);
                  });
                  Navigator.pop(context);
                })
          ]));

  setImage(bool first, dynamic imageFile, int type) {
    if (imageFile == null) return;
    if (first) {
      image1.bitmap = base64Encode(imageFile);
      image1.imageType = type;
      setState(() {
        img1 = Image.memory(imageFile);
      });
    }
    else{
      image2.bitmap = base64Encode(imageFile);
      image2.imageType = type;
      setState(() {
        img2 = Image.memory(imageFile);
      });
    }
  }



}
