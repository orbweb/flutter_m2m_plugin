
import 'dart:async';

import 'package:flutter/services.dart';
import 'm2m_plugin_platform_interface.dart';

const event = EventChannel('com.orbweb.demo/event');

class M2mPlugin {

  late StreamSubscription _streamSubscription;
  late Function(dynamic data)? mListen;

  Future<String?> getPlatformVersion() {
    return M2mPluginPlatform.instance.getPlatformVersion();
  }

  Future<bool> isReady() {
    return M2mPluginPlatform.instance.isReady();
  }

  Future<bool> initializeSDK() {
    initValue();
    return M2mPluginPlatform.instance.initializeSDK();
  }

  Future<bool> initializeWithChina() {
    initValue();
    return M2mPluginPlatform.instance.initializeWithChina();
  }

  Future<bool> initializeWithRDZ(String rdz) {
    initValue();
    return M2mPluginPlatform.instance.initializeWithRDZ(rdz);
  }

  Future<bool> uninitializedSDK() {
    release();
    return M2mPluginPlatform.instance.uninitializedSDK();
  }

  Future<void> setupLog(bool value) {
    return M2mPluginPlatform.instance.setupLog(value);
  }

  Future<void> setUsedDomainName(bool value) {
    return M2mPluginPlatform.instance.setUsedDomainName(value);
  }

  Future<bool> create(String sid, String account, String password, int timeout) {
    return M2mPluginPlatform.instance.create(sid, account, password, timeout);
  }

  Future<void> reConnect(String sid) {
    return M2mPluginPlatform.instance.reConnect(sid);
  }

  Future<void> close(String sid) {
    return M2mPluginPlatform.instance.close(sid);
  }
  
  Future<void> closeAll() {
    return M2mPluginPlatform.instance.closeAll();
  }

  Future<int> getPort(String sid, int from) {
    return M2mPluginPlatform.instance.getPort(sid, from);
  }

  void setListener(Function(dynamic data) listen) {
    mListen = listen;
  }

  void initValue() {
    _streamSubscription = event.receiveBroadcastStream().listen((event) {
      if (mListen != null) {
        mListen!(event);
      }
    });
  }

  void release() {
    _streamSubscription.cancel();
    mListen = null;
  }

}
