# m2m connect plugin

###  m2m connect plugin

## Getting Started

### Add `m2m_plugin` as a [dependency in your pubspec.yaml file]

```yaml
dependencies:
  m2m_plugin:
    git: "https://github.com/orbweb/flutter_m2m_plugin.git"
```

```
$ flutter pub get
```

Import it
```dart
import 'package:m2m_plugin/m2m_plugin.dart';
```

## Quick Start

```dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:m2m_plugin/m2m_plugin.dart';
const rdzPath = 'Your rdz url';

class Demo extends StatefulWidget {
  const Demo({super.key});
  @override
  State<StatefulWidget> createState() => DemoState();
}

class DemoState extends State<Demo> {
    final _m2mPlugin = M2mPlugin();
    
    void init() async {
      try {
        await _m2mPlugin.setUsedDomainName(false);
        await _m2mPlugin.setupLog(false);
        //await _m2mPlugin.initializeSDK();  //default: rdz.orbwebsys.com
        await _m2mPlugin.initializeWithRDZ(rdzPath);
        
      } on PlatformException catch (e){
        debugPrint("initialize Failed to : '${e.message}'.");
      }
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
    
    void onListen(dynamic event) {
      var data = jsonDecode(event);
      String key = data['key'];
      if (key == 'm2m_status_change') {
        String sid = data['sid'];
        int p2pType =  int.parse(data['p2pType']);
        
        if (p2pType > 0) {
          getPort(sid, 80).then((mapPort) {
            //TODO implement http client. http://127.0.0.1:{mapPort}/{your_api}

          });

          getPort(sid, 554).then((mapPort) {
            //TODO implement http client. rtsp://127.0.0.1:{mapPort}/{your_rtsp_point}

          });
        }
      }
    }

    @override
    void initState() {
      super.initState();
      _m2mPlugin.setListener(onListen);
      init();
    }

    @override
    void dispose()  {
      uninitialized();
      super.dispose();
    }
}


```