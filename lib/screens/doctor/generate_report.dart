import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as x;
import 'package:universal_html/html.dart' show AnchorElement;

import '../../services/lectures_service.dart';

LecturesService lectureService=LecturesService();
Future<void>creatSheet(dynamic finalCsvContent ,String subjectName,int totalLecture)
async {
  int count=0;
  final x.Workbook workbook = x.Workbook(); //create a workbook with 1 worksheet in it
// To save as an excel file you need to get the document as bytes (List of int)
  final x.Worksheet sheet = workbook.worksheets[0]; // selecting the first sheet
  for (int i = 1; i<=finalCsvContent.length;i++){
    List <dynamic> tempList= finalCsvContent[i-1];
    if(count==0)
      {
        List <dynamic> firstRow=["Student name","Total Lectures: ${totalLecture}","Student Id"];
        sheet.importList(firstRow, 1, 1, false);
        count++;
      }
    sheet.importList(tempList, i+1, 1, false);
  }
  final List<int> bytes = workbook.saveAsStream();
  if(kIsWeb){
    AnchorElement(
        href: 'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}')
      ..setAttribute('download', '${subjectName}.xlsx')
      ..click();
  }

}


Map<String,num>  mapStudentToAttendance(List<List<dynamic>>attendance)
{
  Map<String,num> TotalMap={" ":0};
  TotalMap.clear();
  List TotalList=attendance[0];
  for(int k=0;k<TotalList.length;k++)
  {
    TotalMap.addAll({TotalList[k]:1});
  }
  var numers;
  for(int i=1;i<attendance.length;i++ )
  {
    final list=attendance[i];

    for(int j=0;j<list.length;j++)
    {

      if(TotalList.contains(list[j]))
      {
        numers=TotalMap['${list[j]}'];
        numers++;
        TotalMap["${list[j]}"]=numers;
      }
      else
      {
        TotalMap.addAll({"${list[j]}":1});
        TotalList.add(list[j]);
      }
    }
  }
  return TotalMap;
}



List<List<dynamic>> mapToList(Map<String,num>map)
{
  List<List<dynamic>> totalLists;
  totalLists=[[" "]];
  totalLists.clear();
  for(int i=0;i<map.length;i++)
  {
    final key = map.keys.elementAt(i);
    final value = map[key];
    final list=[key,value];
    totalLists.add(list);
  }
  return totalLists;
}


List<List<dynamic>> Total_Attendance=[["er"]];
int LectureCount=0;



