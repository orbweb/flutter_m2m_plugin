
import 'dart:async';

import 'package:flutter/services.dart';
import 'm2m_plugin_platform_interface.dart';

const event = EventChannel('com.orbweb.demo/event');

class M2mPlugin {

  late StreamSubscription _streamSubscription;
  late Function(dynamic data)? _mListen;

  final Completer<void> _completer;

  M2mPlugin() : _completer = Completer(){

  }

  /// Get M2M Plugin version
  Future<String?> getPlatformVersion() {
    return M2mPluginPlatform.instance.getPlatformVersion();
  }

  /// Check M2M Plugin status
  Future<bool> isReady() {
    return M2mPluginPlatform.instance.isReady();
  }

  /// Initialize M2M Plugin with standard
  Future<bool> initializeSDK() {
    _initValue();
    return M2mPluginPlatform.instance.initializeSDK();
  }

  /// Initialize M2M Plugin with china
  Future<bool> initializeWithChina() {
    _initValue();
    return M2mPluginPlatform.instance.initializeWithChina();
  }

  /// Initialize M2M Plugin by manual
  /// Please enter the [rdz] domain name
  Future<bool> initializeWithRDZ(String rdz) {
    _initValue();
    return M2mPluginPlatform.instance.initializeWithRDZ(rdz);
  }

  /// Uninitialized M2M Plugin
  Future<bool> uninitializedSDK() {
    _release();
    return M2mPluginPlatform.instance.uninitializedSDK();
  }

  /// Enable/Disable debug message
  Future<void> setupLog(bool value) async {
    return M2mPluginPlatform.instance.setupLog(value);
  }

  /// Enable/Disable Domain name resolution
  Future<void> setUsedDomainName(bool value) async{
    return M2mPluginPlatform.instance.setUsedDomainName(value);
  }

  /// Create m2m connection by [sid]
  /// m2mPlugin.create('sid', 'user', 'password', 3000);
  Future<bool> create(String sid, String account, String password, int timeout) async{
    await _completer.future;
    return M2mPluginPlatform.instance.create(sid, account, password, timeout);
  }

  /// Reconnect by [sid]
  Future<void> reConnect(String sid) async {
    await _completer.future;
    return M2mPluginPlatform.instance.reConnect(sid);
  }

  /// Close connection by [sid]
  Future<void> close(String sid) async {
    await _completer.future;
    return M2mPluginPlatform.instance.close(sid);
  }

  /// Close all connection
  Future<void> closeAll() async {
    await _completer.future;
    return M2mPluginPlatform.instance.closeAll();
  }

  Future<int> getConnectType(String sid) async {
    await _completer.future;
    return M2mPluginPlatform.instance.getConnectType(sid);
  }

  /// Get mapping port by [sid]
  /// m2mPlug.getPort('sid', 554);
  Future<int> getPort(String sid, int from) async {
    await _completer.future;
    return M2mPluginPlatform.instance.getPort(sid, from);
  }

  /// Set M2M connection status listener
  void setListener(Function(dynamic data)? listen) {
    _mListen = listen;
  }

  /// setup audio talk
  /// [audioCode] pcm :0 ,aLaw : 1 ,uLaw : 2
  /// [audioFormat] 16bit :2, 8bit :3
  /// [audioRate] 8000 ~ 14400
  Future<int> initAudioTalk(int audioCode, int audioFormat, int audioRate) async{
    await _completer.future;
    return M2mPluginPlatform.instance.initAudioTalk(audioCode, audioFormat, audioRate);
  }

  /// stop audio talk
  Future<void> closeAudio() async{
    await _completer.future;
    return M2mPluginPlatform.instance.closeAudio();
  }

  void _initValue() {
    _streamSubscription = event.receiveBroadcastStream().listen((event) {
      if (_mListen != null) {
        _mListen!(event);
      }
    });
    _completer.complete();
  }

  void _release() {
    _streamSubscription.cancel();
    _mListen = null;
  }

}
