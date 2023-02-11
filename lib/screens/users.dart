import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ssas/entities/app_user.dart';
import 'package:ssas/services/user_service.dart';
import 'package:ssas/ui/dialogs/role_selector.dart';
import 'package:ssas/ui/loading.dart';

import '../entities/user_role.dart';
class Users extends StatefulWidget {
  final AppUser currentUser;
  final bool isAffairs;

  Users({required this.currentUser, this.isAffairs = false, Key? key})
      : super(key: key);

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  final UserService _userService = UserService();


  bool dropDownValue=false;

  @override
  Widget build(BuildContext context) {
    var media=MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Users"),
        centerTitle: true,
      ),
      body: _buildBody(media.size.width),
    );
  }

  Widget _buildBody(double width) {
    return StreamBuilder<List<AppUser>>(
        stream: widget.isAffairs
            ? _userService.getUsersStreamForAffairs()
            : _userService.getUsersStreamForAdminExcept(widget.currentUser.id),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          if (snapshot.hasData) {
            final users = snapshot.data!;
            return  kIsWeb?_buildUsersList(context,users,width):
            ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) =>
                  _buildUserItem(context, users[index]),
            );
          }
          return const Loading();
        });
  }

  Widget _buildUsersList(BuildContext context,List<AppUser> users,double width) {
    if (users.isEmpty) {
      return Center(child: const Loading());
    }
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: users.length,
      gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: kIsWeb ? getNumbersOfCard(width) : 2,crossAxisSpacing: 10),
      itemBuilder: (context, index) =>
        _buildUserItem(context,users[index]),

    );
  }

  Widget _buildUserItem(BuildContext context, AppUser user) {
    return Dismissible(
      key: ObjectKey(user),
      confirmDismiss: (direction) async {
        return await _onDismissUser(context, user);
      },
      child: Expanded(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: (){_onEditUser(context, user);},
              child: Card(
                  elevation: 8,
                  clipBehavior: Clip.antiAlias,
                  shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 36,
                          backgroundImage: NetworkImage(user.imgUrl),
                        ),

                        const SizedBox(height: 8),

                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            user.name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: kIsWeb ? 20 : 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            user.email,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: kIsWeb ? 18 : 10,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Text(user.role.toString(),
                        style: TextStyle(color: _mapUserToMaterialColor(user)),),
                        SizedBox(height: widget.isAffairs?10:1,),
                        // widget.isAffairs && user.role==Role.student?
                        // Row(
                        //   children: [
                        //     Text("Can register image :"),
                        //     SizedBox(width: 5,),
                        //     DropdownButton(
                        //       items: [
                        //       DropdownMenuItem(child:Text("True"),value: true, ),
                        //         DropdownMenuItem(child:Text("false"),value: false, ),
                        //     ], onChanged: (value)async{
                        //
                        //         await _userService.updateUserInfo(user.id, AppUser.canTakeImageKey, value as bool);
                        //
                        //
                        //     },value: user.student!.canTakeImage,),
                        //   ],
                        // ):SizedBox()
                      ],
                    ),
                  )),
            )),
      ),
    );
  }

  Future<bool> _onDismissUser(BuildContext context, AppUser user) async {
    final isRemoved = (await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: Text("You will make ${user.name} anonymous"),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () async {
                await _userService.deleteUser(user.id);
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    )) ??
        false;
    return isRemoved;
  }

  void _onEditUser(BuildContext context, AppUser user) async {
    Role? selectedRole = await showDialog<Role>(
        context: context,
        builder: (context) {
          return Dialog(child: RoleSelector(widget.isAffairs, user.role));
        });
    if (selectedRole == null) {
      return;
    }
    await _userService.updateUserRole(user.id, selectedRole);
  }

  MaterialColor _mapUserToMaterialColor(AppUser? user) {
    if (user == null) return Colors.teal;
    if (user.role == Role.doctor) return Colors.green;
    if (user.role == Role.student) return Colors.blue;
    if (user.role == Role.admin) return Colors.red;
    if (user.role == Role.affairs) return Colors.indigo;
    return Colors.teal;
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
