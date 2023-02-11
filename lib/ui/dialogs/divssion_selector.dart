import 'package:flutter/material.dart';
import '../../entities/Division.dart';

class DivisionSelector extends StatefulWidget {
  const DivisionSelector({Key? key}) : super(key: key);

  @override
  State<DivisionSelector> createState() => _DivisionSelectorState();
}

class _DivisionSelectorState extends State<DivisionSelector> {
  Division? _currentDivision;
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
              "Select Division ",
              style: Theme.of(context).textTheme.headline5,
            ),
            buildDivisionSelector()
          ],
        ),
      ),
    );
  }

  Widget buildDivisionSelector() {
    return Column(
      children: <Widget>[
        Row(
          children: [
            Radio<Division>(
              value: Division.d0,
              groupValue: _currentDivision,
              onChanged: (division) => _onChangeDivision(context, division),
            ),
            Text(divisionLabel(Division.d0))
          ],
        ),
        Row(
          children: [
            Radio<Division>(
              value: Division.d1,
              groupValue: _currentDivision,
              onChanged: (division) => _onChangeDivision(context, division),
            ),
            Text(divisionLabel(Division.d1))
          ],
        ),
        Row(
          children: [
            Radio<Division>(
              value: Division.d2,
              groupValue: _currentDivision,
              onChanged: (division) => _onChangeDivision(context, division),
            ),
            Text(divisionLabel(Division.d2))
          ],
        ),
      ],
    );
  }

  void _onChangeDivision(BuildContext context, Division? division) {
    if (division == null) {
      return;
    }
    setState(() {
      _currentDivision = division;
    });
    Navigator.of(context).pop(division);
  }
}
