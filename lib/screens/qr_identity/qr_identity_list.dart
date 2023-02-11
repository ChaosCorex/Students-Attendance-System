import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ssas/entities/app_user.dart';
import 'package:ssas/entities/identity.dart';
import 'package:ssas/entities/user_role.dart';
import 'package:ssas/ui/dialogs/new_qr_identity.dart';
import 'package:ssas/ui/dialogs/qr_preview.dart';
import 'package:ssas/ui/loading.dart';
import '../../entities/Division.dart';
import '../../entities/academic.dart';
import '../../entities/department.dart';
import '../../entities/grade.dart';
import '../../services/identity_service.dart';

class QrIdentityList extends StatelessWidget {
  final _identityService = IdentityService();

  final AppUser currentUser;

  QrIdentityList({required this.currentUser, Key? key}) : super(key: key);

  bool isAffairs() => currentUser.role == Role.affairs;

  @override
  Widget build(BuildContext context) {
    var media=MediaQuery.of(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text("Identities"),
          centerTitle: true,
        ),
        body: _buildBody(media.size),
        floatingActionButton: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton.extended(
              onPressed: () {
                _onAddNewIdentity(context);
              },
              label: const Text("New Identity"),
              icon: const Icon(Icons.add),
            ),
            SizedBox(
              height: 5,
            ),
            isAffairs()
                ? FloatingActionButton.extended(
              onPressed: () {
                _onBatchAddNewIdentity(context);
              },
              label: const Text("New Batch"),
              icon: const Icon(Icons.add),
              backgroundColor: Colors.teal,
            )
                : SizedBox(),
          ],
        ));
  }

  Widget _buildBody(Size size) {
    return StreamBuilder<List<Identity>>(
        stream:
        _identityService.getItemsStreamBy(currentUser.role == Role.affairs),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error.toString());
            return Text(snapshot.error.toString());
          }
          if (snapshot.hasData) {
            return _buildIdentitiesList(snapshot.data!,size);
          }
          return const Loading();
        });
  }

  Widget _buildIdentitiesList(List<Identity> identities,Size size) {
    if (identities.isEmpty) {
      return Center(child: const Text("No Identities"));
    }
    return GridView.builder(
      padding: const EdgeInsets.all(6),
      itemCount: identities.length,
      gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: kIsWeb ? getNumbersOfCard(size.width) : 2,crossAxisSpacing: 10),
      itemBuilder: (context, index) =>
          _buildItem(
            context,
            identities[index],
          ),

    );
  }

  Widget _buildItem(BuildContext context, Identity identity) {
    return InkWell(
      onTap: !identity.active
          ? null
          : () {
        _onIdentityItemClick(context, identity);
      },


          child: Card(

            color: identity.active ? mapRoleToColor(currentUser) : Colors.black26,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               SingleChildScrollView(
                 scrollDirection: Axis.horizontal,
                 child: Text(
                    "${identity.studentName}", style: TextStyle(
                    color: Colors.white,
                    fontSize: kIsWeb ? 18 : 14,
                    fontWeight: FontWeight.w400,


                  ),
                  ),
               ) ,
                const SizedBox(height: 8),
                Text("NID: ${identity.nationalId}", style: TextStyle(
                  color: Colors.white,
                  fontSize: kIsWeb ? 20 : 14,
                  fontWeight: FontWeight.w400,

                ),),
                const SizedBox(height: 4),
                isAffairs() ? SizedBox() : Text(
                    "New Role: ${roleLabel(identity.role)}", style: TextStyle(
                  color: Colors.white,
                  fontSize: kIsWeb ? 20 : 14,
                  fontWeight: FontWeight.w400,

                )),
                const SizedBox(height: 4),
                isAffairs()
                    ? Text("Level : ${gradeLabel(identity.studentGrade!)}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: kIsWeb ? 20 : 14,
                      fontWeight: FontWeight.w400,

                    ))
                    : SizedBox(height: 1,),
                const SizedBox(height: kIsWeb?8:4),
                isAffairs() && identity.studentGrade != Grade.g0
                    ? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                      child: Text(
                      "Department : ${departmentLabel(
                          identity.studentDepartment!)}", style: TextStyle(
                  color: Colors.white,
                  fontSize: kIsWeb ? 20 : 14,
                  fontWeight: FontWeight.w400,

                )),
                    )
                    : SizedBox(height: 1,),

                const SizedBox(height: 8),
                Container(
                  child: Text(identity.active ? "  Active  " : "  Inactive  ",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: kIsWeb ? 20 : 14,
                        fontWeight: FontWeight.w400,

                      )),
                ),
                SizedBox(height: kIsWeb?15:5),
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _identityService.deleteItemById(identity.id);
                  },
                )

              ],
            ),
      ),
    );
  }

  void _onIdentityItemClick(BuildContext context, Identity identity) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              child: QrPreview(
                qrPreviewData: identity.getQrData(),
              ));
        });
  }

  void _onAddNewIdentity(BuildContext context) async {
    Identity? identity = await showDialog<Identity>(
        context: context,
        builder: (context) {
          return Dialog(
              child: NewQrIdentity(
                currentUser: currentUser,
              ));
        });
    if (identity == null) {
      return;
    }
    await _identityService.createItem(identity);
  }

  final List<List> finalCsvContent = [];

  void _onBatchAddNewIdentity(BuildContext context) async {
    FilePickerResult? result = (await FilePicker.platform.pickFiles(
      withData: true,
      type: FileType.custom,
      allowedExtensions: ['csv'],
    ));
    var file = result?.files.first.bytes;
    String s = String.fromCharCodes(file!);
    var outputAsuint8List = Uint8List.fromList(s.codeUnits);
    var csvFileContentList = utf8.decode(outputAsuint8List).split('\n');
    csvFileContentList.removeAt(0);
    csvFileContentList.forEach((element) {
      List currentRow = [];
      element.toString().split(",").forEach((items) {
        currentRow.add(items.trim());
      });
      finalCsvContent.add(currentRow);
    });

    finalCsvContent.removeAt(finalCsvContent.length - 1);

    OuterLoop:
    for (int i = 0; i < finalCsvContent.length; i++) {
      final values = finalCsvContent[i];
      for (int NulIndex = 0; NulIndex < values.length-1; NulIndex++) {
        if (values[NulIndex] == " " || values[NulIndex] == "" ||
            values[NulIndex] == null) {
          print("i will break from outer loop"); // null value
          break OuterLoop;
        }
      }
      values.add(null);
      Identity? identity = Identity(
          id: "",
          role: Role.student,
          active: true,
          isCreatedByAffairs: true,
          createdAt: Timestamp.now(),
          nationalId: values[0],
          studentName: values[1],
          studentGrade: gradeFromString(values[2]),
          studentDepartment: departmentFromString(values[3]),
          academicYear:academicFromString(values[4]) ,
          studentDivision: divisionFromString(values[5]));
    await _identityService.createItem(identity);
    print(values);
    }

    finalCsvContent.clear();
  }

  Color mapRoleToColor(AppUser user) {
    if (user.role == Role.admin) return Colors.green.shade600;
    return Colors.indigo.shade400;
  }
  int getNumbersOfCard(double width){

    if(width>1200)
      return 5;
    else if(width >900)
      return 4;
    if(width>600)
      return 3;
    else if(width >300)
      return 2;
    else return 1;

  }
}
