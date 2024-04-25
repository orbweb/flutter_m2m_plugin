import Flutter
import UIKit
import M2MKit

public class M2mPlugin: NSObject, FlutterPlugin{


    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "com.orbweb.m2m_plugin", binaryMessenger: registrar.messenger())
        let instance : M2mPlugin = M2mPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)

        let eventChannel : M2MEventChannel = M2MEventChannel.init()
        eventChannel.setupEventChannel(name: "com.orbweb.demo/event", messenger: registrar.messenger())
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as? Dictionary<String, Any>

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
            result(OBDeviceManager.uninitializeSDK())
        case "setupLog":
            if let args = call.arguments as? Dictionary<String, Any>,
               let value = args["value"] as? Bool {
                    result(OBDeviceManager.setupLog(value))
                } else {
                    result(FlutterError.init(code: "error", message: "value nil", details: nil))
                }
        case "setUsedDomainName":
            if let args = call.arguments as? Dictionary<String, Any>,
               let value = args["value"] as? Bool {
                    result(OBDeviceManager.setUsedDomainName(value))
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
            if (account != nil && password != nil && account?.count > 0 && password?.count > 0) {
                manager = OBDeviceManager(sid: sid,
                                                      account: account,
                                                      password: password,
                                                      timeout: timeout)
            } else {
                manager = OBDeviceManager(sid: sid, timeout: timeout)
            }


            mP2PList[sid] = manager
        }
        
        var type = manager?.getP2PType() ?? -1
        if (type < 0) {
            DispatchQueue.main.async {
                manager?.onNetworkChange(M2MNetworkStatus.NetworkStatusReachableViaWiFi)
            }
        }
        
        return (type > 0)
    }

    private func reConnect(sid: String) {
        var manager : OBDeviceManager? = getManager(sid: sid)
        if (manager != nil) {
            var type = manager?.getP2PType() ?? -1
            if (type < 0) {
                DispatchQueue.main.async {
                    manager?.onNetworkChange(M2MNetworkStatus.NetworkStatusReachableViaWiFi)
                }
            }
        }
    }

    private func close(sid: String) {
        var manager : OBDeviceManager? = getManager(sid: sid)
        
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
    
    private func getPort(sid: String, from :Int) -> Int{
        var manager : OBDeviceManager? = getManager(sid: sid)
        if (manager != nil) {
            return manager!.getLocalPort(from)
        }
        
        return -1
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
        let userInfo = notification.userInfo
        if (userInfo != nil) {

            let sid = userInfo!["KEY_SID"] as! String;
            let type = userInfo!["KEY_TYPE"] as! Int;
            let code = userInfo!["KEY_ERROR_CODE"] as! Int;
            var newData = [String : String]();
            newData = ["sid": sid, "p2pType": String(type), "errorCode": String(code)];

            guard let jsonData = try? JSONSerialization.data(withJSONObject: newData as Any) else {
                return ;
            }

            guard let jsonString = String(data: jsonData, encoding: .utf8) else {
                return ;
            }

            //print(jsonString);

            if (self.events != nil) {
                self.events!(jsonString);
            }

        }
    }
}

