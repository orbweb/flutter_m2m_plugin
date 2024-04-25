import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'm2m_plugin_method_channel.dart';

abstract class M2mPluginPlatform extends PlatformInterface {
  /// Constructs a M2mPluginPlatform.
  M2mPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static M2mPluginPlatform _instance = MethodChannelM2mPlugin();

  /// The default instance of [M2mPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelM2mPlugin].
  static M2mPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [M2mPluginPlatform] when
  /// they register themselves.
  static set instance(M2mPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool> isReady() {
    throw UnimplementedError('isReady() has not been implemented.');
  }

  Future<bool> initializeSDK() {
    throw UnimplementedError('initializeSDK() has not been implemented.');
  }

  Future<bool> initializeWithChina() {
    throw UnimplementedError('initializeWithChina() has not been implemented.');
  }

  Future<bool> initializeWithRDZ(String rdz) {
    throw UnimplementedError('initializeWithRDZ() has not been implemented.');
  }

  Future<bool> uninitializedSDK() {
    throw UnimplementedError('uninitializedSDK() has not been implemented.');
  }

  Future<void> setupLog(bool value) {
    throw UnimplementedError('setupLog() has not been implemented.');
  }

  Future<void> setUsedDomainName(bool value) {
    throw UnimplementedError('setUsedDomainName() has not been implemented.');
  }

  Future<bool> create(String sid, String account, String password, int timeout) {
    throw UnimplementedError('create() has not been implemented.');
  }

  Future<void> reConnect(String sid) {
    throw UnimplementedError('reConnect() has not been implemented.');
  }

  Future<void> close(String sid) {
    throw UnimplementedError('close() has not been implemented.');
  }

  Future<void> closeAll() {
    throw UnimplementedError('closeAll() has not been implemented.');
  }

  Future<int> getPort(String sid, int from) {
    throw UnimplementedError('getPort() has not been implemented.');
  }
}
