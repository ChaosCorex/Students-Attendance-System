import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ssas/entities/app_user.dart';
import 'package:ssas/entities/grade.dart';
import 'package:ssas/entities/grade_department.dart';
import 'package:ssas/entities/subject.dart' as app_subject;
import 'package:ssas/entities/user_role.dart';
import 'package:ssas/screens/admin/admin_home.dart';
import 'package:ssas/screens/admin/grade_department.dart';
import 'package:ssas/screens/admin/grade_department_division.dart';
import 'package:ssas/screens/admin/grade_deprtment_subjects.dart';
import 'package:ssas/screens/admin/grades.dart';
import 'package:ssas/screens/admin/subject_details.dart';
import 'package:ssas/screens/affairs/affairs_home.dart';
import 'package:ssas/screens/anon/anon_home.dart';
import 'package:ssas/screens/auth.dart';
import 'package:ssas/screens/doctor/doctor_home.dart';
import 'package:ssas/screens/doctor/doctor_subjects.dart';
import 'package:ssas/screens/doctor/lecture_details.dart';
import 'package:ssas/screens/doctor/lectures.dart';
import 'package:ssas/screens/firstPage.dart';
import 'package:ssas/screens/qr_identity/qr_identity_list.dart';
import 'package:ssas/screens/splash.dart';
import 'package:ssas/screens/student/student_home.dart';
import 'package:ssas/services/auth_service.dart';
import 'package:ssas/ui/dialogs/doctors_selector.dart';

import 'firebase_options.dart';

class SSASApp extends StatelessWidget {
  const SSASApp({Key? key}) : super(key: key);
  static const _fakeUserId = "@#15#@";

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AppUser?>(
        initialData: AppUser.fakeUser(_fakeUserId),
        stream: getCurrentUserStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            if (kDebugMode) {
              print(snapshot.error.toString());
            }
            return Text(snapshot.error.toString());
          }
          final AppUser? user = snapshot.data;

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: ' SSAS ',
            onGenerateRoute: _onGenerateRoute,
            theme: ThemeData(
              primarySwatch: _mapUserToMaterialColor(user),
            ),
            home: _mapUserToHome(user),
          );
        });
  }

  Stream<AppUser?> getCurrentUserStream() {
    return initApp()
        .asStream()
        .delay(const Duration(seconds: 2))
        .flatMap((app) {
      return AuthService().getCurrentUserStream();
    });
  }

  Widget _mapUserToHome(AppUser? user) {
    if (user == null) return FirstPage();
    if (user.id == _fakeUserId) return const Splash();
    if (user.role == Role.doctor) return DoctorHome(currentUser: user);
    if (user.role == Role.student && kIsWeb) {
      return AnonHome(
        currentUser: user,
        isStudent: true,
      );
    }
    if (user.role == Role.student) return StudentHome(currentUser: user);
    if (user.role == Role.admin) return AdminHome(currentUser: user);
    if (user.role == Role.affairs) return AffairsHome(currentUser: user);
    return AnonHome(currentUser: user);
  }

  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    final routes = <String, WidgetBuilder>{
      GradeDepartment.route: (context) => GradeDepartment(
        gradeDepartmentData:  settings.arguments as GradeDepartmentData ,
          ),
      GradeDepartmentDivision.route: (context) => GradeDepartmentDivision(
        gradeDepartmentDivsionData: settings.arguments as GradeDepartmentDivsionData,
      ),
      GradeDepartmentSubjects.route: (context) => GradeDepartmentSubjects(
            gradeAndDepartment: settings.arguments as GradeAndDepartment,
          ),
      SubjectDetails.route: (context) => SubjectDetails(
            subject: settings.arguments as app_subject.Subject,
          ),
      Lectures.route: (context) => Lectures(
            lecturesData: settings.arguments as LecturesData,
          ),
      LectureDetails.route: (context) => LectureDetails(
            lectureDetailsData: settings.arguments as LectureDetailsData,
          ),
      DoctorSubjects.route: (context) => DoctorSubjects(
            doctorSubjectData: settings.arguments as DoctorSubjectData,
          ),
      GradesScreen.route:(context)=>GradesScreen(
        gradeData: settings.arguments as GradeData,

      )
    };
    return MaterialPageRoute(builder: routes[settings.name]!);
  }

  MaterialColor _mapUserToMaterialColor(AppUser? user) {
    if (user == null) return Colors.teal;
    if (user.id == _fakeUserId) return Colors.teal;
    if (user.role == Role.doctor) return Colors.green;
    if (user.role == Role.student) return Colors.blue;
    if (user.role == Role.admin) return Colors.red;
    if (user.role == Role.affairs) return Colors.indigo;
    return Colors.teal;
  }

  Future<FirebaseApp> initApp() async {
    return await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
