import 'package:flutter/material.dart';

class EnterNationalID extends StatelessWidget {
  EnterNationalID({Key? key}) : super(key: key);

  final _nationalIdController = TextEditingController();

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
              "Add New Identity",
              style: Theme.of(context).textTheme.headline5,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: _nationalIdController,
              decoration: const InputDecoration(
                filled: true,
                labelText: "National ID",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            ElevatedButton(
              onPressed: () => _onDoneClick(context),
              child: const Text("Done"),
            )
          ],
        ),
      ),
    );
  }

  void _onDoneClick(BuildContext context) {
    Navigator.of(context).pop(_nationalIdController.text);
  }
}
