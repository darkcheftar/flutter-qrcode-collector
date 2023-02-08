import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'qrscreen.dart';
import 'storage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        title: 'QR Code Collection',
        storage: QRCodeStorage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final QRCodeStorage storage;
  const MyHomePage({super.key, required this.title, required this.storage});
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _message = "";
  @override
  void initState() {
    super.initState();
    widget.storage.readqrcodes().then((value) {
      setState(() {
        qrcodes = value;
      });
    });
  }

  var qrcodes = <String>[];
  void _incrementCounter() {
    setState(() {
      _message = _message + 'a';
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
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: ListView(
        children: qrcodes
            .asMap()
            .entries
            .map((qrcode) => ListTile(
                  title: Text(qrcode.value),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        qrcodes = qrcodes
                            .asMap()
                            .entries
                            .where((e) => e.key != qrcode.key)
                            .toList()
                            .map((e) => e.value)
                            .toList();
                            
                      });
                    },
                  ),
                ))
            .toList(),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
            child: Icon(Icons.add),
            label: 'Add',
            onTap: _incrementCounter,
          ),
          SpeedDialChild(
            child: Icon(Icons.qr_code),
            label: 'Scan QR',
            onTap: () async {
              String result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const QRScanner()),
              );
              if (!mounted) return;
              setState(() {
                qrcodes.add(result);
              });
              widget.storage.writeqrcodes(qrcodes);
            },
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
