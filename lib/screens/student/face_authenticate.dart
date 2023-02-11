import 'dart:convert';
import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';
import 'package:flutter_face_api_beta/face_api.dart' as Regula;

import '../../services/face_service.dart';

class FaceAuthenticats extends StatefulWidget {
  @override
  _FaceAuthenticatsState createState() => _FaceAuthenticatsState();
}

class _FaceAuthenticatsState extends State<FaceAuthenticats> {

  final _faceServices = FaceServices();
  var image2 = new Regula.MatchFacesImage();
  var img2 = Image.asset("assets/img/download.png");
  var image1 = new Regula.MatchFacesImage();
  var img1 = Image.asset("assets/img/download.png");
  String _similarity = "  ";
  String _liveness = "null";
  bool show=false;
  int len=0;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _faceServices.readFromFile().then((value) {
      setState(() {
        setImage(false, base64Decode(value), Regula.ImageType.LIVE);
      });
    });

  }


  Widget build(BuildContext context) {
    return Padding(
    padding: const EdgeInsets.only(top: 100,bottom: 100,right: 20,left: 20),
    child: Card(
      elevation: 8,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      child: Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              createImage(img1.image, () => showAlertDialog(context)),
              SizedBox(height: 15,),
              //Image(height: 200, width: 200, image: img2.image),
              Container(margin: EdgeInsets.fromLTRB(0, 0, 0, 15)),
              createButton("Match", () => matchFaces()),
              // createButton("Liveness", () => liveness()),
              // createButton("Clear", () => clearResults()),
              SizedBox(height: 15,),
              Container(
                  margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                     show? Text("wait to do face processing... " ,
                          style: TextStyle(fontSize: 18)):SizedBox(),
                    ],
                  ))
            ]),
      ),
    ),
  );



  }


  Widget createButton(String text, VoidCallback onPress) => Container(
    // ignore: deprecated_member_use
    child: FlatButton(
        color: Color.fromARGB(50, 10, 10, 10),
        onPressed: onPress,
        child: Text(text)),
    width: 250,
  );

  Widget createImage(image, VoidCallback onPress) => Material(
      child: InkWell(
        onTap: onPress,
        child: Container(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image(height: 200, width: 200, image: image),
          ),
        ),
      ));

  @override


  Future<void> initPlatformState() async {}

  showAlertDialog(BuildContext context) => showDialog(
      context: context,
      builder: (BuildContext context) =>
          AlertDialog(title: Text("Face Authenticate "), actions: [
            // ignore: deprecated_member_use
            FlatButton(
                child: Text("Start"),
                onPressed: () {
                  Regula.FaceSDK.presentFaceCaptureActivity().then((result) {
                   final String  sourses=Regula.FaceCaptureResponse.fromJson(
                        json.decode(result))
                    !.image!
                        .bitmap
                    !.replaceAll("\n", "");
                    setImage(true,
                        base64Decode(sourses),
                        Regula.ImageType.LIVE);
                  }
                  );
                  Navigator.pop(context);
                })
          ])
  );

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


  clearResults() {
    setState(() {
      img2 = Image.asset('assets/download.png');
      _similarity = "add your image ";
      _liveness = "nil";
    });
    image2 = new Regula.MatchFacesImage();
  }

  matchFaces() {
    if (image1 == null ||
        image1.bitmap == null ||
        image1.bitmap == "" ||
        image2 == null ||
        image2.bitmap == null ||
        image2.bitmap == "") return;
    setState(() => show = !show);
    var request = new Regula.MatchFacesRequest();
    request.images = [image1, image2];
    Regula.FaceSDK.matchFaces(jsonEncode(request)).then((value) {
      var response = Regula.MatchFacesResponse.fromJson(json.decode(value));
      Regula.FaceSDK.matchFacesSimilarityThresholdSplit(jsonEncode(response!.results), 0.75).then((str) {
        var split = Regula.MatchFacesSimilarityThresholdSplit.fromJson(json.decode(str));
        setState(() => _similarity = split!.matchedFaces.length > 0 ?
        ((split.matchedFaces[0]!.similarity !* 100).toStringAsFixed(2) + "%") : "error");
        Navigator.of(context).pop(_similarity);

      });
    });
  }

  liveness() => Regula.FaceSDK.startLiveness().then((value) {
    var result = Regula.LivenessResponse.fromJson(json.decode(value));
    setImage( true,base64Decode(result!.bitmap!.replaceAll("\n", "")),
        Regula.ImageType.LIVE);
    setState(() => _liveness = result.liveness == 0 ? "passed" : "unknown");
  });


}