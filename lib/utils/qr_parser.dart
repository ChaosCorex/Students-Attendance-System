class QrParser {
  void parse(String qrData, Function(QrFunctions?, String) result) {
    final data = qrData.split(qrDataFunctionSeparator);
    if (data.length < 2) {
      return;
    }
    result(qrFunctionsFromString(data[0]), data[1]);
  }
}

const qrDataFunctionSeparator = "#";

enum QrFunctions { identity, attendance }

QrFunctions? qrFunctionsFromString(String function) {
  QrFunctions? value;
  for (var item in QrFunctions.values) {
    if (item.toString() == function) {
      value = item;
      break;
    }
  }
  return value;
}
