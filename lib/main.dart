import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'theme_app.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.darkThemeEnabled,
      initialData: false,
      builder: (context, snapshot) => new MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: snapshot.data ? darkTheme(context) : lightTheme(context),
            home: new MyHomePage(
              title: 'My Contact',
              isDarkEnabled: snapshot.data,
            ),
          ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.isDarkEnabled}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  bool isDarkEnabled;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String fullName;
  String phoneNumber;
  String vcard;

  void _incrementCounter() {
    setState(() {
      vcard = "BEGIN:VCARD\n" +
          "FN:$fullName\n"
          "TEL;CELL:$phoneNumber\n" +
          "END:VCARD";
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(widget.title),
        actions: <Widget>[
          Switch(value: widget.isDarkEnabled, onChanged: bloc.changeTheme)
        ],
      ),
      body: new Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: _buildWidget(),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _askToLead,
        tooltip: 'Increment',
        child: new Icon(Icons.contact_phone),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildWidget() {
    if (vcard == null) {
      return Text('Please input data..');
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          QrImage(
              data: vcard,
              size: 300.0,
              backgroundColor:
                  widget.isDarkEnabled ? Colors.white : Colors.white),
          Padding(
            padding: const EdgeInsets.only(top: 18.0),
            child: Text('Scan Me..', style: TextStyle(fontSize: 18.0),),
          )
        ],
      );
    }
  }

  Future<Null> _askToLead() async {
    var fullNameController = TextEditingController();
    var phoneNumberController = TextEditingController();
    if (fullName != null) {
      fullNameController.text = fullName;
    }
    if (phoneNumber != null) {
      phoneNumberController.text = phoneNumber;
    }

    switch (await showDialog<DialogInformation>(
        context: context,
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Information Detail'),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    _incrementCounter();
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
            body: new Form(
                onWillPop: _onWillPop,
                child: new ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: <Widget>[
                      new Container(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          alignment: Alignment.bottomLeft,
                          child: new TextField(
                            controller: fullNameController,
                            decoration: const InputDecoration(
                                labelText: 'Full Name', filled: true),
                            onChanged: (String value) {
                              if (value.isNotEmpty) {
                                fullName = value;
                              }
                            },
                          )),
                      new Container(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          alignment: Alignment.bottomLeft,
                          child: new TextField(
                              controller: phoneNumberController,
                              decoration: const InputDecoration(
                                  labelText: 'Phone Number',
                                  hintText: '08xxxxxxxxxx',
                                  filled: true),
                              onChanged: (String value) {
                                if (value.isNotEmpty) {
                                  phoneNumber = value;
                                }
                              }))
                    ])),
          );
        })) {
      case DialogInformation.Ok:
        Navigator.pop(context);
        break;
      case DialogInformation.Cancel:
        Navigator.pop(context);
        break;
    }
  }

  Future<bool> _onWillPop() async {
    return await showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text('Discard Information'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  FlatButton(
                    child: Text('Discard'),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  )
                ],
              );
            }) ??
        false;
  }
}

enum DialogInformation { Ok, Cancel }

class Bloc {
  final _themeController = StreamController<bool>();

  get changeTheme => _themeController.sink.add;

  get darkThemeEnabled => _themeController.stream;
}

final bloc = Bloc();
