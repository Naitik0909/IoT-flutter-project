import 'package:flutter/material.dart';
import 'package:iotledsystem/utility/utilities.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';
import 'package:flutter_switch/flutter_switch.dart';


class ColorChanger extends StatefulWidget {
  final String selectedDevice;
  final Color color;
  ColorChanger({this.color, this.selectedDevice});

  @override
  _ColorChangerState createState() => _ColorChangerState();
}

class _ColorChangerState extends State<ColorChanger> {
  Color currentColor = Colors.white;
  bool firstUserInteraction;
  bool status = false;

  @override
  void initState() {
    firstUserInteraction = false;
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

  Icon getColorIcon() {
    if (!firstUserInteraction || firstUserInteraction == null) {
      getLastColor();
    }
    return Icon(Icons.bubble_chart, color: currentColor);
  }

  void setLastColor(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt("lastColor${widget.selectedDevice}", color.value);
  }

  void changecolor(Color color) {
    setState(() => currentColor = color);
    // performance-issues
    // setColor(color);
  }

  @override
  Widget build(BuildContext context) {
    // Shuold use a FutureBuilder
    return Column(
      children: [
        CircleColorPicker(
          initialColor: currentColor,
          onChanged: _onColorChanged,
          colorCodeBuilder: (context, color) {
            return Text(
              'rgb(${color.red}, ${color.green}, ${color.blue})',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            );
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Blinking'),
            SizedBox(width: 25.0,),
            FlutterSwitch(
              value: status,

//              showOnOff: true,
              onToggle: (val) {
                setState(() {
                  status = val;
                });
              },
            ),
          ],
        ),
        SizedBox(height: 15.0,),
        FlatButton(
          color: Colors.green,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          child: Text(
            "Show changes",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: (){
//    print(currentColor.red.toString());
////    print(currentColor.green.toString());
////    print(currentColor.blue.toString());
            setColor(currentColor, context, widget.selectedDevice, status);
          },
        ),



      ],
    );
  }

  void _onColorChanged(Color color) {
    setState(() => currentColor = color);
//    print(currentColor.red.toString());
////    print(currentColor.green.toString());
////    print(currentColor.blue.toString());
//    setColor(currentColor, context, widget.selectedDevice);
  }
}