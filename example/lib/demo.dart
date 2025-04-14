
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:m2m_plugin/m2m_plugin.dart';
import 'package:permission_handler/permission_handler.dart';

class Demo extends StatefulWidget {
  const Demo({super.key});

  @override
  State<StatefulWidget> createState() => DemoState();

}

class DemoState extends State<Demo> {
  String _platformVersion = 'Unknown';
  final _m2mPlugin = M2mPlugin();

  void init() async{

    await [Permission.microphone].request();

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


      // String sid = "B5Y4E4CQSUS69V52QAAR";
      // String account = "user";
      // String password = "password";
      //
      // await _m2mPlugin.create(sid, account, password, 3000);

      var sessionId =  await _m2mPlugin.initAudioTalk(2, 2, 8000);

      debugPrint('sessionId = $sessionId');
      
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
      await _m2mPlugin.closeAudio();
    } on PlatformException catch (e) {
      debugPrint("closeAudio Failed to : '${e.message}'.");
    }

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

  Future<int> getPort(String sid, int from) async {
    return _m2mPlugin.getPort(sid, from);
  }

  void onListen(dynamic event) {
    debugPrint('get event $event');
    var data = jsonDecode(event);
    String key = data['key'];
    if (key == 'm2m_status_change') {
      String sid = data['sid'];
      int p2pType =  int.parse(data['p2pType']);

      debugPrint('event $sid -> $p2pType');
      if (p2pType > 0) {
        getPort(sid, 80).then((mapPort) {
          //TODO implement http client. ex: http://127.0.0.1:{mapPort}/your_api

        });
      }
    } else if (key == 'audioData') {
      String base64 = data['audioData'];
      var audioData = const Base64Decoder().convert(base64);
      //TODO send audio data
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