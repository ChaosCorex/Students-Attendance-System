import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../entities/app_user.dart';

class EditSubjectInfo extends StatefulWidget {
   final String editType;
  const EditSubjectInfo({required this.editType, Key? key})
      : super(key: key);

  @override
  State<EditSubjectInfo> createState() => _EditSubjectInfoState();
}

class _EditSubjectInfoState extends State<EditSubjectInfo> {
  final _EditsubjectInfodController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(16.0), child: _buildBody());
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Container(
        width: kIsWeb?600:200,
        child: Column(
          children: [
            TextFormField(
              keyboardType: TextInputType.number,
              controller: _EditsubjectInfodController,
              decoration:  InputDecoration(
                filled: true,
                labelText: widget.editType,
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
              onPressed: _onSaveClick,
              child: const Text("Save"),
            )
          ],
        ),
      ),
    );
  }

  void _onSaveClick() async {
    if (_EditsubjectInfodController.text.trim().isEmpty) return;
    Navigator.of(context).pop(_EditsubjectInfodController.text.trim());
  }
}
