import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//impor

void snackBarMessage(BuildContext context, String message) {
  Scaffold.of(context).removeCurrentSnackBar();
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text(message),
  ));
}

colorToHexString(Color color) {
  return '${color.value.toRadixString(16).substring(2, 8)}';
}

void setColor(Color color, BuildContext context, String selectedDevice, bool blink) async {
  try {
    var bitmap24=[


      0xD1A4, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x7F0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,    // 0x0010 1 -(00-14) pixels
      0x0000, 0x7F007F, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x7F0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,    // 0x0020 2 -(15-29) pixels

      0x0000, 0x0000, 0x7F007F, 0x0000, 0x0000, 0x0000, 0x7F0000, 0x7F0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,    // 0x0030 3 -(30-44) pixels
      0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x7F0000, 0x7F0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,    // 0x0040 4 -(45-59) pixels

      0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x7F0000, 0x7F0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,    // 0x0050 5 -(60-74) pixels
      0x0000, 0x0000, 0x0000, 0x0000, 0x7F007F, 0x0000, 0x0000, 0x7F0000, 0x7F0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,    // 0x0060 6 -(75-89) pixels

      0x0000, 0x0000, 0x0000, 0x7F007F, 0x0000, 0x0000, 0x0000, 0x7F0000, 0x7F0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,    // 0x0070 7 -(90-104) pixels
      0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x7F0000, 0x7F0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,    // 0x0080 8 -(105-119) pixels

      0x0000, 0xD1A4, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x7F0000, 0x7F0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,    // 0x0090 9 -(120-134) pixels
      0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x7F0000, 0x7F0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,    // 0x00A0 10(135-159) pixels

      0x0000, 0x0000, 0x0000, 0xA902, 0xA902, 0xA902, 0xA902, 0xA902, 0xA902, 0xA902, 0xA902, 0xA902, 0x0000, 0x0000, 0x0000,    // 0x00B0 11-(150-164) pixels
      0x0000, 0x0000, 0xA902, 0xA902, 0xA902, 0xA902, 0xA902, 0xA902, 0xA902, 0xA902, 0xA902, 0xA902, 0xA902, 0x0000, 0x0000,    // 0x00C0 12-(165-179) pixels

      0x0000, 0xA902, 0xA902, 0xA902, 0xA902, 0x00007f, 0x00, 0x00007f, 0x00007f, 0x00007f, 0xA902, 0xA902, 0xA902, 0xA902, 0x0000,    // 0x00D0 13-(180-194) pixels
      0x0000, 0xA902, 0xA902, 0xA902, 0xA902, 0x00, 0x7F007F, 0x00007f, 0x7F007F, 0x00007f, 0xA902, 0xA902, 0xA902, 0xA902, 0x0000,    // 0x00E0 14-(195-209) pixels

      0x0000, 0xA902, 0xA902, 0xA902, 0xA902, 0x00007f, 0x00007f, 0x00007f, 0x00007f, 0x00007f, 0xA902, 0xA902, 0xA902, 0xA902, 0x0000,    // 0x00F0 15-(210-224) pixels
      0x0000, 0x0000, 0xA902, 0xA902, 0xA902, 0x00007f, 0x7F007F, 0x00007f, 0x7F007f, 0x00, 0xA902, 0xA902, 0xA902, 0x0000, 0x0000,    // 0x0100 16-(225-239) pixels

      0x0000, 0x0000, 0xA902, 0xA902, 0xA902, 0x00007f, 0x00007f, 0x00007f, 0x00, 0x00007f, 0xA902, 0xA902, 0xA902, 0x0000, 0x0000,    // 0x0110 17-(240-254) pixels
      0x0000, 0x0000, 0x0000, 0xA902, 0xA902, 0xA902, 0xA902, 0xA902, 0xA902, 0xA902, 0xA902, 0xA902, 0x0000, 0x0000, 0x0000,    // 0x0120 18-(255-269) pixels

      0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0xA902, 0xA902, 0xA902, 0xA902, 0xA902, 0xA902, 0x0000, 0x0000, 0x0000, 0x0000,    // 0x0130 19-(270-284) pixels
      0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000    // 0x0140 20-(285-300) pixels

    ];

    String blinkStatus="OFF";
    blinkStatus = blink ? "ON" : "OFF";
    var url = Uri.parse('http://$selectedDevice/colour');
    var res = await http.post(url, body: {
//      "r": color.red.toString(),
//      "g": color.green.toString(),
//      "b": color.blue.toString(),
      "blink":blinkStatus,
      "hex":colorToHexString(color)
//      "color_hex": colorToHexString(color)
    });
    if (res.statusCode != 200) {
      snackBarMessage(context, "Device Error setting color");
    }
  } on SocketException {
    snackBarMessage(context, "Connection Error");
  }
}

void setImage(File file, BuildContext context) async{

}