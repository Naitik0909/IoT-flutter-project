import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iotledsystem/utility/utilities.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PowerSwitch extends StatefulWidget {
  final String selectedDevice;
  PowerSwitch({this.selectedDevice});

  @override
  _PowerSwitchState createState() => _PowerSwitchState();
}

class _PowerSwitchState extends State<PowerSwitch> {
  Color currentColor = Colors.white;

  @override
  void initState() {
    super.initState();
  }

  Future<void> getLastColor() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("lastColor${widget.selectedDevice}")) {
      int lastColor = prefs.getInt("lastColor${widget.selectedDevice}");
      setState(() {
        currentColor = Color(lastColor);
      });
    }
  }

  void turnDeviceOn() async {
    await getLastColor();

    setColor(currentColor, context, widget.selectedDevice, false);
    snackBarMessage(context, "Turned on ${widget.selectedDevice}");
  }

  void turnDeviceOff() async {
    try {
      var url = Uri.parse('http://${widget.selectedDevice}/colour');
      var res = await http.post(url,
          body: {"r": "0", "g": "0", "b": "0"});
      if (res.statusCode == 200) {
        snackBarMessage(context, "Turned off ${widget.selectedDevice}");
      } else {
        snackBarMessage(context, "Device Error");
      }
    } on SocketException {
      snackBarMessage(context, "Connection Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      color: Colors.teal,
      title: "POWER",
      onTab: null,
      actions: [
        FlatButton(
          color: Colors.green,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          child: Text(
            "Turn on",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => turnDeviceOn(),
        ),
        SizedBox(
          width: 10,
        ),
        FlatButton(
          color: Colors.red,
          shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20)),
          child: Text(
            "Turn off",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => turnDeviceOff(),
        ),
      ],
    );
  }
}

class BaseCard extends StatelessWidget {
  final Color color;
  final String title;
  final List<Widget> actions;
  final Function onTab;
  final Function onDoubleTap;
  BaseCard(
      {this.color, this.title, this.actions, this.onTab, this.onDoubleTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onDoubleTap: onDoubleTap == null ? null : onDoubleTap,
            onTap: onTab == null ? null : onTab,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 0,
              color: color,
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(23, 15, 15, 15),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w700),
                        ),
                        Row(
                          children: actions,
                        )
                      ],
                    ),
                  )),
            ),
          ),
        ),
      ],
    );
  }
}

// BASE-CARD END