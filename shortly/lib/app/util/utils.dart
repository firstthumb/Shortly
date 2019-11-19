import 'package:flutter/services.dart';

Future<String> getClipBoardData() async {
  ClipboardData data = await Clipboard.getData(Clipboard.kTextPlain);
  if (data == null) {
    return null;
  }

  return data.text;
}

Future<void> setClipBoardData(String text) async {
  await Clipboard.setData(ClipboardData(text: text));
}
