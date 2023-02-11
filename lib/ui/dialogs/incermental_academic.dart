import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../entities/activeAcademic.dart';
import '../../services/academic_service.dart';

class IncrementalAcademic extends StatefulWidget {
  const IncrementalAcademic({Key? key}) : super(key: key);

  @override
  State<IncrementalAcademic> createState() => _IncrementalAcademicState();
}

class _IncrementalAcademicState extends State<IncrementalAcademic> {
  final _academicServices = AcademicService();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: kIsWeb ? 400 : 200,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          alignment: WrapAlignment.center,
          runSpacing: 8,
          children: [
            Text(
              " Edit Academic Years",
              style: Theme.of(context).textTheme.headline6,
            ),
            StreamBuilder<ActiveAcademic>(
                stream: _academicServices.getItemStreamById("ssasActiveYear"),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return Text(snapshot.error.toString());
                  }
                  if (snapshot.hasData) {
                    final activeAcademic = snapshot.data!;

                    return buildIncerementalSelector(
                        context, activeAcademic.incrementalAcademic);
                  }
                  return SizedBox();
                }),
          ],
        ),
      ),
    );
  }

  Widget buildIncerementalSelector(BuildContext context, num increment) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        IconButton(
            onPressed: () async {
              await _academicServices.updateActiveAcademicYearInfo(
                  "ssasActiveYear",
                  ActiveAcademic.incrementalAcademicKey,
                  ++increment);
            },
            icon: Icon(
              Icons.add,
              size: 30,
            )),
        Text(
          "$increment",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 22,
          ),
        ),
        IconButton(
            onPressed: () async {
              await _academicServices.updateActiveAcademicYearInfo(
                  "ssasActiveYear",
                  ActiveAcademic.incrementalAcademicKey,
                  --increment);
            },
            icon: Icon(
              Icons.remove,
              size: 28,
            ))
      ],
    );
  }
}
