import 'package:flutter_test/flutter_test.dart';
import 'package:m2m_plugin/m2m_plugin.dart';
import 'package:m2m_plugin/m2m_plugin_platform_interface.dart';
import 'package:m2m_plugin/m2m_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockM2mPluginPlatform
    with MockPlatformInterfaceMixin
    implements M2mPluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<bool> initializeSDK() {
    // TODO: implement initializeSDK
    throw UnimplementedError();
  }

  @override
  Future<bool> initializeWithChina() {
    // TODO: implement initializeWithChina
    throw UnimplementedError();
  }

  @override
  Future<bool> initializeWithRDZ(String rdz) {
    // TODO: implement initializeWithRDZ
    throw UnimplementedError();
  }

  @override
  Future<bool> isReady() {
    // TODO: implement isReady
    throw UnimplementedError();
  }

  @override
  Future<void> setupLog(bool value) {
    // TODO: implement setupLog
    throw UnimplementedError();
  }

  @override
  Future<bool> uninitializedSDK() {
    // TODO: implement uninitializedSDK
    throw UnimplementedError();
  }

  @override
  Future<void> setUsedDomainName(bool value) {
    // TODO: implement setUsedDomainName
    throw UnimplementedError();
  }

  @override
  Future<bool> create(String sid, String? account, String? password, int timeout) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<void> reConnect(String sid) {
    throw UnimplementedError();
  }

  @override
  Future<void> closeAll() {
    // TODO: implement closeAll
    throw UnimplementedError();
  }

  @override
  Future<void> close(String sid) {
    // TODO: implement close
    throw UnimplementedError();
  }

  @override
  Future<int> getPort(String sid, int from) {
    // TODO: implement getPort
    throw UnimplementedError();
  }
}

void main() {
  final M2mPluginPlatform initialPlatform = M2mPluginPlatform.instance;

  test('$MethodChannelM2mPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelM2mPlugin>());
  });

  test('getPlatformVersion', () async {
    M2mPlugin m2mPlugin = M2mPlugin();
    MockM2mPluginPlatform fakePlatform = MockM2mPluginPlatform();
    M2mPluginPlatform.instance = fakePlatform;

    expect(await m2mPlugin.getPlatformVersion(), '42');
  });
}
