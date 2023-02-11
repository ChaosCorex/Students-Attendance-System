

import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FaceServices{

  Future<String > getPathFile()
  async {
    var foldrPath = await getApplicationDocumentsDirectory();
    return foldrPath.path;
  }
  Future<File > getFile()
  async {
    String path = await getPathFile ();
    return File('$path/AuthData.txt');
  }
  Future<File> writeInFile(String faceData)
  async{
    File file = await getFile();
    file.writeAsString(faceData);
    return file;
  }

  Future<String> readFromFile()
  async{
    try {
      final  file = await getFile();
      String faceData = await file.readAsString();
      return faceData;
    }catch(e){
      return "error her pro  ";
    }

  }
}