import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ssas/entities/app_user.dart';
import 'package:ssas/entities/department.dart';
import 'package:ssas/entities/grade.dart';
import 'package:ssas/entities/user_role.dart';
import 'package:ssas/screens/student/take_image.dart';
import 'package:ssas/services/auth_service.dart';
import 'package:ssas/services/identity_service.dart';
import 'package:ssas/services/lectures_service.dart';
import 'package:ssas/services/user_service.dart';

import '../entities/Division.dart';
import '../entities/academic.dart';
import '../entities/activeAcademic.dart';
import '../services/academic_service.dart';
import '../ui/dialogs/EditSubject.dart';

class Profile extends StatelessWidget {
  final AppUser currentUser;

  final _identityService = IdentityService();
  final _userService = UserService();
  final _lectureService = LecturesService();
  final _academicServices = AcademicService();

  Profile({required this.currentUser, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _profileDetails(context, currentUser),
          if (currentUser.role == Role.student && !kIsWeb)
            _faceDetails(context),
          currentUser.role == Role.student
              ? _studentDetails(context, currentUser.student!)
              : const SizedBox(),
          // currentUser.role == Role.student?
          //     SizedBox():
          _profileActionItem(
            text: "Logout",
            icon: Icons.logout,
            color: Colors.red,
            onClick: _logout,
          )
        ],
      ),
    );
  }

  Widget _profileDetails(BuildContext context, AppUser user) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
            elevation: 8,
            clipBehavior: Clip.antiAlias,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 40,
                      ),
                      CircleAvatar(
                        radius: 56,
                        backgroundImage: NetworkImage(user.imgUrl),
                      ),
                      IconButton(
                        onPressed: () => _onEditProfileImageClicked(),
                        icon: const Icon(Icons.drive_file_rename_outline),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          user.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: kIsWeb ? 36 : 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () => _onEditProfileName(context),
                          icon: const Icon(Icons.drive_file_rename_outline),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    user.email,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: kIsWeb ? 32 : 18,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    "Logged in as ${roleLabel(user.role)}",
                    textAlign: TextAlign.center,
                    style: Theme
                        .of(context)
                        .textTheme
                        .caption,
                  ),
                ],
              ),
            )));
  }

  void _onEditProfileImageClicked() async {
    final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxHeight: 512,
        maxWidth: 512,
        imageQuality: 50);

    if (pickedFile == null) {
      return;
    }

    await _userService.editProfileImage(currentUser.id, pickedFile);
  }
  void _onEditProfileName(BuildContext context) async {
    String? newName = await _EditUserInfo(context,"Edit Name");
    if(newName== null)
      newName=currentUser.name;
    _userService.updateUserInfo(currentUser.id, AppUser.nameKey,newName );

  }

  Widget _studentDetails(BuildContext context, Student student) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 8,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              Text(gradeLabel(student.grade!),
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w400)),
              const SizedBox(height: 12),
              student.department == null
                  ? const SizedBox()
                  : Text(
                "Department: ${departmentLabel(student.department!)}",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 10),
              student.division == null
                  ? const SizedBox(height: 1,)
                  : Text(
                "Division: ${divisionLabel(student.division!)}",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 8),
              StreamBuilder<ActiveAcademic>(
                  stream: _academicServices.getItemStreamById("ssasActiveYear"),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      print(snapshot.error);
                      return Text(snapshot.error.toString());
                    }
                    if (snapshot.hasData) {
                      final activeAcademic = snapshot.data!;

                      return Container(
                        child: Text(
                            " Academic Year " +
                                academicYearLabel(
                                    academicFromString(
                                        activeAcademic!.activeAcademicYear),
                                    activeAcademic.incrementalAcademic) +
                                " ",
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w400)),
                      );
                    }
                    return SizedBox();
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _faceDetails(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 8,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: MaterialButton(
              onPressed: () {
                if(currentUser.student!.canTakeImage==true)
               { Navigator.push(
                    context, MaterialPageRoute(builder: (context) =>TakeImage(currentUser: currentUser,)));
               }
              },
              child: Container(
                  height: 100,
                  width: 100,
                  child: Image.asset("assets/img/facial-recognition.png")),
            )),
      ),
    );
  }

  Widget _profileActionItem({required String text,
    required IconData icon,
    Color? color,
    required GestureTapCallback onClick}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        child: InkWell(
          onTap: onClick,
          child: SizedBox(
            height: 48,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: color,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    text,
                    style: TextStyle(color: color),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  Future<String?> _EditUserInfo(BuildContext context, String editType) async {
    String? EditInfo = await showDialog<String>(
        context: context,
        builder: (context) {
          return Dialog(child: EditSubjectInfo(editType: editType));
        });

    return EditInfo;
  }

  void _logout() async {
    await AuthService().signOut();
  }
}
