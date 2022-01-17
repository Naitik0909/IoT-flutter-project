
import 'package:flutter/material.dart';
import 'package:iotledsystem/widgets/colorchanger.dart';
import 'package:iotledsystem/widgets/powerswitch.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'utility/pick_image.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:async';
import 'dart:io';
import 'widgets/image_list_widget.dart';

void snackBarMessage(BuildContext context, String message) {
  Scaffold.of(context).removeCurrentSnackBar();
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text(message),
  ));
}

void main() =>
    runApp(MaterialApp(debugShowCheckedModeBanner: false, home: RemotePage()));

// Entry-Page
class RemotePage extends StatefulWidget {
  @override
  _RemotePageState createState() => _RemotePageState();
}

class _RemotePageState extends State<RemotePage> {
  TextEditingController _c;
  List<File> imageFiles = [];
  File imageFile;

  @override
  void initState() {
    super.initState();
    getControllers();
    _c = TextEditingController();
  }

  List<String> conList;
  String selectedDevice;

  void getControllers() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("conList") && prefs.containsKey("lastDevice")) {
      setState(() {
        conList = prefs.getStringList("conList");
        selectedDevice = prefs.getString("lastDevice");
      });
    } else {
      setState(() {
        conList = [];
        selectedDevice = null;
      });
    }
  }

  void saveDevices() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList("conList", conList);
    prefs.setString("lastDevice", selectedDevice);
  }

  Widget deviceDropDown() {
    if (selectedDevice != null && conList != null) {
      return DropdownButton<String>(
        icon: Icon(
          Icons.arrow_downward,
          color: Colors.amber,
        ),
        underline: Container(
          height: 0,
        ),
        dropdownColor: Colors.grey,
        value: selectedDevice,
        style: TextStyle(fontSize: 18, color: Colors.white),
        onChanged: (String newDevice) {
          setState(() {
            selectedDevice = newDevice;
            saveDevices();
          });
        },
        items: conList.map<DropdownMenuItem<String>>((String device) {
          return DropdownMenuItem<String>(
            value: device,
            child: Text(
              device,
            ),
          );
        }).toList(),
      );
    } else if (conList == null) {
      return Row(
        children: [
          Text(
            "loading devices",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          SizedBox(
            width: 5,
          )
        ],
      );
      // conList.isEmpty
    } else {
      return Row(
        children: [
          Text(
            "add your first device",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          SizedBox(
            width: 5,
          )
        ],
      );
    }
  }

  // Managing devices

  String lastRemovedDevice;

  void undoRemoveDevice(BuildContext context) {
    if (lastRemovedDevice != null) {
      setState(() {
        conList.add(lastRemovedDevice);
        selectedDevice = lastRemovedDevice;
      });
      saveDevices();
      snackBarMessage(context, "readded $lastRemovedDevice");
      lastRemovedDevice = null;
    } else {
      snackBarMessage(context, "nothing to readd");
    }
  }

  void removeDevice(BuildContext context) {
    int conListLength = conList.length;
    if (conListLength == 0) {
      snackBarMessage(context, "no devices to remove");
    } else if (conListLength == 1) {
      setState(() {
        conList = [];
        selectedDevice = null;
      });
      saveDevices();
      snackBarMessage(context, "removed last device");
    } else {
      lastRemovedDevice = selectedDevice;
      setState(() {
        conList.remove(selectedDevice);
        selectedDevice = conList[0];
      });
      saveDevices();
      snackBarMessage(context, "removed $lastRemovedDevice");
    }
  }

  void addDevice() {
    showDialog(
      context: context,
        builder: (BuildContext context) => AlertDialog(
          contentTextStyle: TextStyle(color: Colors.amberAccent),
          backgroundColor: Colors.black,
          actions: <Widget>[
            FlatButton(
                child: const Text(
                  'cancel',
                  style: TextStyle(color: Colors.amberAccent),
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
            FlatButton(
                child: const Text(
                  'add',
                  style: TextStyle(color: Colors.amberAccent),
                ),
                onPressed: () {
                  setState(() {
                    conList.add(_c.text);
                    selectedDevice = conList.last;
                    saveDevices();
                  });
                  _c.clear();
                  Navigator.pop(context);
                })
          ],
          contentPadding: const EdgeInsets.all(16.0),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextField(
                    controller: _c,
                    cursorColor: Colors.amberAccent,
                    style: TextStyle(color: Colors.white),
                    autofocus: true,
                    decoration: InputDecoration(
                        labelText: "IP-Adress",
                        labelStyle: TextStyle(color: Colors.amberAccent))),
              ),
            ],
          ),
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light(),
      child: Scaffold(
        backgroundColor: Color(0xffdedede),
        appBar: AppBar(
          actions: [
            Center(child: deviceDropDown()),
            Builder(
              builder: (context) => GestureDetector(
                child: Icon(Icons.add, color: Colors.black),
                onTap: () {
                  addDevice();
                },
                onLongPress: () {
                  removeDevice(context);
                },
                onDoubleTap: () {
                  undoRemoveDevice(context);
                },
              ),
            ),
          ],
          elevation: 0,
          title: Text(
            "IOT LED SYSTEM",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0xff57C902),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              PowerSwitch(
                selectedDevice: selectedDevice,
              ),
              ColorChanger(
                color: Colors.teal,
                selectedDevice: selectedDevice,
              ),
//            imageFile != null ? Image.file(imageFile) : Container(),
//            ImageListWidget(imageFiles: imageFiles),

              FloatingActionButton(
                onPressed: startUpload,
                child: Icon(Icons.add),
              ),
              FlatButton(
                color: Colors.green,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Text(
                  "Show changes",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: (){
                  
                },
              ),

            ],
          ),
        ),
      ),
    );
  }

  Future startUpload() async {
    final file = await FilePickCrop.pickMedia(
      cropImage: cropSquareImage,
    );

    if(file == null) return;
    if (imageFiles.length == 1){
      setState(() {
        imageFiles.removeLast();
      });
    }

    setState(() {
      imageFiles.add(file);
    });

    print(imageFiles.length);
    print("-------------------------------");
  }

}