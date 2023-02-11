import 'package:flutter/material.dart';

import '../../entities/user_role.dart';

class RoleSelector extends StatefulWidget {
  final bool isAffairs;
  final bool isForQrIdentity;

  final Role? initRole;

  const RoleSelector(this.isAffairs, this.initRole,
      {Key? key, this.isForQrIdentity = false})
      : super(key: key);

  @override
  State<RoleSelector> createState() => _RoleSelectorState();
}

class _RoleSelectorState extends State<RoleSelector> {
  late Role? _currentRole;

  @override
  void initState() {
    super.initState();
    _currentRole = widget.initRole;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          alignment: WrapAlignment.center,
          runSpacing: 8,
          children: [
            Text(
              "Select role",
              style: Theme.of(context).textTheme.headline5,
            ),
            buildRolesSelector()
          ],
        ),
      ),
    );
  }

  Widget buildRolesSelector() {
    return Column(
      children: <Widget>[
        widget.isAffairs
            ? const SizedBox()
            : Row(
                children: [
                  Radio<Role>(
                    value: Role.admin,
                    groupValue: _currentRole,
                    onChanged: (role) => _onChangeRole(context, role),
                  ),
                  const Text("Admin")
                ],
              ),
        !widget.isAffairs
            ? const SizedBox()
            : Row(
                children: [
                  Radio<Role>(
                    value: Role.student,
                    groupValue: _currentRole,
                    onChanged: (role) => _onChangeRole(context, role),
                  ),
                  const Text("Student")
                ],
              ),
        widget.isAffairs
            ? const SizedBox()
            : Row(
                children: [
                  Radio<Role>(
                    value: Role.affairs,
                    groupValue: _currentRole,
                    onChanged: (role) => _onChangeRole(context, role),
                  ),
                  const Text("Affairs")
                ],
              ),
        widget.isForQrIdentity
            ? const SizedBox()
            : Row(
                children: [
                  Radio<Role>(
                    value: Role.anonymous,
                    groupValue: _currentRole,
                    onChanged: (role) => _onChangeRole(context, role),
                  ),
                  const Text("Anonymous")
                ],
              ),
        widget.isAffairs
            ? const SizedBox()
            : Row(
                children: [
                  Radio<Role>(
                    value: Role.doctor,
                    groupValue: _currentRole,
                    onChanged: (role) => _onChangeRole(context, role),
                  ),
                  const Text("Doctor")
                ],
              ),
      ],
    );
  }

  void _onChangeRole(BuildContext context, Role? role) {
    if (role == null) {
      return;
    }
    setState(() {
      _currentRole = role;
    });
    Navigator.of(context).pop(role);
  }
}
