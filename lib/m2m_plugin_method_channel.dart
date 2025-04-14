import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'm2m_plugin_platform_interface.dart';

/// An implementation of [M2mPluginPlatform] that uses method channels.
class MethodChannelM2mPlugin extends M2mPluginPlatform {
  /// The method channel used to interact with the native platform.

  final methodChannel = const MethodChannel('com.orbweb.m2m_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<bool> isReady() async {
    return await methodChannel.invokeMethod('isReady');
  }

  @override
  Future<bool> initializeSDK() async {
    return await methodChannel.invokeMethod('initializeSDK');
  }

  @override
  Future<bool> initializeWithChina() async {
    return await methodChannel.invokeMethod('initializeWithChina');
  }

  @override
  Future<bool> initializeWithRDZ(String rdz) async {
    return await methodChannel.invokeMethod('initializeWithRDZ', {'rdz': rdz});
  }

  @override
  Future<bool> uninitializedSDK() async {
    return await methodChannel.invokeMethod('uninitializedSDK');
  }

  @override
  Future<void> setupLog(bool value) async {
    await methodChannel.invokeMethod('setupLog', {'value': value});
  }

  @override
  Future<void> setUsedDomainName(bool value) async {
    await methodChannel.invokeMethod('setUsedDomainName', {'value': value});
  }

  @override
  Future<bool> create(String sid, String? account, String? password, int timeout) async {
    return await methodChannel.invokeMethod('create', {'sid' : sid, 'account' : account, 'password' : password , 'timeout': timeout});
  }

  @override
  Future<void> reConnect(String sid) async {
    return await methodChannel.invokeMethod('reconnect', {'sid' : sid});
  }

  @override
  Future<void> close(String sid) async{
    return await methodChannel.invokeMethod('close', {'sid' : sid});
  }

  @override
  Future<void> closeAll() async{
    try {
      await methodChannel.invokeMethod('closeAll');
    } on PlatformException catch (e) {
      debugPrint("closeAll Failed to : '${e.message}'.");
    }

  }

  @override
  Future<int> getConnectType(String sid) async{
    int type = -1;

    try {
      var value = await methodChannel.invokeMethod('getConnectType', {'sid': sid});
      type = value;
    } on PlatformException catch (e) {
      debugPrint("getConnectType Failed to : '${e.message}'.");
    }

    return type;
  }

  @override
  Future<int> getPort(String sid, int from) async {
    int port = -1;

    try {
      var value = await methodChannel.invokeMethod('getPort', {'sid': sid, 'from': from});
      port = value;
    } on PlatformException catch (e) {
      debugPrint("getPort Failed to : '${e.message}'.");
    }

    return port;
  }
  
  @override
  Future<int> initAudioTalk(int audioCode, int audioFormat, int audioRate) async {
    int sessionId = -1;
    try {
      var result = await methodChannel.invokeMethod('initAudioTalk',
          {'audioCode': audioCode,
          'audioFormat': audioFormat,
          'audioRate': audioRate}) ;

      sessionId = result;

    } on PlatformException catch (e) {
      debugPrint("initAudioTalk Failed to : '${e.message}'.");
    }

    return sessionId;
  }

  @override
  Future<void> closeAudio() async{

    try {
      await methodChannel.invokeMethod('closeAudio');
    } on PlatformException catch (e) {
      debugPrint("closeAudio Failed to : '${e.message}'.");
    }
  }
}
