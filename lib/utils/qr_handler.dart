import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:ssas/entities/app_user.dart';
import 'package:ssas/services/identity_service.dart';
import 'package:ssas/services/lectures_service.dart';
import 'package:ssas/services/user_service.dart';
import 'package:ssas/ui/dialogs/enter_national_id.dart';
import 'package:ssas/utils/qr_parser.dart';

import '../entities/user_role.dart';
import '../ui/snakbar.dart';
import 'exceptions.dart';

class QrHandler {
  final AppUser currentUser;
  final _identityService = IdentityService();
  final _userService = UserService();
  final _lectureService = LecturesService();

  QrHandler({required this.currentUser});

  Future<void> scanQr(BuildContext context,bool canUpdate) async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        "#FFAACC", "Cancel", false, ScanMode.QR);
    QrParser().parse(
        barcodeScanRes, (function, data) => _handleQr(context, function, data,canUpdate));
  }

  void _handleQr(BuildContext context, QrFunctions? function, String data,bool canUpdate) {
    switch (function) {
      case QrFunctions.identity:
        _onScanIdentity(context, data);
        break;
      case QrFunctions.attendance:
        _onScanAttendance(context, data,canUpdate);
        break;

      default:
        print("Not handled QR function");
    }
  }

  Future<void> _onScanIdentity(BuildContext context, String data) async {
    final identity = await _identityService.getItemById(data);
    if (identity.active) {
      String? nid = await showDialog<String>(
          context: context,
          builder: (context) {
            return Dialog(child: EnterNationalID());
          });
      if (nid == null) {
        return;
      }
      if (nid == identity.nationalId) {
        if (identity.role == Role.student) {
          var random=Random();
          num RandomNum=random.nextInt(15);
          print("new random value == $RandomNum");
          if(RandomNum<8)
          {RandomNum=8;}
          await _userService.updateStudentRole(currentUser.id,
              identity.studentGrade!, identity.studentDepartment,identity.nationalId,identity.studentDivision,RandomNum);
        } else {
          await _userService.updateUserRole(currentUser.id, identity.role);
        }
        _identityService.makeIdentityInActive(identity.id);
      }
    }
  }

  Future<void> _onScanAttendance(BuildContext context, String data,bool canUpdate) async {
    try {
      final lecture =
          await _lectureService.recordStudentAttendance(currentUser, data);
      if (lecture == null) {
        showSnackBar(context, "You can not attend this lecture");
        return;
      }
      showSnackBar(context, "Attendance recorded");
      if(canUpdate)
        {
          var random=Random();
          num RandomNum=random.nextInt(15);
          print("new random value == $RandomNum");
          if(RandomNum<8)
          {RandomNum=8;}
          await _userService.updateUserInfo(currentUser.id,AppUser.randomKey,RandomNum);
        }

    } on LectureAttendanceExpired catch (error) {
      showSnackBar(context, "You can not attend this lecture now");
    }
  }
}
