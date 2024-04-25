
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:m2m_plugin/m2m_plugin.dart';

class Demo extends StatefulWidget {
  const Demo({super.key});

  @override
  State<StatefulWidget> createState() => DemoState();

}

class DemoState extends State<Demo> {
  String _platformVersion = 'Unknown';
  final _m2mPlugin = M2mPlugin();

  void init() async{
    String platformVersion;
    try {
      platformVersion =
          await _m2mPlugin.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    _m2mPlugin.setListener(onListen);

    try {
      await _m2mPlugin.setUsedDomainName(false);
      await _m2mPlugin.setupLog(false);
      await _m2mPlugin.initializeSDK();

      String sid = "input host sid";
      String account = "input host account";
      String password = "input host password";

      await _m2mPlugin.create(sid, account, password, 3000);
    } on PlatformException catch (e){
      debugPrint("create Failed to : '${e.message}'.");
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  void uninitialized() async {
    try {
      await _m2mPlugin.closeAll();


    } on PlatformException catch (e) {
      debugPrint("closeAll Failed to : '${e.message}'.");
    }

    try {
      await _m2mPlugin.uninitializedSDK();

    } on PlatformException catch (e) {
      debugPrint("uninitializedSDK Failed to : '${e.message}'.");
    }

  }

  void getPort(String sid, int from) async {
    _m2mPlugin.getPort(sid, from).then((value) => debugPrint('getPort $from -> $value'));
  }

  void onListen(dynamic event) {
    debugPrint('get event $event');
    var data = jsonDecode(event);
    String sid = data['sid'];
    int p2pType =  int.parse(data['p2pType']);

    debugPrint('event $sid -> $p2pType');
    if (p2pType > 0) {
      getPort(sid, 554);
    }
  }

  @override
  void initState() {
    super.initState();

    init();
  }

  @override
  void dispose()  {
    uninitialized();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('M2M Demo'),
      ),
      body: Center(
        child: Text('Running on: $_platformVersion\n'),
      ),
    );
  }

}