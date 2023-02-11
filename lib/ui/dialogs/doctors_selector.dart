import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ssas/entities/app_user.dart';
import 'package:ssas/services/user_service.dart';

import '../loading.dart';

class DoctorsSelector extends StatelessWidget {
  final List<String>? exceptionsIds;

  final _userService = UserService();

  DoctorsSelector({
    this.exceptionsIds,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: kIsWeb?480:280,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          alignment: WrapAlignment.center,
          runSpacing: 8,
          children: [
            Text(
              "Select Professor",
              style: Theme.of(context).textTheme.headline5,
            ),
            _buildUsersSelector()
          ],
        ),
      ),
    );
  }

  Widget _buildUsersSelector() {
    return StreamBuilder<List<AppUser>>(
        stream: _userService.getDoctorsStream(exceptionsIds: exceptionsIds),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text(snapshot.error.toString());
          if (snapshot.hasData) {
            final data = snapshot.data!;
            List<AppUser> orderList=[data[0]];
            orderList.clear();
            List<String> listesName=[""];
            listesName.clear();
            AppUser usercheck=data[0];
            for(int i=0;i<data.length;i++)
              {
                listesName.add(data[i].name);
              }
            listesName.sort();
            for(int j=0 ; j<listesName.length; j++)
              {
                 frobreak:for(int k=0; k<listesName.length;k++)
                  {
                    if(data[k].name==listesName[j])
                      {
                      usercheck=data[k];
                      break frobreak;
                      }
                  }
                orderList.add(usercheck);
              }
            listesName.clear();
            data.clear();
            return _buildUsersList(orderList);
          }
          return const Loading();
        });
  }

  Widget _buildUsersList(List<AppUser> users) {
    if (users.isEmpty) return const Center(child: Text("No professors found"));
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 500),
      child: ListView.builder(
          itemCount: users.length,
          shrinkWrap: true,
          itemBuilder: (context, index) =>
              _buildUserItem(context, users[index])),
    );
  }

  Widget _buildUserItem(BuildContext context, AppUser user) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () => _onSelectDoctor(context, user),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                user.imgUrl,
              ),
              minRadius: 32,
              maxRadius: 32,
            ),
            title: Text(user.name),
          ),
        ),
      ),
    );
  }

  void _onSelectDoctor(BuildContext context, AppUser user) {
    Navigator.of(context).pop(user);
  }
}
