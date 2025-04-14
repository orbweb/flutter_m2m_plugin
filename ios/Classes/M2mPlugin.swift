import Flutter
import UIKit
import M2MKit

public class M2mPlugin: NSObject, FlutterPlugin {
    var audioTalk: AudioTalk?
    let eventChannel: M2MEventChannel

    override init() {
        self.eventChannel = M2MEventChannel()
        super.init()
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "com.orbweb.m2m_plugin", binaryMessenger: registrar.messenger())
        let instance = M2mPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)

        instance.eventChannel.setupEventChannel(name: "com.orbweb.demo/event", messenger: registrar.messenger())
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        //let args = call.arguments as? Dictionary<String, Any>

        switch call.method {
        case "getPlatformVersion":
            //result("iOS " + UIDevice.current.systemVersion)
            result(OBDeviceManager.getVersion())
        case "isReady":
            result(OBDeviceManager.isReady())
        case "initializeSDK":
            result(OBDeviceManager.initializeSDK())
        case "initializeWithChina":
            result(OBDeviceManager.initializeSDKWithChina())
        case "initializeWithRDZ":
            if let args = call.arguments as? Dictionary<String, Any>,
               let rdz = args["rdz"] as? String {
                    result(OBDeviceManager.initializeSDKRDZ(rdz))
                } else {
                    result(FlutterError.init(code: "error", message: "rdz path nil", details: nil))
        }
        case "uninitializedSDK":
            OBDeviceManager.uninitializeSDK()
            result(nil)
        case "setupLog":
            if let args = call.arguments as? Dictionary<String, Any>,
               let value = args["value"] as? Bool {
                    OBDeviceManager.setupLog(value)
                    result(nil)
                } else {
                    result(FlutterError.init(code: "error", message: "value nil", details: nil))
                }
        case "setUsedDomainName":
            if let args = call.arguments as? Dictionary<String, Any>,
               let value = args["value"] as? Bool {
                    OBDeviceManager.setUsedDomainName(value)
                    result(nil)
                } else {
                    result(FlutterError.init(code: "error", message: "value nil", details: nil))
                }
        case "create":
            if let args = call.arguments as? Dictionary<String, Any>,
                let sid = args["sid"] as? String ,
                let account = args["account"] as? String ,
                let password = args["password"] as? String ,
                let timeout = args["timeout"] as? Int {
                    result(create(sid: sid, account: account, password: password, timeout: timeout))
                } else {
                    result(FlutterError.init(code: "error", message: "value nil", details: nil))
                }
        case "reconnect":
            if let args = call.arguments as? Dictionary<String, Any>,
                            let sid = args["sid"] as? String {
                                reConnect(sid: sid)
                                result(nil)
                            } else {
                                result(FlutterError.init(code: "error", message: "value nil", details: nil))
                            }
        case "close":
            if let args = call.arguments as? Dictionary<String, Any>,
                let sid = args["sid"] as? String {
                    close(sid: sid)
                    result(nil)
                } else {
                    result(FlutterError.init(code: "error", message: "value nil", details: nil))
                }
        case "closeAll":
            closeAll()
            result(nil)
        case "getPort":
            if let args = call.arguments as? Dictionary<String, Any>,
                let sid = args["sid"] as? String ,
                let from = args["from"] as? Int{
                    result(getPort(sid: sid, from: from))
                } else {
                    result(FlutterError.init(code: "error", message: "value nil", details: nil))
                }
        case "initAudioTalk":
           if let args = call.arguments as? Dictionary<String, Any>,
                let audioCode = args["audioCode"] as? Int,
                let audioFormat = args["audioFormat"] as? Int,
                let audioRate = args["audioRate"] as? Int {
                let ret = initAudioTalk(audioType: audioCode, audioFormat: audioFormat, audioRate: audioRate)
                    result(ret)
                } else {
                    result(FlutterError.init(code: "error", message: "value nil", details: nil))
                }
        case "closeAudio":
            closeAudio();
           result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    

    private var mP2PList : Dictionary<String, OBDeviceManager> = Dictionary<String, OBDeviceManager>()
  
    private func getManager(sid :String) -> OBDeviceManager? {
        return mP2PList[sid]
    }
  
    private func create(sid :String , account :String?, password :String? , timeout: Int) -> Bool {
        var manager : OBDeviceManager? = getManager(sid: sid)
        
        if (manager == nil) {

            if (account != nil && password != nil && account!.count > 0 && password!.count > 0) {
                manager = OBDeviceManager(sid: sid,
                                                      account: account,
                                                      password: password,
                                                      timeout: timeout)
            } else {
                manager = OBDeviceManager(sid: sid, timeout: timeout)
            }


            mP2PList[sid] = manager
        }
        
        let type = manager?.getP2PType() ?? -1
        if (type < 0) {
            DispatchQueue.main.async {
                manager?.onNetworkChange(M2MNetworkStatus.NetworkStatusReachableViaWiFi)
            }
        }
        
        return (type > 0)
    }

    private func reConnect(sid: String) {
        let manager : OBDeviceManager? = getManager(sid: sid)
        if (manager != nil) {
            let type = manager?.getP2PType() ?? -1
            if (type < 0) {
                DispatchQueue.main.async {
                    manager?.onNetworkChange(M2MNetworkStatus.NetworkStatusReachableViaWiFi)
                }
            }
        }
    }

    private func close(sid: String) {
        let manager : OBDeviceManager? = getManager(sid: sid)
        
        if (manager != nil) {
            manager!.release();
            mP2PList.removeValue(forKey: sid)
        }

    }
    
    private func closeAll() {
        for manager in mP2PList.values {
            manager.release();
        }
        
        mP2PList.removeAll();
    }

    private func getConnectType(sid: String) -> Int {
        let manager : OBDeviceManager? = getManager(sid: sid)
        if (manager != nil) {
            return manager!.getP2PType()
        }

        return -1
    }

    private func getPort(sid: String, from :Int) -> Int{
        let manager : OBDeviceManager? = getManager(sid: sid)
        if (manager != nil) {
            return manager!.getLocalPort(from)
        }
        
        return -1
    }

    private func sendEvent(key: String, data: String) {
        let payload: [String: String] = ["key": key, "audioData": data]

        guard
            let jsonData = try? JSONSerialization.data(withJSONObject: payload),
            let jsonString = String(data: jsonData, encoding: .utf8)
        else {
            print("🔴 Failed to serialize event: \(key)")
            return
        }

        eventChannel.events?(jsonString)
    }

    private func initAudioTalk(audioType: Int, audioFormat: Int, audioRate: Int) -> Int {
        if (audioTalk == nil) {
            audioTalk = AudioTalk()
            audioTalk?.onRecordData = { data in
                let base64 = data.base64EncodedString()
                self.sendEvent(key: "audioData", data: base64)
            }
        }

        return audioTalk!.initAudioTalk(audioCode: audioType, audioFormat: audioFormat, audioRate: Double(audioRate))
    }

    private func closeAudio() -> Void {
        audioTalk?.closeAudio()
    }
}

public class M2MEventChannel :NSObject, FlutterStreamHandler {

    var events:FlutterEventSink?

    public func setupEventChannel(name: String , messenger: FlutterBinaryMessenger) {
        let channel = FlutterEventChannel(name: name,
                                          binaryMessenger: messenger)
        channel.setStreamHandler(self)
    }

    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.events = events
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.onChangeNotification(notification:)),
                                               name: Notification.Name("NOTIFICATION_P2P_STATUS_CHANGE"), object: nil)

        return nil;
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        NotificationCenter.default.removeObserver(self,
                                                  name: Notification.Name("NOTIFICATION_P2P_STATUS_CHANGE"),
                                                  object: nil)
        self.events = nil
        return nil;
    }

    @objc func onChangeNotification(notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let sid = userInfo["KEY_SID"] as? String,
            let type = userInfo["KEY_TYPE"] as? Int,
            let code = userInfo["KEY_ERROR_CODE"] as? Int
        else {
            return
        }

        let newData: [String: String] = [
            "key": "m2m_status_change",
            "sid": sid,
            "p2pType": String(type),
            "errorCode": String(code)
        ]

        guard
            let jsonData = try? JSONSerialization.data(withJSONObject: newData),
            let jsonString = String(data: jsonData, encoding: .utf8)
        else {
            return
        }

        events?(jsonString)
    }

}
